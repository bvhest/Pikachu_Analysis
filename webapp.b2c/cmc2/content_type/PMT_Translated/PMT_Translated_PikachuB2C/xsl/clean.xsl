<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
		
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="globalDocs"/>
	
	<xsl:template match="content[content]">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="sql:rowset">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="sql:row">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="sql:data">
		<xsl:apply-templates/>
	</xsl:template>

	
	<xsl:template match="sql:*">
	</xsl:template>
	
	<xsl:template match="content/object"/>

</xsl:stylesheet>
