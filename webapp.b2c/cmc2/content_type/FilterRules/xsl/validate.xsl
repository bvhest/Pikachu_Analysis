<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:saxon="http://saxon.sf.net/"
	exclude-result-prefixes="xsl saxon">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:variable name="test-doc">
			<Product>
				<ProductName>Test</ProductName>
			</Product>
		</xsl:variable>
		
		<xsl:apply-templates select="$test-doc" mode="xpath-test">
			<xsl:with-param name="xpath-expr" select="'Product['"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="element()" mode="xpath-test">
		<xsl:param name="xpath-expr"/>
		<xsl:variable name="expr" select="saxon:expression($xpath-expr)"/>
		<xsl:sequence select="saxon:eval($expr)"/>
	</xsl:template>
</xsl:stylesheet>