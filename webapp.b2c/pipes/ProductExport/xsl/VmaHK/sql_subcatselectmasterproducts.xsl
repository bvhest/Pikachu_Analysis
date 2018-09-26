<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="locale"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="selectsubcat">no</xsl:param>    
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
    <xsl:copy-of select="."/>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='MASTER'
        </sql:query>
      </sql:execute-query>
      <!-- -->
      <xsl:choose>
        <xsl:when test="$selectsubcat = 'yes'">
          <xsl:call-template name="selectsubcats"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="select">
            <xsl:with-param name="subcat" select="''"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template name="selectsubcats">        
    <xsl:for-each select="//subcat">
      <xsl:call-template name="select">
        <xsl:with-param name="subcat" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>   
  <!-- -->
  <xsl:template name="select">        
    <xsl:param name="subcat"/>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, flag)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , 'MASTER'
                    , o.object_id
                    , 0
               from OCTL o             
         inner join CHANNELS ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
                and cc.locale = o.localisation
                and cc.enabled = 1
                and o.content_type = 'PMT'
                and o.status = 'Final Published'
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                and co.COUNTRY= substr(cc.locale,4,2)
 <xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
         inner join vw_object_categorization oc 
                 on oc.object_id = o.object_id
                and oc.subcategory = '<xsl:value-of select="."/>'     
                and oc.source != 'ProductTree' 
				and oc.catalogcode = cc.catalog_type              
</xsl:if>  
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and cle.locale='MASTER'
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT CLE
           set flag=1
         where locale = 'MASTER'
           and customer_id = '<xsl:value-of select="$channel"/>'
           and ctn in
                    (select o.object_id
                       from octl o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
                     inner join vw_object_categorization oc 
                             on oc.object_id = o.object_id
                            and oc.subcategory = '<xsl:value-of select="."/>'     
                            and oc.source != 'ProductTree'                
                            and oc.catalogcode = 'CONSUMER'            
</xsl:if>                                      
                 inner join channels ch
                         on ch.name =  '<xsl:value-of select="$channel"/>'
                 inner join channel_catalogs cc
                         on ch.id = cc.customer_id
                        and cc.locale = o.localisation
                        and cc.enabled = 1
                        and o.content_type = 'PMT'
                        and o.status = 'Final Published'
                 inner join object_master_data omd
                         on o.object_id = omd.object_id
                        and omd.division = cc.division
                        and omd.product_type = cc.product_type                        
                 inner join catalog_objects co
                         on co.object_id = o.object_id
                        and co.COUNTRY=substr(o.localisation,4,2)
                        and ((ch.catalog = 'ALL' and co.customer_id != 'CARE') or co.CUSTOMER_ID=cc.catalog_type)
                        and sysdate - 730 &lt; co.EOP
                        and co.DELETED = 0
                      where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit))
                      --and cle.ctn = '42PFL9900D/10'
      </sql:query>
    </sql:execute-query>
</xsl:template>
</xsl:stylesheet>