<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	exclude-result-prefixes="cinclude xsl dir xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="order">test</xsl:param>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="logfile">test</xsl:param>
	<xsl:param name="finish">test</xsl:param>
	<!-- -->
	<xsl:template match="/dir:directory">
		<dir>
			<xsl:apply-templates select="@*|node()"/>
		</dir>
	</xsl:template>
	<!-- -->
	<xsl:template match="/dir:directory/dir:file">
	</xsl:template>
	<!-- -->
	<xsl:template match="/dir:directory/dir:directory">
		<count>
			<xsl:attribute name="order"><xsl:value-of select="$order"/></xsl:attribute>
			<xsl:attribute name="channel"><xsl:value-of select="$channel"/></xsl:attribute>
			<xsl:attribute name="logfile"><xsl:value-of select="concat('Report_',@name,'.size')"/></xsl:attribute>
			<xsl:attribute name="finish"><xsl:value-of select="$finish"/></xsl:attribute>
			<xsl:value-of select="xs:integer(sum(dir:directory/dir:file/@size))"/>
		</count>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	
</xsl:stylesheet>