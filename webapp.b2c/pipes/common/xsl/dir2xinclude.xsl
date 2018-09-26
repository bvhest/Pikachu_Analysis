<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<log>
			<xsl:apply-templates select="//dir:file"/>
		</log>
	</xsl:template>

	<xsl:template match="dir:file">
		<xsl:element name="xi:include">
			<xsl:attribute name="href"><xsl:value-of select="concat('Temp/',@name)"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>