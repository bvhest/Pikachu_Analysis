<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="sql:*"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Product">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="LastExportDate"><xsl:value-of select="if(../sql:rowset/sql:row[sql:ctn = $ctn]/sql:lastexportdate = '' or not(string-length(../sql:rowset/sql:row[sql:ctn = $ctn]/sql:lastexportdate) gt 0)) then '1900-01-01T00:00:00' else ../sql:rowset/sql:row[sql:ctn = $ctn]/sql:lastexportdate"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
