<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  exclude-result-prefixes="sql"
  >
  
  <xsl:param name="timestamp"/>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <i:include src="{concat('cocoon:/processBatch/', $timestamp, '/', sql:batch)}"/>
  </xsl:template>
</xsl:stylesheet>