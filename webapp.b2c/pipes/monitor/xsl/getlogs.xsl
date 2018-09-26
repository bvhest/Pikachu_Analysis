<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:include="http://apache.org/cocoon/include/1.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="sql:rowset">
		<xsl:attribute name="startexec" select="sql:row/sql:startexec"/>
		<xsl:attribute name="endexec" select="sql:row/sql:endexec"/>
		<xsl:attribute name="id" select="sql:row/sql:id"/>
		<xsl:attribute name="location" select="sql:row/sql:location"/>
		<include:include>
			<xsl:attribute name="src" select="concat('cocoon:/getdir_',sql:row/sql:location,'/logs')"/>
		</include:include>
	</xsl:template>
	<!--  -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
