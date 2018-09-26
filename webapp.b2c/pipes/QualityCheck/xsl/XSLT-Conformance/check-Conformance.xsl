<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="filename" select="''"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="xsl:stylesheet | xsl:transform"/>
	</xsl:template>
	
	<xsl:template match="xsl:stylesheet | xsl:transform">
		<file>
			 <filename><xsl:value-of select="translate($filename,'&lt;','')"/></filename>
			<xsl:choose>
				<xsl:when test="@version='2.0'">
					<xsl:call-template name="xslt2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="xslt1"/>
				</xsl:otherwise>
			</xsl:choose>
		</file>
	</xsl:template>
	
	<xsl:template name="xslt1">
		<xsl:call-template name="checkTopLevelStructure"/>
		<xsl:apply-templates select="xsl:template"/>
	</xsl:template>
	
	<xsl:template name="xslt2">
		<xsl:call-template name="checkTopLevelStructure"/>
		<xsl:apply-templates select="xsl:template"/>
	</xsl:template>
	
	<xsl:template name="checkTopLevelStructure">
		<xsl:variable name="firstElementName"><xsl:apply-templates select="child::*[1]" mode="test"/></xsl:variable>
		<xsl:if test="xsl:import and $firstElementName != 'xsl:import'">
			<error>The 'xsl:import' element isn't at the correct position. It should be the first top-level element.</error>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:template">
		<xsl:variable name="position" select="fn:count(preceding::xsl:template)"/>
		<xsl:variable name="firstElementName"><xsl:apply-templates select="child::*[1]" mode="test"/></xsl:variable>
		<xsl:if test="xsl:param and $firstElementName != 'xsl:param'">
			<error>The 'xsl:param' element within the 'xsl:template' element [<xsl:value-of select="$position + 1"/>] isn't at the correct position. It should be the first element within a xsl:template.</error>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="test">
		<xsl:value-of select="name(.)"/>
<!--		<xsl:value-of select="@match"/>
-->	</xsl:template>

</xsl:stylesheet>
