<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:philips="http://www.philips.com/catalog/recat">
 
  <!-- -->
	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>
  <!-- -->
	<xsl:template match="dir:file[dir:xpath/Categorization/Catalog/FixedCategorization|dir:xpath/philips:categories/philips:category|dir:xpath/Products/Product]">
			<root>
			<cinclude:include>
				<xsl:attribute name="src"><xsl:text>cocoon:/delta/</xsl:text><xsl:value-of select="@name"/></xsl:attribute>
			</cinclude:include>		
		</root>
	</xsl:template>
	<xsl:template match="dir:file[dir:xpath/Products/Product]">
			<root>
			<cinclude:include>
				<xsl:attribute name="src"><xsl:text>cocoon:/delta/</xsl:text><xsl:value-of select="@name"/></xsl:attribute>
			</cinclude:include>		
		</root>
	</xsl:template>
</xsl:stylesheet>