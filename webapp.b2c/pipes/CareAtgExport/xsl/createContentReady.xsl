<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:pika="http://www.philips.com/pikachu"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
	extension-element-prefixes="pika">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="delta"/>
	<xsl:template match="/">	
		<xsl:variable name="runtimestamp" select="/root/sql:rowset[@name='timestamp']/sql:row/sql:startexec"/>
		<xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($runtimestamp),1,19),':',''),'-',''),' ','')"/>	
		<xsl:variable name="maxbatch" select="/root/sql:rowset[@name='maxbatch']/sql:row/sql:maxbatch"/>
		<xsl:choose>
			<xsl:when test="$delta='y'">
				<root ts="{$timestamp}">
					<cinclude:include>
						<xsl:attribute name="src"><xsl:text>cocoon:/createCONTENTREADY.</xsl:text><xsl:value-of select="xs:integer($timestamp)"/></xsl:attribute>
					</cinclude:include>
				</root>
			</xsl:when>
			<xsl:otherwise>
				<root ts="{$timestamp}">
					<xsl:for-each select="for $i in 1 to $maxbatch return $i">
						<cinclude:include>
							<xsl:attribute name="src"><xsl:text>cocoon:/createCONTENTREADY.</xsl:text><xsl:value-of select="xs:integer($timestamp) + (. - 1)"/></xsl:attribute>
						</cinclude:include>
					</xsl:for-each>
				</root>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
</xsl:stylesheet>