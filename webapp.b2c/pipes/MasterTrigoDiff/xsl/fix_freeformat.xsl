<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="CSValue[not (CSValueCode)]">
		<xsl:copy copy-namespaces="no">
			<CSValueCode>
				<xsl:text>VFF_</xsl:text>
				<xsl:value-of select="../CSItemCode"/>
			</CSValueCode>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
