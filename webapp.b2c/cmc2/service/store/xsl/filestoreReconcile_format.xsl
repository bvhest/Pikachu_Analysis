<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:param name="ct"/>
	<xsl:param name="localisation"/>
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="/report">
		<xsl:variable name="status" select="if (sql:rowset/sql:error) then sql:rowset/sql:error else if (not(sql:rowset/sql:row)) then 'no data' else 'ok' "/>
		<xsl:copy copy-namespaces="no">
			<xsl:attribute name="status" select="$status"/>
			<xsl:if test="$status='ok'">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="dir:directory">
		<xsl:element name="filestore">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sql:rowset">
		<xsl:element name="database">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<!-- -->
	<xsl:template match="dir:file">
		<xsl:element name="fs_filename">
			<xsl:value-of select="substring-before(@name,'.xml')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sql:row">
		<xsl:element name="db_filename">
			<xsl:value-of select="substring-after(.,concat('/',$ct,'/',$localisation,'/'))"/>
		</xsl:element>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
