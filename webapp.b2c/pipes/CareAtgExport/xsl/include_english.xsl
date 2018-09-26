<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	
	 <xsl:param name="timestamp"/>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="sql:rowset">
		<root>
			<xsl:apply-templates select="@*|node()"/>
		</root>
	</xsl:template>
	
	<xsl:template match="sql:country_code">
	<country>
		<cinclude:include src="{concat('cocoon:/english.',$timestamp,'.',.)}"/>
	</country>
	</xsl:template>
	
</xsl:stylesheet>