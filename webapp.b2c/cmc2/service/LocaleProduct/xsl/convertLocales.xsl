<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<ResponseLocales>
		<Locale>
			<xsl:choose>
			<xsl:when test="/Locales/sql:rowset/sql:row/sql:locale/text()">
				<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
				<xsl:attribute name="status">Exists</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="id"><xsl:value-of select="/Locales/@id"/></xsl:attribute>
				<xsl:attribute name="status">Not Exists</xsl:attribute>
			</xsl:otherwise>
			</xsl:choose>
			</Locale>
		</ResponseLocales>
	</xsl:template>
	<!--  -->
	<!--  -->
</xsl:stylesheet>
