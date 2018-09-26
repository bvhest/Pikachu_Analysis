<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel">test</xsl:param>
	<!-- -->
	<xsl:template match="/">
	<root>
		<xsl:variable name="now" select="current-dateTime()"/>
	<!-- update execute flag in Channel table -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
select *
from CUSTOMER_LOCALE_EXPORT c
where 
	c.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
order by ctn	
			</sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>