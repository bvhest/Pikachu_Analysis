<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel" as="xs:string" select="'test'"/>
	<xsl:param name="lastrun" as="xs:integer" select="24"/>
	<xsl:param name="maxtime" as="xs:integer" select="5"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:attribute name="now" select="current-dateTime()"/>
			<xsl:attribute name="channel" select="$channel"/>
			<xsl:attribute name="lastrun" select="$lastrun"/>
			<xsl:attribute name="maxtime" select="$maxtime"/>
			<!-- update execute flag in Channel table -->
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
select 
	id,name,location,type,pipeline,machineaffinity, 
	convert(nvarchar, startexec, 126)+'Z' as startexec,
	convert(nvarchar, endexec, 126)+'Z' as endexec
from Channels c
where 
	c.name='<xsl:value-of select="$channel"/>'
			</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
