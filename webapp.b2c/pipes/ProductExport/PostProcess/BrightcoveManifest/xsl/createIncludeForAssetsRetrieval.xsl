<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0">
	<xsl:param name="ccrDir"/>
	<!-- 
    Create include statements to retrieve the asset files for modified assets.
  -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- Modified assets -->
	<xsl:template match="asset">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*[not(local-name()=('ccr-filepath','mimeType'))]"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
		
		<copy-ccr-assets>
			<xsl:variable name="include-src" select="concat('cocoon:/readResource/',$ccrDir, '/', @ccr-filepath,'?targetName=', @filename, '&amp;mimeType=', @mimeType)"/>
			<i:include src="{$include-src}"/>
		</copy-ccr-assets>
	</xsl:template>
</xsl:stylesheet>
