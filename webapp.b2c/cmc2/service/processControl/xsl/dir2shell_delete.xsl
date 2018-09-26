<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>

	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>

	<xsl:template match="dir:file">
		<shell:delete>
			<shell:source><xsl:value-of select="concat($dir,'/',@name)"/></shell:source>
		</shell:delete>
	</xsl:template>

</xsl:stylesheet>
