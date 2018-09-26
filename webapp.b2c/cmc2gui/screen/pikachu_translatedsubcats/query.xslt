<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="subcatcode">Grills</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="subcatcode"><xsl:value-of select="$subcatcode"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select *
from ( 
	select
		0 as orderId,
		'CODES' as locale,
		catalogcode as catalogname,
		groupcode as groupname,
		categorycode as categoryname,
		subcategorycode as subcategoryname,
		subcategorycode
	from subcat
	union
	select
		1 as orderId,
		'MASTER' as locale,
		catalogname,
		groupname,
		categoryname,
		subcategoryname,
		subcategorycode
	from subcat
	union 
	select
		2 as orderId,
		locale,
		catalogname,
		groupname,
		categoryname,
		subcategoryname,
		subcategorycode
	from localized_subcat
)
where 
	subcategorycode = '<xsl:value-of select="$subcatcode"/>'
order by 
	orderId,
	locale, 
	catalogname,
	groupname,
	categoryname,
	subcategoryname
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>