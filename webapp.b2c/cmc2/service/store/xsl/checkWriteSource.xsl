<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0">
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="valid_entry">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="valid_entry"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="entry[@valid='true'] ">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="valid_entry"/>
		</xsl:copy>		
	</xsl:template>	
	
	<!-- -->
	<xsl:template match="entry/@valid" mode="valid_entry">
		<xsl:attribute name="valid" select=" if (../sourceResult/execution = 'success') then . else 'false' "/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="result" mode="valid_entry">
		<xsl:copy copy-namespaces="no">
			<xsl:choose>
				<xsl:when test="../sourceResult/execution = 'success' ">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>Filestore Write Failure</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:execute-query" mode="valid_entry">
		<xsl:if test="../sourceResult/execution = 'success' ">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
