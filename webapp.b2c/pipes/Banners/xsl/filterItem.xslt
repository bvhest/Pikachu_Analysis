<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml content_overview.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:variable name="item" select="/root/main/root/item"/>
  <!-- -->
  <xsl:template match="//row[Name = $item]">
    <xsl:copy-of select="." copy-namespaces="no"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="//row[Name ne $item]">
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
