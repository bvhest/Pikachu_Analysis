<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:param name="cache-folder"/>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- Store a cahe version -->
	<xsl:template match="title">
		<xsl:variable name="titlefile" select="concat($cache-folder,'/',@refid,'.xml')"/>
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="$titlefile"/>
			</source:source>
			<source:fragment>
				<xsl:copy copy-namespaces="no">
					  <xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</source:fragment>
		</source:write>
	</xsl:template>
</xsl:stylesheet>
