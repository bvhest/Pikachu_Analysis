<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml ..\xml\content_overview.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="/ss:Workbook/ss:Worksheet[position() = 1]" mode="aa0"/>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="ss:Worksheet" mode="aa0">
		<xsl:apply-templates select="ss:Table"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="ss:Table">
		<xsl:variable name="col">
			<xsl:for-each select="ss:Row">
				<xsl:if test="position() = 1">
					<xsl:apply-templates select="." mode="aa1"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="ss:Row">
			<xsl:if test="position() != 1">
				<row>
					<xsl:apply-templates select="." mode="aa2">
						<xsl:with-param name="col" select="$col"/>
					</xsl:apply-templates>
				</row>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- -->
	<xsl:template match="ss:Row" mode="aa1">
		<xsl:for-each select="ss:Cell">
			<xsl:variable name="colNr">
				<xsl:call-template name="colNr"/>
			</xsl:variable>
			<col id="{$colNr}">
				<xsl:value-of select="ss:Data"/>
			</col>
		</xsl:for-each>
	</xsl:template>
	<!-- -->
	<xsl:template match="ss:Row" mode="aa2">
		<xsl:param name="col"/>
		<xsl:for-each select="ss:Cell">
			<xsl:variable name="colNr">
				<xsl:call-template name="colNr"/>
			</xsl:variable>
			<xsl:variable name="colname1" select="$col/col[@id = $colNr]"/>
			<xsl:variable name="colname2" select="replace(replace(replace($colname1/text(), '(swf)', '_swf'), '(jpg)', '_jpg'), ' |/s|[()]|- ', '')"/>
			<xsl:variable name="colname">
				<xsl:choose>
					<xsl:when test="string-length($colname2) = 0">
						<xsl:value-of select="concat('col_', position())"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$colname2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$colname}">
				<xsl:value-of select="ss:Data"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<!-- -->
	<xsl:template name="colNr">
		<xsl:variable name="prevCells" select="preceding-sibling::ss:Cell"/>
		<xsl:choose>
			<xsl:when test="@ss:Index">
				<xsl:value-of select="@ss:Index"/>
			</xsl:when>
			<xsl:when test="count($prevCells) = 0">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:when test="count($prevCells[@ss:Index]) > 0">
				<xsl:value-of select="($prevCells[@ss:Index][position()=1]/@ss:Index) + ((count($prevCells) + 1) - (count($prevCells[@ss:Index][position()=1]/preceding-sibling::ss:Cell) + 1)) + sum($prevCells/@ss:MergeAcross)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="count(preceding-sibling::ss:Cell) + 1 + sum(preceding-sibling::ss:Cell/@ss:MergeAcross)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
