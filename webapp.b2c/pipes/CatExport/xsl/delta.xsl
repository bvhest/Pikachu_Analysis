<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:philips="http://www.philips.com/catalog/recat">
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="delta">
		<xsl:copy>
			<xsl:apply-templates select="/root/new/*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
