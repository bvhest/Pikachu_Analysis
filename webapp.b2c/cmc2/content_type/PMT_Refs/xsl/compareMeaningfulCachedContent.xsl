<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:template match="Files2Compare">
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="Products[1]/Product/*" mode="copy"/>
    </xsl:variable>
    <xsl:variable name="newContent">
      <xsl:apply-templates select="Products[2]/Product/*" mode="copy"/>
    </xsl:variable>
    <FilterProduct>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="Products[1]/Product/CTN"/></identical>
        </xsl:when>
        <xsl:otherwise>not equal</xsl:otherwise>
      </xsl:choose>
    </FilterProduct>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
  <!-- Ignore whitespace-only nodes -->    
  <xsl:template match="text()[normalize-space() = '']" mode="copy"/>
  <!-- -->
  <xsl:template match="Product" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates select="node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>  
</xsl:stylesheet>
