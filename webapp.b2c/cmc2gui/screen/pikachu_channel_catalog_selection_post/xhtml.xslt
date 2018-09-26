<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Channel catalog selection for <xsl:value-of select="@channel"/> - result
				</h2><hr/>
				<table>
					<tr>
						<td>locale</td>
						<td>result</td>
						<td>comments</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:rowset">
		<tr>
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:row">Success</xsl:when>
					<xsl:when test="sql:error">Failure</xsl:when>
					<xsl:otherwise>Unknown</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="sql:row">
						<xsl:value-of select="sql:row"/>
					</xsl:when>
					<xsl:when test="sql:error">
						<xsl:value-of select="sql:error"/>
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
