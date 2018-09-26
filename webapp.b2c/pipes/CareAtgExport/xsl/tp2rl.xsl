<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template match="add-item">
		<xsl:element name="{@item-descriptor}">
		<xsl:attribute name="id" select="@item-descriptor"/>
		<xsl:apply-templates/>
		
		</xsl:element>
	
	</xsl:template>

	<xsl:template match="set-property">
		<xsl:element name="{../@item-descriptor}.{@name}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>	
		
	<!-- -->
</xsl:stylesheet>
