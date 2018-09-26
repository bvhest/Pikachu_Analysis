<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  exclude-result-prefixes="sql"
  >
    
  <xsl:template match="/root">
    <xsl:apply-templates select="sql:rowset/sql:row"/>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:variable name="ts" select="replace(substring-before(sql:startexec,'.'),'[^\d]','')"/>
    
    <i:include>
      <xsl:attribute name="src">
        <xsl:text>cocoon:/main/</xsl:text>
        <xsl:value-of select="$ts"/>
      </xsl:attribute>
    </i:include>
  </xsl:template>
</xsl:stylesheet>