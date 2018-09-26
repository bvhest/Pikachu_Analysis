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
	<xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
	<!-- -->
	<xsl:template match="/">
	<root>
	<!-- clear all-->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT
set FLAG=0
where 
	CUSTOMER_ID='<xsl:value-of select="$channel"/>'
			</sql:query>
		</sql:execute-query>
	<!-- add all new products -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
SELECT distinct
	'<xsl:value-of select="$channel"/>',
	'MASTER',
	mp.ID,
	0
FROM CUSTOMER_LOCALE_EXPORT cle
right JOIN MASTER_PRODUCTS mp on mp.ID=cle.ctn and cle.locale='MASTER' and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
where 
	cle.CUSTOMER_ID is NULL
			</sql:query>
		</sql:execute-query>
	<!-- set flag to 1 if the export was before the last modified date -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set 
	FLAG=1
where exists 
(
	select distinct
		cle.CUSTOMER_ID,
		cle.locale,
		cle.ctn,
		cle.FLAG
	from MASTER_PRODUCTS mp
	where
		mp.ID=cle.ctn 
		and cle.locale='MASTER'
		and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
)
--	and rownum &lt;= 10000
			</sql:query>
		</sql:execute-query>
	<!-- -->
	</root>
</xsl:template>
</xsl:stylesheet>