<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()" />
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="entry">
    <xsl:copy copy-namespaces="no">
	<xsl:copy-of select="@*|result"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
