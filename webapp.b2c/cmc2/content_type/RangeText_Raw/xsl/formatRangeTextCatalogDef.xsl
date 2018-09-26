<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<!-- -->
	<xsl:template match="node()|@*">
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>	

	<xsl:template match="Node">
		<object o="{upper-case(@code)}"/>
	</xsl:template>		
		
	<!-- -->
</xsl:stylesheet>
