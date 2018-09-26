<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="/ProductsMsg">
    <xsl:variable name="assets" select="."/>
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:for-each-group select="Product" group-by="CTN">
        <xsl:sort select="CTN"/>
        <Product>
          <CTN><xsl:value-of select="current-grouping-key()"/></CTN>
          <xsl:for-each select="$assets/Product[CTN=current-grouping-key()]/Asset">
            <xsl:sort select="Language"/>
            <xsl:sort select="ResourceType"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </Product>
      </xsl:for-each-group>
    </xsl:copy>    
  </xsl:template>
</xsl:stylesheet>