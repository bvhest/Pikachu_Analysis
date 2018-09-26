<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="locale">en_UK</xsl:param>
	<!-- -->
	<xsl:template match="/">
		<Products>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
select mp.id, 'ENG' as language, mp.DATA
from MASTER_PRODUCTS mp
inner join CUSTOMER_LOCALE_EXPORT cle on 
	cle.ctn=mp.ID 
	and cle.locale='MASTER' 
	and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>' 
	and cle.flag=1
order by mp.ID</sql:query>
				<sql:execute-query>
					<sql:query name="cat">
select distinct sc.GROUPCODE, sc.GROUPNAME, sc.CATEGORYCODE, sc.CATEGORYNAME, sc.SUBCATEGORYCODE, sc.SUBCATEGORYNAME 
from SUBCAT_PRODUCTS sp
inner join SUBCAT sc on sp.SUBCATEGORYCODE = sc.SUBCATEGORYCODE
where sp.ID = '<sql:ancestor-value name="id" level="1"/>'</sql:query>
				</sql:execute-query>
			</sql:execute-query>
		</Products>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
