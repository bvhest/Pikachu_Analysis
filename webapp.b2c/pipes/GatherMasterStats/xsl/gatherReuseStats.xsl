<?xml version="1.0"?>
<?altova_samplexml testFilteredProductData.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="exportdate"></xsl:param>
	<xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/></xsl:variable>
	<!-- -->
	<xsl:template match="/Stats">
		<Stats>
			<xsl:call-template name="GatherStats">
				<xsl:with-param name="division" as="xs:string" select="'DAP'"/>
			</xsl:call-template>
			<xsl:call-template name="GatherStats">
				<xsl:with-param name="division" as="xs:string" select="'CE'"/>
			</xsl:call-template>
		</Stats>
	</xsl:template>
	<!-- -->
	<xsl:template name="GatherStats">
		<xsl:param name="division" as="xs:string"/>
		<xsl:call-template name="GatherFeature">
			<xsl:with-param name="division" as="xs:string" select="$division"/>
		</xsl:call-template>
		<xsl:call-template name="GatherSpec">
			<xsl:with-param name="division" as="xs:string" select="$division"/>
		</xsl:call-template>
	</xsl:template>
	<!-- -->
	<xsl:template name="GatherFeature">
		<xsl:param name="division" as="xs:string"/>
		<xsl:for-each-group select="Product[@division = $division]/Feature" group-by="@id">
			<Feature id="{current-grouping-key()}" division="{$division}" count="{count(current-group())}"/>
		</xsl:for-each-group>
	</xsl:template>
	<!-- -->
	<xsl:template name="GatherSpec">
		<xsl:param name="division" as="xs:string"/>
		<xsl:for-each-group select="Product[@division = $division]/CSItem" group-by="@id">
			<CSItem id="{current-grouping-key()}" division="{$division}" count="{count(current-group())}"/>
		</xsl:for-each-group>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
