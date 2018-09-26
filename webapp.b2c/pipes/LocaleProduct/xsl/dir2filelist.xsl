<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
	<xsl:param name="filepart">test</xsl:param>
	<!-- -->

	<xsl:template match="/">
		<html>
		<body>
		<head>File list for <xsl:value-of select="concat($channel,'/',$locale)"/></head><br/>
		<small>First 50 matching files for <xsl:value-of select="$filepart"/></small>
		<br/><br/>
		<!--xsl:value-of select="normalize-space(.)"/-->
			<xsl:apply-templates/>
		</body>
		</html>
	</xsl:template>
	
	<xsl:template match="dir:file">
		<xsl:if test="position() &lt; 50">
			<a target="_default">
			<xsl:variable name="filename" select="concat('filestore_getfile-',$channel,'/',$locale,'/',@name)"/>
			<xsl:attribute name="href"><xsl:value-of select="$filename"/></xsl:attribute>
			<xsl:value-of select="@name"/>
			</a>
			<br/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>