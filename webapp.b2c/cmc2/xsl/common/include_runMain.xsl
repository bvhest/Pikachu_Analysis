<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="ct"/>

	<xsl:template match="/root">
		<root>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</root>
	</xsl:template>
	
	<xsl:template match="sql:rowset/sql:row">
			<xsl:variable name="ts" select="replace(replace(replace(substring(xs:string(sql:startexec),1,19),':',''),'-',''),' ','')"/>	
			<cinclude:include src="cocoon:/runMain/{$ct}/{$ts}"/>
	</xsl:template>

</xsl:stylesheet>