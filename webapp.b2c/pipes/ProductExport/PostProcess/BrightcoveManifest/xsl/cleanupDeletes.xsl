<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- -->
	<xsl:template match="@*|node()" >
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="publisher-upload-manifest">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="notify"/>
			<xsl:apply-templates select="delete-title"/>
			<xsl:apply-templates select="delete-asset"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
