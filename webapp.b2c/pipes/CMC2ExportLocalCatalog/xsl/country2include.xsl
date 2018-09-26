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
	
		
	<xsl:template match="/root">
		<xsl:variable name="now" select="substring(xs:string(current-dateTime()),1,16)"/>
		<xsl:variable name="snow" select="translate($now,'-:T','')"/>

		<root>
			<batch exportdate="{$snow}">
			<xsl:for-each select="sql:rowset/sql:row">
					<cinclude:include>
						<xsl:attribute name="src"><xsl:text>cocoon:/exportSub.</xsl:text><xsl:value-of select="$snow"/><xsl:text>.</xsl:text><xsl:value-of select="replace(sql:customer_id,' ','_')"/><xsl:text>.</xsl:text><xsl:value-of select="sql:country"/></xsl:attribute>
					</cinclude:include>

			</xsl:for-each>
			</batch>
		</root>
	</xsl:template>

	</xsl:stylesheet>