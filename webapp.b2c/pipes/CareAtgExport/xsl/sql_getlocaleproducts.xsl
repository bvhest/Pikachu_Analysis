<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">

   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

   <xsl:param name="channel"/>
   <xsl:param name="contentType"/>   
   <xsl:param name="batchnumber"/>
   <xsl:param name="locale"/>
   <xsl:param name="delta"/>
  
  <xsl:template match="/">
    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
            select o.object_id id
                 , '<xsl:value-of select="$locale"/>' as locale
                 , TO_CHAR(mv.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                 , TO_CHAR(mv.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop 
                 , DECODE(mv.deleted, 1, 'true', 0, 'false') as deleted
                 , TO_CHAR(mv.delete_after_date,'yyyy-mm-dd"T"hh24:mi:ss') as delete_after_date
                 , 'CLS'  as division
                 , 'CARE'  AS catalog
                 , sc.groupcode AS groupcode 
                 , sc.groupname AS groupname
                 , sc.categorycode AS categorycode 
                 , sc.categoryname AS categoryname
                 , sc.subcategorycode AS subcategorycode
                 , sc.subcategoryname AS subcategoryname
                 , cle.lasttransmit AS lastexportdate
                 , o.data AS data
                 , 'dummy' AS asset_data
              from customer_locale_export cle
             inner join octl o 
                on o.content_type = '<xsl:value-of select="$contentType"/>' 
               and o.localisation = cle.locale 
               and o.object_id    = cle.ctn
<xsl:choose>
   <xsl:when test="$locale='master_global' ">
             inner join mv_co_object_id_care mv 
                on mv.object_id   = o.object_id
   </xsl:when>
   <xsl:otherwise>
             inner join mv_co_object_id_country_care mv 
                on mv.object_id   = o.object_id 
               and mv.country     = '<xsl:value-of select="substring-after($locale,'_')"/>'
   </xsl:otherwise>
</xsl:choose>
             inner join vw_object_categorization oc 
                on oc.object_id    = o.object_id 
               and oc.catalogcode  = 'CARE'
             inner join categorization sc 
                on sc.subcategorycode = oc.subcategory 
               and sc.catalogcode  = oc.catalogcode                   
             where cle.customer_id = '<xsl:value-of select="$channel"/>'
               and cle.locale      = '<xsl:value-of select="$locale"/>'
<xsl:choose>
   <xsl:when test="$delta='y'">and cle.flag = 1</xsl:when>
   <xsl:otherwise>and cle.batch = <xsl:value-of select="$batchnumber"/> </xsl:otherwise>
</xsl:choose>
               and o.status       != 'PLACEHOLDER' -- should never be possible as those records with flag=1 or batch>0 have been selected based on o.status in ('Final Published','Loaded')...
    </sql:query>
 
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
