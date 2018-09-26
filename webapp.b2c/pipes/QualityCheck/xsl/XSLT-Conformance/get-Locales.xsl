<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="xsl xs fn sql">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="filename" select="''"/>
	
	<xsl:template match="/">
		<xsl:if test="//.[contains(.,'en_UK')]">
			<foundLocale filename="{$filename}"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
