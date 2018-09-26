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
  <!-- -->
  <xsl:variable name="kvpDoc" select="if(doc-available(concat('../',$kvpdocpath))) then doc(concat('../',$kvpdocpath)) else ()"/>  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:variable name="publicationOffset"><xsl:value-of select="if ($channel='FlixMediaProducts') then '45' else '7'"/></xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='<xsl:value-of select="$locale"/>'
             and flag != 0
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
        insert into customer_locale_export(customer_id, locale, ctn, flag)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , o.localisation
                    , o.object_id
                    , 0
               from OCTL o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
         inner join vw_object_categorization oc 
                 on oc.object_id = o.object_id
                and oc.subcategory = '<xsl:value-of select="."/>'     
                and oc.source != 'ProductTree'
                and oc.catalogcode = 'MASTER'                            
</xsl:if>               
         inner join CHANNELS ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
                and cc.locale = o.localisation
                and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                and o.content_type = '<xsl:value-of select="$source"/>'
                and o.localisation='<xsl:value-of select="$locale"/>'
<xsl:if test="not($source='PCT')">               
                and o.status = 'Final Published'
</xsl:if>               
         inner join catalog_objects co
                 on co.object_id = o.object_id
                and co.CUSTOMER_ID=cc.catalog_type
                and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and o.localisation=cle.locale
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
              --BHE testcase: and o.object_id like '29PT55%' or o.object_id = '42PFL3312/10'
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT CLE
             set  flag=1
           where locale = '<xsl:value-of select="$locale"/>'
             and customer_id = '<xsl:value-of select="$channel"/>'
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
                            and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                            and o.content_type = '<xsl:value-of select="$source"/>'
                            and o.localisation='<xsl:value-of select="$locale"/>'
<xsl:if test="$source != 'PCT'">               
                            and o.status = 'Final Published'
</xsl:if>               
            
<xsl:if test="$kvpDoc/keyvaluepairs">
                 inner join keyvaluepairs kvp
                         on kvp.ctn = o.object_id
                 inner join (
<xsl:for-each select="$kvpDoc/keyvaluepairs/keyvaluepair">
select '<xsl:value-of select="key"/>' key<xsl:if test="value != ''">,'<xsl:value-of select="value"/>' value</xsl:if> from dual <xsl:if test="following-sibling::*"> union
</xsl:if></xsl:for-each>) keyvalues
                         on upper(kvp.key) = upper(keyvalues.key)
<xsl:if test="$kvpDoc/keyvaluepairs/keyvaluepair/value[text()!='']">                         
                        and upper(kvp.value) = upper(keyvalues.value)
</xsl:if>                        
</xsl:if>                          
                     inner join catalog_objects co
                             on co.object_id = o.object_id
                            and co.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
                            and co.CUSTOMER_ID=cc.catalog_type
<xsl:if test="$selectall != 'yes'">
  <xsl:choose>
    <xsl:when test="$subcat != '' and string-length($subcat) gt 0">
                            and co.eop &gt; sysdate
                            and co.deleted = 0
                            and co.country is not null
    </xsl:when>
    <xsl:otherwise>                                 
                            and (co.sop - to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                            and (co.eop + 7) &gt; sysdate
    </xsl:otherwise>                                                             
  </xsl:choose>
                          where (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit)
</xsl:if>
                          )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>