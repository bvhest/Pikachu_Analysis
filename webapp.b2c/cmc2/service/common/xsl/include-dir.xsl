<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="content-type"/>
	<xsl:param name="localisation"/>
	<xsl:param name="global-input"/>

	<xsl:template match="/">
	
	<xsl:variable name="path">
		<xsl:value-of select="concat($global-input)"/>
	</xsl:variable>
	
	<root>
		<placeholders>
			<xsl:apply-templates select="@*|node()"/>
		</placeholders>
		<dir>
			<i:include xmlns:i="http://apache.org/cocoon/include/1.0" 
				src="cocoon:/dir/{$global-input}/{$content-type}"/>
		</dir>
	</root>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>