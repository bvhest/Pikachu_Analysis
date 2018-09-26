<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:param name="channel" />
  <xsl:param name="locale" />
  <xsl:param name="exportdate" />
  
   <!-- xsl:variable name="DoctypesDoc" select="document(../../../cmc2/xml/doctypeAttributes)"/ -->
  <xsl:variable name="fulldate">
    <xsl:value-of select="substring($exportdate,1,4)" />
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring($exportdate,5,2)" />
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring($exportdate,7,2)" />
    <xsl:text>T</xsl:text>
    <xsl:value-of select="substring($exportdate,10,2)" />
    <xsl:text>:</xsl:text>
    <xsl:value-of select="substring($exportdate,12,2)" />
    <xsl:text>:00</xsl:text>
  </xsl:variable>
  <xsl:variable name="doctype-channel" select="$channel" />

  <xsl:template match="/">
    <root>

      <sql:execute-query>
        <sql:query name="Product">
          select  o.object_id ID
                , TO_CHAR(mv.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop
                , TO_CHAR(mv.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop
                , TO_CHAR(mv.sos,'yyyy-mm-dd"T"hh24:mi:ss') as sos
                , TO_CHAR(mv.eos,'yyyy-mm-dd"T"hh24:mi:ss') as eos
                , o.masterlastmodified_ts MASTERLASTMODIFIED
                , o.lastmodified_ts LASTMODIFIED
                , cast(((o.lastmodified_ts - cast('01-JAN-1970' as date)) * 86400) -7200 as integer) as TIMESTAMP
                , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
                , cc.catalog_type categorization_catalogtype
                , o.localisation locale
                , o.DATA
          from CUSTOMER_LOCALE_EXPORT cle
          
          INNER JOIN octl o
          <xsl:choose>
            <xsl:when test="$locale = 'master_global'">
              ON o.content_type = 'PMT_Master'
            </xsl:when>
            <xsl:otherwise>
              ON o.content_type = 'PMT'
            </xsl:otherwise>
          </xsl:choose>
            AND o.object_id = cle.ctn
            AND o.localisation = cle.locale
            
          INNER JOIN channels c
             ON c.NAME = '<xsl:value-of select="$channel" />'
          
          INNER JOIN channel_catalogs cc
             ON cc.customer_id = c.ID
            AND cc.locale = cle.locale
            AND cc.enabled = 1
          
          INNER JOIN mv_co_object_id mv
             ON mv.object_id = o.object_id
            AND mv.deleted = 0
          
          WHERE cle.customer_id='<xsl:value-of select="$channel" />'
            and cle.locale = '<xsl:value-of select="$locale" />'
            and cle.flag = 1 
            <!-- and rownum &lt; 2 -->
          order by cle.ctn
        </sql:query>
        <sql:execute-query>
          <sql:query name="cat">
            select c.catalogcode, c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname
            from categorization c
            
            inner join vw_object_categorization oc
               on oc.subcategory = c.subcategorycode
              and oc.catalogcode = c.catalogcode
            
            where oc.object_id = '<sql:ancestor-value name="id" level="1" />'
              and oc.catalogcode in ('MASTER', 'CONSUMER')
          </sql:query>
        </sql:execute-query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
