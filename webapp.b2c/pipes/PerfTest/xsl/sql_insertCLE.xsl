<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale"/>
  <xsl:param name="channel"/>
  <xsl:param name="rundate"/>
  <xsl:param name="mode"/>  
  <xsl:template match="/">
    <root>
    <!-- set flag to 1 if the export was before the last modified date -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
   insert into customer_locale_export (customer_id, locale, ctn, lasttransmit)
   values ('<xsl:value-of select="$channel"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="concat($rundate,':',$mode)"/>', sysdate)
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>