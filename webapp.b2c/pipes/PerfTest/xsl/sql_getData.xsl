<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale"/>
  <xsl:template match="/">
    <Products timestamp="{current-dateTime()">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="getdata">
              select *
                from octl o
               where o.content_type = 'PMT'
                 and o.localisation = '<xsl:value-of select="$locale"/>'
                 and NVL(o.status, 'XXX') != 'PLACEHOLDER'
                 -- and rownum &lt; 50
        </sql:query>
      </sql:execute-query>        
    </Products>
  </xsl:template>
</xsl:stylesheet>
