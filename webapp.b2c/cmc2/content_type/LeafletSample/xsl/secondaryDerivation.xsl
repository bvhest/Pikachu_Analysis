<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="store-outputs">
		<xsl:apply-templates select="../content/octl/sql:rowset/sql:row/sql:data/Product/FeatureLogo"/>
		<xsl:apply-templates select="../content/octl/sql:rowset/sql:row/sql:data/Product/Award"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Award">
		<placeholder o="{AwardCode}" ct="Logo" l="none" needsProcessing="0" />
		<relation o-in="{AwardCode}" ct-in="Logo" l-in="none" ct-out="LeafletSample" l-out="master_global" o-out="{@o}" secondary="1"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
</xsl:stylesheet>
