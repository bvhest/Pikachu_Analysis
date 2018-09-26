<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude">
	<xsl:param name="file"/>
	<xsl:template match="/">
		<root>
			<new>
				<xsl:apply-templates select="@*|node()"/>
			</new>
			<cached>
				<xsl:element name="xi:include">
					<xsl:attribute name="href"><xsl:value-of select="$file"/></xsl:attribute>
					 <xsl:element name="xi:fallback">No disponible</xsl:element>
				</xsl:element>
			</cached>
			<delta/>
		</root>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
