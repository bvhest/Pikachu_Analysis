<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="xsl xs fn sql">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="filename" select="''"/>
	
	<xsl:template match="/">
		<xsl:variable name="namespaces">
			<namespaces>
				<xsl:for-each select="//namespace::*">
					<namespace prefix="{local-name()}"><xsl:value-of select="."/></namespace>
				</xsl:for-each>
			</namespaces>
		</xsl:variable>
		<namespaces filename="{$filename}">
			<xsl:variable name="duplicate-ns">
				<xsl:apply-templates select="$namespaces//namespace" mode="check"/>
			</xsl:variable>
			<xsl:if test="$duplicate-ns!=''">
				<xsl:attribute name="duplicate-ns" select="'true'"/>
			</xsl:if>
			<xsl:apply-templates select="$namespaces//namespace">
				<xsl:with-param name="duplicate-ns" select="$duplicate-ns"/>
				<xsl:sort select="."/>
			</xsl:apply-templates>
		</namespaces>
	</xsl:template>
	
	<xsl:template match="namespace">
		<xsl:param name="duplicate-ns"/>
		<xsl:variable name="prefix-ns" select="concat(@prefix,.)"/>
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::namespace[concat(@prefix,.)=$prefix-ns]) and contains($duplicate-ns,@prefix)">
				<duplicate><xsl:copy-of select="current()"/></duplicate>
			</xsl:when>
			<xsl:when test="not(preceding-sibling::namespace[concat(@prefix,.)=$prefix-ns])">
				<xsl:copy-of select="current()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="namespace" mode="check">
		<xsl:variable name="prefix-ns" select="concat(@prefix,.)"/>
		<xsl:variable name="ns" select="."/>
		<xsl:if test="not(preceding-sibling::namespace[concat(@prefix,.)=$prefix-ns]) and (preceding-sibling::namespace=$ns)"><xsl:value-of select="@prefix"/>;</xsl:if>
	</xsl:template>

</xsl:stylesheet>
