<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="exportdate"/>
	
	<!-- -->
	<xsl:template match="/">
	<root>
	<!-- set flag to 1 if the export was before the last modified date -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set 
	FLAG=0,
	LASTTRANSMIT=to_date('<xsl:value-of select="$exportdate"/>','yyyymmddhh24miss')
where 
	cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
	and cle.locale='<xsl:value-of select="$locale"/>'
	and cle.FLAG=1
			</sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>