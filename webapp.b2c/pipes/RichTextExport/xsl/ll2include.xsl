<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">	
		<xsl:variable name="runtimestamp" select="/root/sql:rowset[@name='timestamp']/sql:row/sql:startexec"/>
		<xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($runtimestamp),1,19),':',''),'-',''),' ','')"/>	
		<root>
			<xsl:apply-templates select="/root/sql:rowset[@name='timestamp']/sql:row">
				<xsl:with-param name="timestamp" select="$timestamp"/>
			</xsl:apply-templates>	
		</root>
	</xsl:template>
	
	<xsl:template match="sql:row">
		<xsl:param name="timestamp"/>
		<cinclude:include>
			<xsl:attribute name="src"><xsl:text>cocoon:/exportSub.</xsl:text><xsl:value-of select="$timestamp"/></xsl:attribute>
		</cinclude:include>
	</xsl:template>
	
</xsl:stylesheet>