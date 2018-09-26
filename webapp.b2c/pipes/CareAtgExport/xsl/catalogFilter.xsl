<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:ph="http://www.philips.com/catalog/pdl">
	<xsl:param name="country">CH</xsl:param>
	<xsl:param name="language">en</xsl:param>
	
	<xsl:param name="catalogDocPath"/>
	<xsl:variable name="catalog" select="document($catalogDocPath)"/>
	<xsl:key name="catalog-key" match="/root/sql:rowset/sql:row" use="sql:object_id"/>
	

	<!-- Filters -->
	<xsl:template match="add-item[@item-descriptor='product-translation']">
	<xsl:variable name="item" select="."/>
	<xsl:variable name="id" select="substring-before(@id,'_en_00')"/>
		<xsl:for-each select="$catalog[key('catalog-key',$id)]">
				<xsl:copy-of select="$item"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="add-item[@item-descriptor='product']">
	<xsl:variable name="item" select="."/>
	<xsl:variable name="id" select="substring-before(@id,'_00')"/>
		<xsl:for-each select="$catalog[key('catalog-key',$id)]">
				<xsl:copy-of select="$item"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="add-item[@item-descriptor='category-ctn']">
	<xsl:variable name="item" select="."/>
	<xsl:variable name="id" select="substring-after(@id,'*') "/>
		<xsl:for-each select="$catalog[key('catalog-key',$id)]">
				<xsl:copy-of select="$item"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="add-item[@item-descriptor='ctn-locale']">
	<xsl:variable name="item" select="."/>
	<xsl:variable name="id" select="substring-before(@id,'*') "/>
		<xsl:for-each select="$catalog[key('catalog-key',$id)]">
				<xsl:copy-of select="$item"/>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
 
</xsl:stylesheet>
