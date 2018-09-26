<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="sql:rowset|sql:row|sql:object_id">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="node()[(@type='Subcat' or @type='Alphanumeric' or @type='AG')] ">
		<xsl:variable name="nodeName" select="local-name()"/>
		<xsl:variable name="nodeAttributes" select="@*"/>
		
		<xsl:for-each select="sql:rowset/sql:row/sql:object_id">
			<xsl:element name="{$nodeName}">
			<xsl:copy-of select="$nodeAttributes"/>
			<xsl:element name="id"><xsl:value-of select="."/></xsl:element>
			</xsl:element>
		
		</xsl:for-each>
			
		
	</xsl:template>
	
	
</xsl:stylesheet>
