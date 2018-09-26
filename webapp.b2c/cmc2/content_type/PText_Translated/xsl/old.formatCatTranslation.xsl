<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="batchsize">10</xsl:param>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="country">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
	<xsl:param name="dir">temp/</xsl:param>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>	
	<!-- -->		
		<xsl:template match="Product"/>
	<!-- -->		
	<xsl:template match="node()[ends-with(name(),'Name')]">
		<xsl:copy>
			<xsl:attribute name="direction">ltor</xsl:attribute>
			<xsl:attribute name="key"><xsl:value-of select="ancestor::Catalog/CatalogCode"/>_<xsl:value-of select="../node()[ends-with(name(),'Code')]"/></xsl:attribute>
			<xsl:attribute name="maxlength">ltor</xsl:attribute>
			<xsl:attribute name="translate">yes</xsl:attribute>
			<xsl:attribute name="validate">yes</xsl:attribute>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>		

	<!-- -->
</xsl:stylesheet>
