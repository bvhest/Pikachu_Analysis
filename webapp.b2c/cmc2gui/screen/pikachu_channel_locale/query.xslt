<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1">CNet</xsl:param>
	<xsl:param name="param2">en_UK</xsl:param>
	<xsl:variable name="locale" select="$param2"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="channels">
select name, catalog
from Channels
where location='<xsl:value-of select="$param1"/>'
				</sql:query>
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query>
select cc.CTN as ID, cc.SOP, cc.EOP, cc.Deleted, cp.var1, cp.var2, cp.var3, cp.var4, cp.var5, lp.LastModified, cle.LASTTRANSMIT,
  case when lp.LastModified is Null then 0 else 1 end as dataAvailable
from (
	  select ll.locale, cc.* from 
	  CUSTOMER_CATALOG cc
	  inner join locale_language ll on cc.country = ll.country
	  where cc.CUSTOMER_ID='<sql:ancestor-value name="catalog" level="1"/>'
	) cc
left join CHANNEL_PARAM cp on cc.CTN=cp.ID and cp.CHANNEL=cc.CUSTOMER_ID
left join CUSTOMER_LOCALE_EXPORT cle on cc.CTN=cle.CTN and cle.CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>' and cc.locale=cle.locale
left join LOCALIZED_PRODUCTS lp on lp.id = cc.ctn and lp.locale = cc.locale
where 
	cc.CUSTOMER_ID='<sql:ancestor-value name="catalog" level="1"/>'
	and cc.locale='<xsl:value-of select="$locale"/>'
union	
select cle.CTN as ID, cc.SOP, cc.EOP, cc.Deleted, cp.var1, cp.var2, cp.var3, cp.var4, cp.var5, lp.LastModified, cle.LASTTRANSMIT,
  case when lp.LastModified is Null then 0 else 1 end as dataAvailable
from (
	  select ll.locale, cc.* from 
	  CUSTOMER_CATALOG cc
	  inner join locale_language ll on cc.country = ll.country
	  where cc.CUSTOMER_ID='<sql:ancestor-value name="catalog" level="1"/>'
	) cc
right join CUSTOMER_LOCALE_EXPORT cle on cc.CTN=cle.CTN and cle.CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>' and cc.locale=cle.locale
left join CHANNEL_PARAM cp on cle.CTN=cp.ID and cp.CHANNEL=cle.CUSTOMER_ID
left join LOCALIZED_PRODUCTS lp on lp.id = cle.ctn and lp.locale = cle.locale
where 
	cle.CUSTOMER_ID='<sql:ancestor-value name="name" level="1"/>'
	and cle.LOCALE='<xsl:value-of select="$locale"/>'
	and cc.CTN is NULL
order by ID
      </sql:query>
				</sql:execute-query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
