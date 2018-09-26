<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>
	<xsl:template match="dir:file">
		<xsl:variable name="purgeOnMonthDiff" select="xdt:dayTimeDuration('P5D')"/>
		<xsl:variable name="now" select="current-date()"/>
		<xsl:variable name="fileDateString" select="substring-before(@date,' ')"/>
		<xsl:variable name="fileDate" select="xs:date($fileDateString)"/>
		<xsl:variable name="daysDifference" select="xs:date($now) - xs:date($fileDate)"/>
		<xsl:if test="$daysDifference ge $purgeOnMonthDiff">
			<shell:delete>
				<shell:source>
					<xsl:value-of select="concat($dir,'/',@name)"/>
				</shell:source>
			</shell:delete>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
