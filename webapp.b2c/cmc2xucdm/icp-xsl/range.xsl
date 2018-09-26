<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="range_overview.xsl"/>
	<xsl:import href="range_shop.xsl"/>
	
	<xsl:template match="Nodes|Products" mode="headers-range">
		<!-- Load product_generic.js for loading product photos -->
		<script type="text/javascript" src="{$icp-host}js/product/product_generic.js"></script>

		<xsl:call-template name="headers-range-overview"/>
    <xsl:if test="Node[1]/@nodeType='Range'">
      <xsl:call-template name="headers-range-shop"/>
    </xsl:if>
	</xsl:template>
	
	<!--
		This match is the main entry point for the data type 'range'.
		The match should uniquely match the range root element for all
		range files across all possible source files, i.e. it should
		*not* match any elements for other data types.
	-->
	<xsl:template match="/Nodes[Node]|/Products[Node]" mode="collect-errors">
		<xsl:for-each select="Node[position() &lt;= $max-items]">
			<xsl:variable name="errors">
				<xsl:call-template name="collect-errors">
					<xsl:with-param name="item" select="."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="string-length($errors) &gt; 0">
				<div class="item-errors" idref="{@code}">
					<xsl:copy-of select="$errors"/>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/Nodes[Node]|/Products[Node]">
		<xsl:apply-templates select="." mode="range-index" />
		<!-- Let each of the views do its part -->
		<xsl:apply-templates select="." mode="range-overview"/>
    <!-- Shop preview only for Range nodes -->
    <xsl:if test="Node[1]/@nodeType='Range'">
      <xsl:apply-templates select="." mode="range-shop"/>
    </xsl:if>
	</xsl:template>
</xsl:stylesheet>
