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
	<xsl:variable name="gnow" select="current-dateTime()"/>
	<xsl:template match="/">
		<root>
			<xsl:variable name="runtimestamp" select="/root/sql:rowset[@name='timestamp']/sql:row/sql:startexec"/>
			<xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($runtimestamp),1,19),':',''),'-',''),' ','')"/>
			<xsl:apply-templates select="/root/sql:rowset[@name='locales']/sql:row">
				<xsl:with-param name="timestamp" select="$timestamp"/>
			</xsl:apply-templates>	
			
			<!--xsl:variable name="now" select="current-dateTime()"/>
			<xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
			<xsl:variable name="snow18NoTee" select="replace(replace(replace(substring(xs:string(current-dateTime()),1,19),':',''),'-',''),'T','')"/>
			<xsl:apply-templates select="/root/sql:rowset[@name='locales']/sql:row" >
				<xsl:with-param name="timestamp13" select="$snow"/>
				<xsl:with-param name="timestamp14" select="$snow18NoTee"/>
			</xsl:apply-templates-->
					
		</root>
	</xsl:template>

	<xsl:template match="sql:row">
		<xsl:variable name="locale" select="sql:locale"/>
		<xsl:variable name="catalogtype" select="sql:catalogtype"/>
		<xsl:param name="timestamp"/>
		<cinclude:include>
			<xsl:attribute name="src"><xsl:text>cocoon:/batchSub.</xsl:text><xsl:value-of select="$timestamp"/><xsl:text>.</xsl:text><xsl:value-of select="substring-after($locale,'_')"/><xsl:text>.</xsl:text><xsl:value-of select="$locale"/><xsl:text>.</xsl:text><xsl:value-of select="sql:ct"/></xsl:attribute>
		</cinclude:include>
	</xsl:template>

</xsl:stylesheet>