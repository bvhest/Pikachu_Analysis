<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
	<!--  -->
	<xsl:template match="/root">
		<Products>
			<xsl:for-each-group select="Products/Product" group-by="concat(@Catalog,CTN)">
				<xsl:for-each select="current-group()">
					<xsl:if test="position() = 1">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each-group>
		</Products>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
