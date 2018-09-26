<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="gnow" select="current-dateTime()"/>
	<xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($gnow),1,16),':',''),'-',''),'T','')"/>

	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="//sql:rowset"/>
		</root>
	</xsl:template>											

	<xsl:template match="sql:rowset">
		<xsl:for-each select="sql:row">
			<xsl:variable name="locale" select="sql:localisation"/>
			<cinclude:include>
				<xsl:attribute name="src"><xsl:text>cocoon:/processLocalisation.</xsl:text><xsl:value-of select="$timestamp"/><xsl:text>.</xsl:text><xsl:value-of select="$locale"/></xsl:attribute>
			</cinclude:include>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>