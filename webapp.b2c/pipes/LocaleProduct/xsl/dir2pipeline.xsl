<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="pipeline">test</xsl:param>
	<!-- -->

	<xsl:template match="/">
		<root>
		<!--xsl:value-of select="normalize-space(.)"/-->
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	
	<xsl:template match="dir:file">
		<cinclude:include>
			<xsl:attribute name="src"><xsl:text>cocoon:/</xsl:text><xsl:value-of select="$pipeline"/><xsl:value-of select="@name"/><xsl:text>-</xsl:text><xsl:value-of select="@date"/></xsl:attribute>
		</cinclude:include>
	</xsl:template>
</xsl:stylesheet>