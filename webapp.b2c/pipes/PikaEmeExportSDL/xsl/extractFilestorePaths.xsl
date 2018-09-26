<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="/root">
    <xsl:apply-templates select="sql:rowset/sql:row/sql:data"/>
  </xsl:template>
  
  <xsl:template match="sql:data">
    <xsl:value-of select="concat(text(),'.xml')" />
     <!-- NEWLINE -->
    <xsl:text>
</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>