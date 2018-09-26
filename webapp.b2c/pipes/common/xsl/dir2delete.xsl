<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>

	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>

	<xsl:template match="dir:file">
		<!-- Count number of records in Trigo product XML file -->
		<source:delete>
			<source:source><xsl:value-of select="concat($dir,'/',@name)"/></source:source>
		</source:delete>
	</xsl:template>

</xsl:stylesheet>
