<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    exclude-result-prefixes="sql cinclude"
    extension-element-prefixes="cmc2-f">

  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

  <!--
    Fill SEOProductName.
    (Element was inserted in previous transformation.)
  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="SEOProductName">
    <xsl:variable name="isLatin" select="ancestor::entries/@islatin" />
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="$isLatin = '1'">
          <!-- Build SEO product name from the PMT's NamingString -->
          <xsl:apply-templates select="@*" />
          <xsl:attribute name="romanize" select="'true'"/>
          <xsl:value-of select="cmc2-f:deriveSEOProductName(../NamingString)"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Use the SEO product name that was taken from PMT_Master's SEOProductName -->
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
