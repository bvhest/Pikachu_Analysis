<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="locale">en_UK</xsl:param>
	<xsl:template match="/">
		<Products>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
select lp.ID,ll.LANGUAGE, TO_CHAR(lc.sop,'yyyy-mm-dd"T"hh24:mi:ss') as sop, TO_CHAR(lc.eop,'yyyy-mm-dd"T"hh24:mi:ss') as eop, lp.DATA
from LOCALIZED_PRODUCTS lp
inner join LOCALE_LANGUAGE ll on lp.LOCALE = ll.LOCALE
inner join customer_catalog lc on lc.CTN=lp.ID and lc.COUNTRY=ll.country
inner join CUSTOMER_LOCALE_EXPORT cle on cle.ctn=lp.ID and cle.locale=lp.LOCALE and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>' and cle.flag=1
where 
	lp.locale='<xsl:value-of select="$locale"/>'
	and lc.customer_id = nvl((
    SELECT lc2.customer_id 
    from customer_catalog lc2 
    WHERE
      lc2.COUNTRY = ll.Country
      and lc2.CTN = lp.id 
      and rownum = 1
      and customer_id = 'CONSUMER'
  ), (
    SELECT lc2.customer_id 
    from customer_catalog lc2 
    WHERE
      lc2.COUNTRY = ll.Country
      and lc2.CTN = lp.id 
      and rownum = 1
      and customer_id != 'CONSUMER'
  ))
order by lp.ID</sql:query>
			</sql:execute-query>
		</Products>
	</xsl:template>
</xsl:stylesheet>
