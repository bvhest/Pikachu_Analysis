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
	<xsl:param name="exportdate"></xsl:param>
	<!-- -->
	<xsl:template match="/">
	<batch>
		<xsl:attribute name="exportdate"><xsl:value-of select="$exportdate"/></xsl:attribute>
	<!-- set flag to 1 if the export was before the last modified date -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
select 
	cle.CTN,
	cle.LOCALE,
	1 as result,
	'Exported' as remark
from CUSTOMER_LOCALE_EXPORT cle
where 
	cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
	and cle.FLAG=1
			</sql:query>
		</sql:execute-query>
	</batch>
</xsl:template>
</xsl:stylesheet>