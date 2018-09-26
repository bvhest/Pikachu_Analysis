<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="selectsubcat">no</xsl:param>  
  <xsl:param name="kvpdocpath"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>  
  <xsl:param name="secureURL"/>
  <!-- -->
  <xsl:variable name="kvpDoc" select="if(doc-available(concat('../',$kvpdocpath))) then doc(concat('../',$kvpdocpath)) else ()"/>  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="clear cle-table">
            UPDATE CUSTOMER_LOCALE_EXPORT cle
               SET cle.flag         = 0
                 , cle.batch        = 0
             WHERE cle.customer_id  = '<xsl:value-of select="$channel"/>'
               AND cle.locale       = '<xsl:value-of select="$locale"/>'
               AND (cle.flag != 0 OR cle.batch != 0) -- no need to do unnecessary updates
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
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

    <xsl:param name="subcat"/>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, lasttransmit, flag, batch)
             select distinct '<xsl:value-of select="$channel"/>'
                    , o.localisation
                    , o.object_id
                    , to_date('1900-01-01','yyyy-mm-dd')
                    , 0
                    , 0
               from OCTL o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
         inner join vw_object_categorization oc 
                 on oc.object_id    = o.object_id
                and oc.subcategory  = '<xsl:value-of select="."/>'     
                and oc.source      != 'ProductTree'
                and oc.catalogcode  = 'MASTER'                            
</xsl:if>               
         inner join channels ch
                 on ch.name         =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id           = cc.customer_id
                and cc.locale       = o.localisation
                and (cc.enabled = 1 or cc.masterlocaleenabled = 1)
                and o.content_type  = '<xsl:value-of select="$source"/>'
                and o.localisation  = '<xsl:value-of select="$locale"/>'
<xsl:if test="not($source='PCT')">               
                and o.status        = 'Final Published'
</xsl:if>               
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and co.CUSTOMER_ID=cc.catalog_type
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
    left outer join customer_locale_export cle
                 on o.object_ID=cle.ctn
                and o.localisation=cle.locale
                and cle.customer_id='<xsl:value-of select="$channel"/>'
              where cle.customer_id is NULL
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
          update customer_locale_export cle
             set flag = 1
           where locale       = '<xsl:value-of select="$locale"/>'
             and customer_id  = '<xsl:value-of select="$channel"/>'
             and ctn in (select o.object_id
                           from octl o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
                     inner join vw_object_categorization oc 
                             on oc.object_id = o.object_id
                            and oc.subcategory = '<xsl:value-of select="."/>'     
                            and oc.source != 'ProductTree'                
                            and oc.catalogcode = 'MASTER'            
</xsl:if>                                      
                     inner join channels ch
                             on ch.name =  '<xsl:value-of select="$channel"/>'
                     inner join channel_catalogs cc
                             on ch.id = cc.customer_id
                            and cc.locale = o.localisation
                            and (cc.enabled = 1 or cc.masterlocaleenabled = 1)
                            and o.content_type = '<xsl:value-of select="$source"/>'
                            and o.localisation='<xsl:value-of select="$locale"/>'
<xsl:if test="$source != 'PCT'">               
                            and o.status = 'Final Published'
</xsl:if>               
                     inner join object_master_data omd
                             on o.object_id = omd.object_id
                             and cc.PRODUCT_TYPE = omd.Product_TYPE 
<xsl:if test="$source != 'PCT'">               
                            and (omd.division = cc.division or cc.division='ALL')
</xsl:if>               
							inner join catalog_objects co
                 on co.object_id = o.object_id
                and co.CUSTOMER_ID=cc.catalog_type
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
<xsl:if test="$selectall != 'yes'">
  <xsl:choose>
    <xsl:when test="$subcat != '' and string-length($subcat) gt 0">
                            and co.eop &gt; sysdate
                            and co.deleted = 0
    </xsl:when>
    <xsl:otherwise>                                 
                            and (co.sop - ch.PUBLICATIONOFFSET_SOP) &lt; sysdate
                            and (co.eop + ch.PUBLICATIONOFFSET_EOP) &gt; sysdate
                            -- Stop sending deleted products after some time.
                            and (co.deleted = 0 
                              or trunc(sysdate) &lt; nvl(co.delete_after_date,to_date('21000101','yyyymmdd'))
                                )
    </xsl:otherwise>                                                             
  </xsl:choose>

    <xsl:choose>
    <xsl:when test="$secureURL = 'yes'">
    <!-- New condition for secureURL 'yes' -->
    
                           where ( o.lastmodified_ts &gt; cle.lasttransmit
                           or 
                           (co.sop - 7 &gt;  cle.lasttransmit  and  sysdate &gt; co.sop - 7)) 
    </xsl:when>
    <xsl:otherwise> 
    <!-- Existing conidtion -->
                            where o.lastmodified_ts &gt; cle.lasttransmit
    </xsl:otherwise>    
    </xsl:choose>                          
                          
</xsl:if>
                          )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>