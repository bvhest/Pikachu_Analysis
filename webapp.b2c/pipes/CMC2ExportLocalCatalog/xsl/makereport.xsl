<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="sql xsl source">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="dir"/>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="country">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="$dir"/>
				<xsl:variable name="timestamp" select="substring-before(substring-after(/page/shellResult[1]/source,'_def_'),'.xml')"/>	
				<xsl:text>logs/Report_</xsl:text>
				<xsl:choose>
					<xsl:if test="batch/@exportdate!=''">
						<xsl:value-of select="batch/@exportdate"/>
					</xsl:if>
					<xsl:otherwise>
						<xsl:value-of select="$timestamp"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>.xml</xsl:text>
			</source:source>
			<source:fragment>
				<report>
					<xsl:apply-templates select="@*|node()"/>
				</report>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
		<item>
			<xsl:apply-templates select="@*|node()"/>
		</item>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:ctn">
		<id>
			<xsl:value-of select="."/>
		</id>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:locale">
		<locale>
			<xsl:value-of select="."/>
		</locale>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:result">
		<result>
			<xsl:value-of select="."/>
		</result>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:remark">
		<remark>
			<xsl:value-of select="."/>
		</remark>
	</xsl:template>
	<!-- -->
	<xsl:template match="batch|batch/@*|sql:rowset">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
