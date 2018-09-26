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
	<xsl:param name="exportDateTime"></xsl:param>
	<!-- -->
	<xsl:template match="/">
	<root>
	<!-- Reset the export flags for existing products for this export channel and locale -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT
set FLAG=0
where 
	CUSTOMER_ID='<xsl:value-of select="$channel"/>'
	and LOCALE='<xsl:value-of select="$locale"/>'
			</sql:query>
		</sql:execute-query>
	<!-- Add all new products for this export channel and locale -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
INSERT INTO CUSTOMER_LOCALE_EXPORT (CUSTOMER_ID, LOCALE, CTN, FLAG)
SELECT DISTINCT 
    '<xsl:value-of select="$channel"/>',
    sc.locale,
    sc.catalogcode,
    0
FROM localized_subcat sc
WHERE sc.locale = '<xsl:value-of select="$locale"/>'
and  NOT EXISTS 
(SELECT * FROM CUSTOMER_LOCALE_EXPORT cle WHERE cle.customer_id = '<xsl:value-of select="$channel"/>' and cle.locale='<xsl:value-of select="$locale"/>' and cle.ctn = sc.catalogcode)
			</sql:query>
		</sql:execute-query>
	<!-- Put flag to 1 for all products in this channel and locale that have been updated at master level. Leave out all products that have no subcat -->
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
            from LOCALIZED_SUBCAT ls
WHERE 
    cle.locale = '<xsl:value-of select="$locale"/>'
    and cle.customer_id = '<xsl:value-of select="$channel"/>'
    and cle.ctn = ls.catalogcode
    and ( ls.lastmodified > cle.lasttransmit
          or cle.lasttransmit is null)
)        
 			</sql:query>
		</sql:execute-query>
	<!-- -->
	</root>
</xsl:template>
</xsl:stylesheet>