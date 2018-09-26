<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="batchnumber"/>

  <xsl:template match="/">
    <RenderProducts DocTimeStamp="{$timestamp}" XSDVersion="'1.8'">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
                SELECT o.object_id ID
                     , decode(o.status, 'PLACEHOLDER', 'Preliminary Published', o.status) as status
                     
                     , DECODE(O.STATUS, 'PLACEHOLDER', 'master_'||SUBSTR(CLE.LOCALE, -2), CLE.LOCALE) LOCALE
                     , DECODE(O.STATUS, 'PLACEHOLDER', 'PMT_Localised', O.CONTENT_TYPE) CONTENT_TYPE  
                     
                     , TO_CHAR(mv.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                     , TO_CHAR(mv.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
                     , TO_CHAR(mv.sos,'yyyy-mm-dd"T"hh24:mi:ss') as sos
                     , TO_CHAR(mv.eos,'yyyy-mm-dd"T"hh24:mi:ss') as eos
                     , o.masterlastmodified_ts MASTERLASTMODIFIED
                     , o.lastmodified_ts LASTMODIFIED
                     , cast(((o.lastmodified_ts - cast('01-JAN-1970' as date)) * 86400) -7200 as integer)  as TIMESTAMP
                     , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                     , cc.catalog_type  categorization_catalogtype
             <xsl:choose>
               <xsl:when test="$locale='master_global'">
                     , o.data
             </xsl:when>
             <xsl:otherwise>
                     , CASE
                        WHEN O.STATUS = 'PLACEHOLDER' THEN (
                            SELECT DATA
                            		FROM   OCTL
                            		WHERE  OBJECT_ID = O.OBJECT_ID 
                            		AND    CLE.CUSTOMER_ID = '<xsl:value-of select="$channel"/>'
                            		AND    CLE.LOCALE = '<xsl:value-of select="$locale"/>' 
                            		AND    LOCALISATION = 'master_'||SUBSTR(CLE.LOCALE, -2)) 
                        ELSE O.DATA
                     END AS DATA
               </xsl:otherwise>
             </xsl:choose>  
                  FROM customer_locale_export cle 
                 INNER JOIN octl o
             <xsl:choose>
               <xsl:when test="$locale = 'master_global'">
                 ON o.content_type = 'PMT_Master'
               </xsl:when>
               <xsl:otherwise>
                 ON o.content_type in ('PMT', 'PMT_Localised')
               </xsl:otherwise>
             </xsl:choose>

               AND o.object_id = cle.ctn
               AND o.localisation = cle.locale
        INNER JOIN channels c 
                ON c.NAME = '<xsl:value-of select="$channel"/>/delta' 
        INNER JOIN channel_catalogs cc
                ON cc.customer_id  = c.ID
               AND cc.locale =  cle.locale
               AND cc.enabled = 1
<xsl:choose>
   <xsl:when test="$locale = 'master_global'">
          LEFT OUTER JOIN mv_co_object_id mv
   </xsl:when>
   <xsl:otherwise>
          INNER JOIN mv_co_object_id mv
   </xsl:otherwise>
</xsl:choose>  
                  ON mv.object_id  = cle.ctn
                 AND mv.deleted    = 0
               WHERE cle.customer_id  = '<xsl:value-of select="$channel"/>'
                 AND cle.locale       = '<xsl:value-of select="$locale"/>' 
                 AND cle.batch        = <xsl:value-of select="$batchnumber"/> 
                 AND cle.flag         = 1
            order by cle.ctn
          </sql:query>
          
           <sql:execute-query>
	          <sql:query name="Local_Price">
	               SELECT CO.LOCAL_GOING_PRICE as LOCAL_GOING_PRICE,
	               		  LL.CURRENCY_CODE AS CURRENCY_CODE   
	                 FROM CATALOG_OBJECTS CO
		                 INNER JOIN LOCALE_LANGUAGE LL
	       				 ON LL.COUNTRY = CO.COUNTRY
	                 WHERE co.OBJECT_ID = '<sql:ancestor-value name="id" level="1"/>'
	                 AND co.COUNTRY = '<xsl:value-of select="substring($locale,4,2)"/>'
	                 AND CUSTOMER_ID = 'CONSUMER'
	                 AND ROWNUM = 1				
	          </sql:query>
           </sql:execute-query>
          
        <sql:execute-query>
          <sql:query name="cat">
                select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                    from categorization c
              inner join vw_object_categorization oc 
                      on oc.subcategory = c.subcategorycode  
                     and oc.catalogcode = c.catalogcode        
                   where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                     and oc.catalogcode = '<sql:ancestor-value name="categorization_catalogtype" level="1"/>'
                     and rownum = 1
                 UNION 
                 select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, c.catalogcode, c.bgroupname, c.bgroupcode
                    from categorization c
              inner join vw_object_categorization oc 
                      on oc.subcategory = c.subcategorycode  
                     and oc.catalogcode = c.catalogcode        
                   where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                     and oc.catalogcode = 'ProductTree'
                     and rownum = 1  
          </sql:query>
        </sql:execute-query>
        </sql:execute-query>
    </RenderProducts>
  </xsl:template>
</xsl:stylesheet>