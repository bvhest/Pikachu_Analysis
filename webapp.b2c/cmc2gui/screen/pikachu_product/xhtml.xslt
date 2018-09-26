<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	exclude-result-prefixes="sql xsl cinclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="/">
		<Products>
			<xsl:apply-templates select="@*|node()"/>
		</Products>
	</xsl:template>
	<!-- -->		
	<xsl:template match="root|sql:rowset|sql:row|sql:data">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!-- -->	
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->	
</xsl:stylesheet>
