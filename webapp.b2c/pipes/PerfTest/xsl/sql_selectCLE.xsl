<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale"/>
  <xsl:param name="channel"/>
  <xsl:param name="rundate"/>
  <xsl:template match="/">
    <root>
    <!-- set flag to 1 if the export was before the last modified date -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
   select customer_id, locale, ctn, to_char(lasttransmit,'YYYY-MM-DD"T"HH24:MI:SS') LASTTRANSMIT from customer_locale_export 
   where customer_id = '<xsl:value-of select="$channel"/>'
   and locale = '<xsl:value-of select="$locale"/>'
   and ctn like '<xsl:value-of select="$rundate"/>%'
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>