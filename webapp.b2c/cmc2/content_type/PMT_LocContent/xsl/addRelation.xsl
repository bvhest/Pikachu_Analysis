<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="secondary">
    <xsl:copy copy-namespaces="no">
      <relation>
        <xsl:text>'PMT','</xsl:text>
        <xsl:value-of select="../@l" />
        <xsl:text>','</xsl:text>
        <xsl:value-of select="../@o" />
        <xsl:text>','</xsl:text>
        <xsl:value-of select="../@ct"/>
        <xsl:text>','</xsl:text>
        <xsl:value-of select="../@l" />
        <xsl:text>','</xsl:text>
        <xsl:value-of select="../@o" />
        <xsl:text>',1,1</xsl:text>
      </relation>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>