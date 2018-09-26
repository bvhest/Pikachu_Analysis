<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <report name="changed-products">
      <xsl:apply-templates />
    </report>
  </xsl:template>
  
  <xsl:template match="FilterProduct">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="FilterProduct/identical">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="keep" select="'true'"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>