<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="source xsl dir">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="/dir:directory">
		<reports>
			<xsl:apply-templates select="dir:file"/>
		</reports>
	</xsl:template>
	<!-- -->
	<xsl:template match="dir:file">
		<xsl:apply-templates select="dir:xpath"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="dir:xpath">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
