<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:include="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
	
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>

	<xsl:template match="dir:file">
		<include:include>
			<xsl:attribute name="src"><xsl:value-of select="concat($dir,@name)"/></xsl:attribute>
		</include:include>
	</xsl:template>
</xsl:stylesheet>