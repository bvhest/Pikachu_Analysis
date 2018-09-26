<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	exclude-result-prefixes="cinclude xsl dir">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="order">test</xsl:param>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="logfile">test</xsl:param>
	<xsl:param name="finish">test</xsl:param>
	<!-- -->
	<xsl:template match="/report">
		<count>
			<xsl:attribute name="order"><xsl:value-of select="$order"/></xsl:attribute>
			<xsl:attribute name="channel"><xsl:value-of select="$channel"/></xsl:attribute>
			<xsl:attribute name="logfile"><xsl:value-of select="$logfile"/></xsl:attribute>
			<xsl:attribute name="finish"><xsl:value-of select="$finish"/></xsl:attribute>
			<xsl:value-of select="string(count(/report/item[result='Success' or result='1']))"/>
		</count>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
	</xsl:template>	
</xsl:stylesheet>