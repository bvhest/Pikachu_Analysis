<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="node()|@*">
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="sql:rowset">
	<root>
		<xsl:apply-templates select="@*|node()"/>
	</root>
	</xsl:template>
	<xsl:template match="sql:row">
		<row>
		<locale><xsl:value-of select="sql:locale"/></locale>
		<language><xsl:value-of select="sql:ccr_language_code"/></language>
		<languagecode><xsl:value-of select="sql:languagecode"/></languagecode>
		</row>
	</xsl:template>
	
</xsl:stylesheet>
