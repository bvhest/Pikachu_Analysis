<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <!--xsl:template match="AssetsToCompare">
    <FilterAssets>
      <xsl:choose>
        <xsl:when test="deep-equal(ProductsMsg[1]/Product,ProductsMsg[2]/Product)"><CTN><xsl:value-of select="ProductsMsg[1]/Product/CTN"/></CTN></xsl:when>
        <xsl:otherwise>not equal</xsl:otherwise>
      </xsl:choose>
    </FilterAssets>
  </xsl:template-->

  <xsl:template match="AssetsToCompare">
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="ProductsMsg[1]/Product/*" mode="copy"/>
    </xsl:variable>
    <xsl:variable name="newContent">
      <xsl:apply-templates select="ProductsMsg[2]/Product/*" mode="copy"/>
    </xsl:variable>
    <FilterAssetsXML>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="ProductsMsg[1]/Product/CTN"/></identical>
        </xsl:when>
        <xsl:otherwise><notequal><xsl:value-of select="ProductsMsg[1]/Product/CTN"/></notequal></xsl:otherwise>
      </xsl:choose>
    </FilterAssetsXML>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="object" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="copy"/>
      <xsl:apply-templates select="node()[local-name()!='Asset']" mode="copy"/>
      <xsl:apply-templates select="Asset" mode="copy">
        <xsl:sort select="ResourceType"/>
        <xsl:sort select="Language"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>  
  
  
</xsl:stylesheet>
