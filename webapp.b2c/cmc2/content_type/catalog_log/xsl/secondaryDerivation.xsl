<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="catalog-definition">
		<placeholder o="{@o}" ct="catalog_configuration" l="none" needsProcessing="0" />
		<relation o-in="{@o}" ct-in="catalog_configuration" l-in="none" ct-out="catalog_log" l-out="none" o-out="{@o}" secondary="1"/>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
</xsl:stylesheet>
