<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="ext" select="''" as="xs:string"/>
	<xsl:param name="mode" select="'normal'" as="xs:string"/>

	<xsl:template match="/">
		<xsl:apply-templates select="dir:directory"/>
	</xsl:template>
	
	<xsl:template match="dir:directory">
		<xsl:choose>
			<xsl:when test="$mode='removeEmptyDirs' and .//dir:file">
				<dir:directory>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates select="node()"/>
				</dir:directory>
			</xsl:when>
			<xsl:otherwise>
				<dir:directory>
					<xsl:apply-templates select="node()|@*"/>
				</dir:directory>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="dir:file">
		<xsl:choose>
			<xsl:when test="$ext!='' and fn:ends-with(@name,$ext)">
				<dir:file>
					<xsl:apply-templates select="@*"/>
				</dir:file>
			</xsl:when>
			<xsl:otherwise>
				<dir:file>
					<xsl:apply-templates select="@*"/>
				</dir:file>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:copy copy-namespaces="no"/>
	</xsl:template>
</xsl:stylesheet>
