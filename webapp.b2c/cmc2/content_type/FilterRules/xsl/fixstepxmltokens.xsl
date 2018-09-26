<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:saxon="http://saxon.sf.net/"
	exclude-result-prefixes="xsl saxon">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="XPath/gt">
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="XPath/lt">
		<xsl:text>&lt;</xsl:text>
	</xsl:template>
</xsl:stylesheet>