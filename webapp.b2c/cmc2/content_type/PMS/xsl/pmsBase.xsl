<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Ignore deleted products -->
  <xsl:template match="entry/content" priority="1">
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="entry/content[Product/@is-deleted='true']" priority="2">
    <xsl:copy copy-namespaces="no">
      <Product is-deleted="true"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>