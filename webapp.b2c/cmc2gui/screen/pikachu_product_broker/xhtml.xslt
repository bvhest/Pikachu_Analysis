<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0">
	<!-- -->
	<xsl:import href="../../../cmc2xucdm/xucdm-preview/xucdm-broker.xsl"/>
	<!-- -->
	<xsl:template match="/root">
		<Products>
			<xsl:apply-templates select="@*|node()"/>
		</Products>
	</xsl:template>	
	<!--  -->
</xsl:stylesheet>
