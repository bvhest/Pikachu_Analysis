<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="source">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="file"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<source:write>
				<source:source>
					<xsl:value-of select="$file"/>
				</source:source>
				<source:fragment>
					<xsl:apply-templates/>
				</source:fragment>
			</source:write>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
