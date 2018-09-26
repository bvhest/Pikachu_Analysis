<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="channels">
select name, catalog
from Channels
where location='<xsl:value-of select="$param1"/>'
      </sql:query>
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query name="list">
select locales.locale, clelist.count
from
(		  
	select aa.locale, count(aa.CTN) as count
	from (
		select cle.locale, cle.CTN, cle.lastTransmit
		from (
	          select ll.locale, cc.CTN, cc.CUSTOMER_ID from 
	          CUSTOMER_CATALOG cc
	          inner join locale_language ll on cc.country = ll.country
	          where cc.CUSTOMER_ID='<sql:ancestor-value name="catalog" level="1"/>'
	        ) cc
	        right join CUSTOMER_LOCALE_EXPORT cle on 
	          cc.CTN=cle.CTN and cc.locale=cle.locale
	        where 
	          cle.lastTransmit is not NULL and cle.CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>'
	) aa
	group by aa.locale
) clelist
right join (
	select distinct locale
	from (
		  select ll.locale, cc.CTN, cc.CUSTOMER_ID from 
		  CUSTOMER_CATALOG cc
		  inner join locale_language ll on cc.country = ll.country
		  where cc.CUSTOMER_ID='<sql:ancestor-value name="catalog" level="1"/>'
		) cc
	union
	select distinct locale
	from CUSTOMER_LOCALE_EXPORT cle
	where cle.CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>'
) locales on locales.locale = clelist.locale
order by locales.locale
	      </sql:query>
        </sql:execute-query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>



