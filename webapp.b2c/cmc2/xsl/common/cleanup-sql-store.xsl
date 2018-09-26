<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="store">
		<xsl:copy-of copy-namespaces="no" select="content/*"/>
	</xsl:template>

	<xsl:template match="node()[sql:rowset/sql:error]">
		<xsl:copy>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
			<xsl:attribute name="status">failed: <xsl:value-of select="."/></xsl:attribute>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[sql:rowset/sql:row/sql:returncode='1']">
		<xsl:copy>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
			<xsl:attribute name="status">success</xsl:attribute>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>