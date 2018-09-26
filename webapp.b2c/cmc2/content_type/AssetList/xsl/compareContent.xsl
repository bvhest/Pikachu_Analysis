<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="AssetsToCompare">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="deep-equal(ProductsMsg[1]/Product,ProductsMsg[2]/Product)">
          <remove ctn="{ProductsMsg[1]/Product/CTN}"/>
        </xsl:when>
        <xsl:otherwise>
          <keep ctn="{ProductsMsg[1]/Product/CTN}">
            <xsl:apply-templates select="store"/>
          </keep>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="root">
    <FilterAssets>
      <xsl:choose>
         <xsl:when test="deep-equal(delta/ProductsMsg/Product,cache/ProductsMsg/Product)">
           <remove ctn="{delta/ProductsMsg/Product/CTN}"/>
         </xsl:when>
         <xsl:otherwise>
           <keep ctn="{delta/ProductsMsg/Product/CTN}">
            <xsl:apply-templates select="store"/>
          </keep>
         </xsl:otherwise>
      </xsl:choose>
    </FilterAssets>
  </xsl:template>  
</xsl:stylesheet>
