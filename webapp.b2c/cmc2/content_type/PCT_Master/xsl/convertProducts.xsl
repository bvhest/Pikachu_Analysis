<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:i="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl i">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->
	<xsl:template match="/">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!--  -->
	<xsl:template match="octl[sql:rowset/sql:row/sql:content_type='PMT_Master']"/>
	<xsl:template match="octl[sql:rowset/sql:row/sql:content_type='AssetList']"/>
	<!--  -->
	<xsl:template match="Product" exclude-result-prefixes="i sql xsl">
		<Product>
			<xsl:apply-templates select="@*[not(local-name()='Status' or local-name()='Brand' or local-name()='Division')]"/>
			<xsl:apply-templates select="CTN"/>
			<xsl:apply-templates select="ProductImage"/>
			<xsl:apply-templates select="HasSoftwareAsset"/>
			<xsl:apply-templates select="ProductName"/>
			<xsl:apply-templates select="ProductReference"/>
			<xsl:apply-templates select="SupraFeature"/>

			<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/MarketingVersion"/>
			<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/MarketingStatus"/>
			
			<xsl:choose>
				<xsl:when test="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString">
					<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="NamingString"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="ShortDescription"/>
			<xsl:apply-templates select="RichTexts"/>
			<xsl:variable name="locale" select="../../sql:localisation"/>
			<xsl:variable name="productIsLocalized" select="@IsLocalized='true' "/>
			
			<AssetList>
<!-- stripped feed for first phase 
				<xsl:choose>
					<xsl:when test="substring($locale,1,2)='en' or $productIsLocalized">
						<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='AssetList'][sql:localisation=$locale]/sql:data/object/Asset"/>
						<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='AssetList'][sql:localisation='master_global']/sql:data/Product/AssetList/Asset[not(Language='en_US' and ResourceType='PSS')]  "/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='AssetList']/sql:data/object/Asset"/>
					</xsl:otherwise>
				</xsl:choose>
-->
			</AssetList>
		</Product>
	</xsl:template>
	
	<xsl:template name="NamingString">
		<xsl:choose>
			<xsl:when test="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString">
				<xsl:apply-templates select="../../../../../octl/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString"/>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="NamingString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
