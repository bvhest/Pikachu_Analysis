<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0">
	
	<xsl:template match="/source:write[source:fragment[1]/ProductsMsg[1]/Product[1]]">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="@*|node()">
	<root/>
	</xsl:template>
	
</xsl:stylesheet>