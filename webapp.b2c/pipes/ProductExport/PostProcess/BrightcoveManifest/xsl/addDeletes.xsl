<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="@*|node()" >
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="@refid">
		<xsl:element name="delete-title">
			<xsl:attribute name="refid" select="."/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@video-full-refid|@video-still-refid">
		<xsl:element name="delete-asset">
			<xsl:attribute name="refid" select="."/>
		</xsl:element>
	</xsl:template>
	
	<!-- -->
</xsl:stylesheet>
