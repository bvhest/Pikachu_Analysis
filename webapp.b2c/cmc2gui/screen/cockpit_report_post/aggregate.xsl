<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ProductEnhancementContent">
		<Product-Enhancement-Content>
			<xsl:choose>
				<xsl:when test="CTN=1 
										and DescriptorName=1 
										and WOW=1 
										and MarketingTextHeader=1
										and IMS >= 2
										and FeatureName >= 4 
										and FeatureGlossary >= 4
										and FeatureImageLogoDemoMovie >=4
										and FeatureMovie >= 1 
										and KBA >= 3
										and CSI >= 8
										and RichAssets >= 1">3-Rich</xsl:when>
				<xsl:when test="CTN=1 
										and DescriptorName=1 
										and WOW=1 
										and MarketingTextHeader=1
										and IMS >= 2
										and FeatureName >= 4 
										and FeatureGlossary >= 4
										and FeatureImageLogoDemoMovie >=4
										and KBA >= 3
										and CSI >= 8">2-Standard</xsl:when>
				<xsl:when test="CTN=1 
										and DescriptorName=1 
										and WOW=1 
										and IMS >= 1
										and FeatureName >= 1 
										and KBA >= 1
										and CSI >= 1">1-Basic</xsl:when>
				<xsl:when test="CTN=1 
										and DescriptorName=1 
										and WOW=1">0-Code Only</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</Product-Enhancement-Content>
	</xsl:template>
</xsl:stylesheet>
