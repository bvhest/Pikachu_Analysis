<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:b2b="http://pww.pikachu.philips.com/b2b/function/1.0" 
    extension-element-prefixes="b2b">

  <xsl:import href="../../../../xsl/common/xucdm_product_marketing_1_2_normalize.xsl"/>
  <xsl:include href="../../../../xsl/common/b2b.functions.xsl"/>
  
  <xsl:variable name="locales_no_greentick" select="('en_US','en_CA','fr_CA')"/>
  <xsl:variable name="award_code_greentick" select="'LP_GA_GREENTICK'"/>
  
  <!-- Normalize whitespace -->
  <xsl:template match="MarketingTextHeader">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Fix values with min/nom/max string
    Examples:
    0.5 (min), 0.75 (nom), 1.0 (max)  -> 0.5 (min), 0.75 (nom), 1.0 (max)
    0.5 (min), 0.75 (nom)             -> 0.5 (min), 0.75 (nom)
    - (min), 0.75 (nom), - (max)      -> 0.75
    0.75 (nom)                        -> 0.75
    0.5 (min), 1.0 (max)              -> 0.5 (min), 1.0 (max)
    - (min), - (max)                  -> 
    - (min), 0.75 (nom)               -> 0.75
    0.5 (min)                         -> 0.5
    1.0 (max)                         -> 1.0
  -->
  <xsl:template match="CSValueName[ matches( text(), '^[-\d.]+ \((min|nom|max)\)(, [-\d.]+ \((min|nom|max)\))*$' ) ]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="parts" select="tokenize(text(), ', ')[not(starts-with(.,'- '))]"/>
      <xsl:choose>
        <xsl:when test="count($parts) &gt; 1">
          <xsl:value-of select="string-join($parts, ', ')"/>
        </xsl:when>
        <xsl:when test="count($parts) = 1">
          <xsl:value-of select="substring-before($parts[1], ' ')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="CSValueName[ not( matches( text(), '^[-\d.]+ \((min|nom|max)\)(, [-\d.]+ \((min|nom|max)\))*$' ) ) ]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Fix family codes. See b2b.functions.xsl -->
  <xsl:template match="NamingString/Family/FamilyCode">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="b2b:fix-family-code(text())"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ProductClusters/ProductCluster[@type='family']/@code">
    <xsl:attribute name="code" select="b2b:fix-family-code(.)"/>
  </xsl:template>
  
  <xsl:template match="MasterSEOProductName"/>

  <xsl:template match="Award[ancestor::Product/@Locale=$locales_no_greentick][@AwardType='global'][AwardCode=$award_code_greentick]"/>
</xsl:stylesheet>
