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
  <xsl:param name="timestamp"/>
  <xsl:param name="locale"/>
  
  <xsl:variable name="full-export" select="if ($full = 'true') then true() else false()"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="update-last-transmit">
          update customer_locale_export
             set lasttransmit = to_date('<xsl:value-of select="$timestamp"/>','YYYYMMDDHH24MISS')
               , flag=0
           where customer_id = '<xsl:value-of select="$channel"/>'
             and locale = '<xsl:value-of select="$locale"/>'
             and flag > 0
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>