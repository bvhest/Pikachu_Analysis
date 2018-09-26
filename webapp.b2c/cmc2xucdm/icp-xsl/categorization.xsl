<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="categorization_overview.xsl"/>
	
	<xsl:template match="Categorization" mode="headers-categorization">
		<xsl:call-template name="headers-categorization-overview"/>
	</xsl:template>
	
	<!--
		These matches are the main entry points for the data type 'categorization'.
		The match should uniquely match the Categorization element for all
		categorization files across all possible source files, i.e. it should
		*not* match any Categorization elements for other data types.
	-->
	<xsl:template match="/Products/Categorization|/Categorization" mode="collect-errors">
		<div class="item-errors">
			<xsl:call-template name="collect-errors">
				<xsl:with-param name="item" select="."/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="/Products/Categorization|/Categorization">
		<!-- Let each of the views do its part -->
		<xsl:apply-templates select="." mode="categorization-overview"/>
	</xsl:template>
</xsl:stylesheet>
