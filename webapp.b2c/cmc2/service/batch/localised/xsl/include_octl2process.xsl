<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:sql="http://apache.org/cocoon/SQL/2.0"
				xmlns:cinclude="http://apache.org/cocoon/include/1.0">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="ctURL">test</xsl:param>

	<xsl:template match="/root">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entries">
		<entries>
			<xsl:copy-of select="@*|node()[not(local-name() = 'rowset')]"/>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</entries>
	</xsl:template>

	<xsl:template match="sql:rowset/sql:row">
		<cinclude:include src="{$ctURL}{sql:content_type}/process/{sql:localisation}/{sql:ts}/{sql:object_id}" />
	</xsl:template>


</xsl:stylesheet>