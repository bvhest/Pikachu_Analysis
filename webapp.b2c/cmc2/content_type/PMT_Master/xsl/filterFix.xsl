<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Filters/Purpose/Features/Feature">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not (local-name()='code')]" />
      <xsl:variable name="fc" select="@code" />
      <xsl:variable name="fic" select="../../../../FeatureImage[starts-with(FeatureCode,$fc)]/FeatureCode" />
      <xsl:choose>
        <xsl:when test="$fic">
          <xsl:attribute name="code"><xsl:value-of select="$fic" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="code"><xsl:value-of select="$fc" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
