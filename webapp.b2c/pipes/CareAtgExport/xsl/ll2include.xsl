<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="timestamp"></xsl:param>
	<xsl:param name="channel"></xsl:param>
	<xsl:param name="country"></xsl:param>
	<xsl:param name="locale"></xsl:param>
	<xsl:param name="delta"/>
	<xsl:param name="contentType"></xsl:param>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="sql:rowset">
		<xsl:variable name="count" select="sum(sql:row/sql:number_ctns)"/>
		<xsl:choose>
			<xsl:when test="$delta='y'">
				<xsl:choose>
					<xsl:when test="number($count) > 0">
						<cinclude:include src="{concat('cocoon:/exportSub.',$timestamp,'.',$country,'.',$locale,'.',sql:row[1]/sql:maxbatch,'.',sql:row[1]/sql:maxbatch,'.', $contentType  )}"/>
					</xsl:when>
					<xsl:otherwise>
						<batch exportdate="{$timestamp}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="sql:row">
		<xsl:variable name="batch" select="sql:batch" as="xs:integer"/>
		<xsl:variable name="maxbatch" select="sql:maxbatch" as="xs:integer"/>
		<xsl:variable name="timestampint" select="xs:integer($timestamp)"/>
		<xsl:variable name="runtimestamp" select="$timestampint + ($batch - 1)"/>
		<cinclude:include src="{concat('cocoon:/exportSub.',$runtimestamp,'.',$country,'.',$locale,'.',$batch,'.',$maxbatch,'.', $contentType)}"/>
	</xsl:template>
	
</xsl:stylesheet>