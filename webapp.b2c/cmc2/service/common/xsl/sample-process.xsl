<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:param name="ct"/>
	<xsl:param name="l"/>

	<xsl:template match="sql:*">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="sql:data">
		<xsl:element name="{translate($ct, '_', '-')}">
			<xsl:attribute name="l"><xsl:value-of select="$l"/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>