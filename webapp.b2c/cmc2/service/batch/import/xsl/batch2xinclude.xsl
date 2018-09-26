<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xi="http://www.w3.org/2001/XInclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir">inbox/</xsl:param>
	<!-- -->
	<xsl:template match="/root">
				<xsl:apply-templates select="file"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="file">
		<xsl:element name="xi:include">
			<xsl:attribute name="href"><xsl:value-of select="$dir"/><xsl:value-of select="@name"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
