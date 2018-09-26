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
	<xsl:param name="country">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
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
	and LOCALE='<xsl:value-of select="$locale"/>'
			</sql:query>
		</sql:execute-query>
	<!-- add all new products -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
SELECT 
	'<xsl:value-of select="$channel"/>',
	lp.LOCALE,
	lp.ID,
	0
FROM CUSTOMER_LOCALE_EXPORT cle
right JOIN LOCALIZED_PRODUCTS lp on lp.ID=cle.ctn and lp.locale=cle.locale and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
inner join MASTER_PRODUCTS mp on mp.ID = lp.ID
where 
	cle.CUSTOMER_ID is NULL and
	lp.locale='<xsl:value-of select="$locale"/>'
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
	from  LOCALIZED_PRODUCTS lp
	inner join MASTER_PRODUCTS mp on mp.ID = lp.ID
	inner join customer_catalog lc on lc.CTN=lp.ID and lc.COUNTRY='<xsl:value-of select="substring-after($locale,'_')"/>'
	where
		lp.ID=cle.ctn 
		and lp.locale=cle.locale
		and lp.locale='<xsl:value-of select="$locale"/>'
		and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
		and deleted != 1
)
--	and rownum &lt;= 10000
			</sql:query>
		</sql:execute-query>
	<!-- -->
	</root>
</xsl:template>
</xsl:stylesheet>