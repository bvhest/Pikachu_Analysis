<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="product_overview.xsl"/>
	<xsl:import href="product_website.xsl"/>
	<xsl:import href="product_shop.xsl"/>
	<xsl:import href="product_awardsandreviews.xsl"/>
	<xsl:import href="product_leaflet.xsl"/>
	
	<xsl:template match="Products" mode="headers-product">
		<xsl:call-template name="headers-product-generic"/>
		<xsl:call-template name="headers-product-overview"/>
		<xsl:call-template name="headers-product-website"/>
		<xsl:call-template name="headers-product-shop"/>
		<xsl:call-template name="headers-product-leaflet"/>
		<xsl:call-template name="headers-product-awardsandreviews"/>
		
		<!-- Collect all Assets -->
		<script type="text/javascript">
		var icp_asset_index = new AssetIndex();
		<xsl:for-each select="Product">
			<xsl:variable name="id" select="CTN"/>
			<xsl:for-each select="Assets/Asset">
				<xsl:text>icp_asset_index.addAsset("</xsl:text>
				<xsl:value-of select="$id"/>
				<xsl:text>",</xsl:text>
				<xsl:apply-templates select="." mode="collect-assets-js"/>
				<xsl:text>);
				</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		</script>
	</xsl:template>
	
	<!--
		This match is the main entry point for the data type 'product'.
		The match should uniquely match the Products element for all
		product files across all possible source files, i.e. it should
		*not* match any Products elements for other data types.
	-->
	<xsl:template match="/Products[Product]" mode="collect-errors">
		<xsl:for-each select="Product[position() &lt;= $max-items]">
			<div class="item_errors" idref="{translate(CTN,'/','_')}">
				<xsl:call-template name="collect-errors">
					<xsl:with-param name="item" select="."/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="/Products[Product]">
		<xsl:apply-templates select="." mode="product-index" />
		
		<!-- Let each of the views do its part -->
		<xsl:apply-templates select="." mode="product-website"/>
		<xsl:apply-templates select="." mode="product-shop"/>
		<xsl:if test="true() or $system != 'pfs'">
			<xsl:apply-templates select="." mode="product-leaflet"/>
		</xsl:if>
		<xsl:apply-templates select="." mode="product-overview"/>
		<xsl:apply-templates select="." mode="product-awardsandreviews"/>
	</xsl:template>
	
	<xsl:template match="Asset" mode="collect-assets-js">
		<xsl:variable name="width">
			<xsl:choose>
				<xsl:when test="@width != '' and number(@width) &gt; 0">
					<xsl:value-of select="@width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="height">
			<xsl:choose>
				<xsl:when test="@height != '' and number(@height) &gt; 0">
					<xsl:value-of select="@height"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:text>{code: "</xsl:text><xsl:value-of select="@code"/><xsl:text>"</xsl:text>
		<xsl:text>,type: "</xsl:text><xsl:value-of select="@type"/><xsl:text>"</xsl:text>
		<xsl:text>,locale: "</xsl:text><xsl:value-of select="@locale"/><xsl:text>"</xsl:text>
		<xsl:text>,number: "</xsl:text><xsl:value-of select="@number"/><xsl:text>"</xsl:text>
		<xsl:text>,description: "</xsl:text><xsl:value-of select="@description"/><xsl:text>"</xsl:text>
		<xsl:text>,extension: "</xsl:text><xsl:value-of select="@extension"/><xsl:text>"</xsl:text>
		<xsl:text>,width: </xsl:text><xsl:value-of select="$width"/>
		<xsl:text>,height: </xsl:text><xsl:value-of select="$height"/>
		<xsl:text>,master: "</xsl:text><xsl:value-of select="@master"/><xsl:text>"</xsl:text>
		<xsl:text>,url: "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
