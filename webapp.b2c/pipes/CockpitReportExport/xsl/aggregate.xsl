<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="ROW/text()"/>
  <xsl:template match="ProductEnhancementContent">
    <Product-Enhancement-Content>
      <xsl:choose>
             <xsl:when test="DescriptorName=1 
                    and WOW=1 
                    and MarketingTextHeader=1
                    and StandardProductPhotograph + FrontProductPhotograph  >=1
                    and GAL >= 5
                    and MainInUsePhotograph >= 1
                    and KBA >= 2
                    and FeatureName >= 4 
                    and FeatureGlossary >= 4
                    and FeatureImages+FeatureMovies  >=4
                    and FeatureMovies >= 1
                    and Product-360 >=1 
                    and Product-Videos >= 1">3-MCI</xsl:when>
        <xsl:when test="DescriptorName=1 
                    and WOW=1 
                    and MarketingTextHeader=1
                    and StandardProductPhotograph + FrontProductPhotograph  >=1
                    and GAL >= 4
                    and KBA >= 2
                    and FeatureName >= 4 
                    and FeatureGlossary >= 4
                    and FeatureImages+FeatureMovies >=4
                    and Product-360 >=1 
                    and Product-Videos >= 1">2-Key product</xsl:when>
        <xsl:when test="DescriptorName=1 
                    and WOW=1 
                    and MarketingTextHeader=1
                    and StandardProductPhotograph + FrontProductPhotograph  >=1
                    and GAL >= 3
                    and KBA >= 1
                    and FeatureName >= 4">1-Other product</xsl:when>
        <xsl:when test="DescriptorName=1 
                    and WOW=1 
                    and MarketingTextHeader=1
                    and StandardProductPhotograph + FrontProductPhotograph  >=1
                    and GAL >= 1">0-Accessory</xsl:when>
        <xsl:when test="DescriptorName=1 
                    and WOW=1">Code Only</xsl:when>
        <xsl:otherwise>Code Only</xsl:otherwise>
      </xsl:choose>
      <!--xsl:copy-of select="."/-->
    </Product-Enhancement-Content>
  </xsl:template>
</xsl:stylesheet>
