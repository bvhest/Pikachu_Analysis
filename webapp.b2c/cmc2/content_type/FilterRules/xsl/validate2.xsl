<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="xsl saxon">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:element name="result">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!-- Don't copy anything by default -->
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<!-- Mode 'copy' does copy -->
	<xsl:template match="@*|node()" mode="copy">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- Replace STEP entities -->
	<xsl:template match="FilterKey/XPath/gt" mode="#all">
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="FilterKey/XPath/lt" mode="#all">
		<xsl:text>&lt;</xsl:text>
	</xsl:template>
	
	<!-- Evaluate each XPath expression -->
	<xsl:template match="FilterKey/XPath">
		<xsl:variable name="xpath-expr-string">
			<xsl:apply-templates select="node()" mode="copy"/>
		</xsl:variable>
		<xsl:variable name="xpath-expr" select="saxon:expression($xpath-expr-string)"/>
		<!-- Log an entry for the current XPath -->
		<xsl:element name="FilterRule">
			<xsl:value-of select="trace(concat(ancestor::FilterGroup/@code, '/', ancestor::FilterKey/@code, ':', $xpath-expr-string), 'XPath')"/>
		</xsl:element>
		<!-- A dummy document to run the XPath against -->
		<xsl:variable name="test-doc">
			<Dummy/>
		</xsl:variable>
		<!-- This triggers the evaluation -->
		<xsl:apply-templates select="$test-doc" mode="xpath-test">
			<xsl:with-param name="xpath-expr" select="$xpath-expr"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="element()" mode="xpath-test">
		<xsl:param name="xpath-expr"/>
		<xsl:sequence select="saxon:eval($xpath-expr)"/>
	</xsl:template>
</xsl:stylesheet>