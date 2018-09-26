<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="threshold"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <!-- xsl:when test="count(FilterProduct/modified) gt number($threshold)" -->
        <xsl:when test="count(FilterProduct/modified) gt 0">
          <xsl:apply-templates select="FilterProduct/modified" mode="compare"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="FilterProduct/modified"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="FilterProduct/identical"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FilterProduct/modified" mode="compare">
    <i:include src="cocoon:/performSecondaryComparison/{text()}.xml"/>
  </xsl:template>
</xsl:stylesheet>