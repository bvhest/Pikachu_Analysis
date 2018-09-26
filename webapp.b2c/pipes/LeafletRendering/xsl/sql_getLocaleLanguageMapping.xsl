<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="dir:directory">
    <root>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
      <sql:execute-query>
        <sql:query>
          select locale, ccr_language_code from locale_language   
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>