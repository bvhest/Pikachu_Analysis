<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

<!--xsl:template match="*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
</xsl:template-->

<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
</xsl:template>

<xsl:template match="sql:rowset|sql:row">
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match="sql:*">
	<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

	
</xsl:stylesheet>