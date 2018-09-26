<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="xs">

  <xsl:param name="channel"/>
  <xsl:param name="content-type"/>
  <xsl:param name="batch-size"/>
  <xsl:param name="batch-num"/>

  <xsl:variable name="l-batch-size" select="if (matches($batch-size,'\d+') and number($batch-size) le 100) then number($batch-size) cast as xs:integer else 100"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          select ctn object_id, locale localisation, data, to_char(sop,'YYYYMMDD') sop, to_char(eop,'YYYYMMDD') eop
          from (
            select ceil(rownum/<xsl:value-of select="$batch-size"/>) batchnum
                 , cle.ctn, cle.locale, o.data
                 , min(co.sop) sop, max(co.eop) eop
            from customer_locale_export cle
            inner join channels ch
               on ch.name=cle.customer_id
              and ch.name='<xsl:value-of select="$channel"/>'
            inner join octl o 
               on o.object_id=cle.ctn
              and o.localisation=cle.locale
              and o.content_type='<xsl:value-of select="$content-type"/>'
            inner join catalog_objects co
               on co.object_id=o.object_id
              and co.country=substr(o.localisation, 4)
              and (co.customer_id=ch.catalog or ch.catalog='ALL')
            where cle.flag=1
            group by ceil(rownum/<xsl:value-of select="$batch-size"/>), cle.ctn, cle.locale, o.data
          ) where batchnum=<xsl:value-of select="$batch-num"/>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>