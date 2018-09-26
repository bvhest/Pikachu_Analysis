<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="filename" select="''"/>
	
	<xsl:template match="node()">
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<xsl:template match="sql:query[@name='cat']" exclude-result-prefixes="sql">
		<found>Found '<sql:query name="cat">......</sql:query>' within '<xsl:value-of select="$filename"/>'.</found>
	</xsl:template>

</xsl:stylesheet>
