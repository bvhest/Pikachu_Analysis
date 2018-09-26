<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:variable name="locale" select="$param1"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
select lp.ID as ID, lp.STATUS, lp.LASTMODIFIED, SOP, EOP, nvl(lp.division, lc.division) as division, catalog_type, 1 as dataAvailable
from LOCALIZED_PRODUCTS lp
left join LOCAL_CATALOG lc on lp.ID = lc.CTN and lc.COUNTRY=substr(lp.Locale,4,2)
where lp.LOCALE='<xsl:value-of select="$locale"/>'

union 
select lc.CTN, lp.STATUS, lp.LASTMODIFIED, SOP, EOP, nvl(lp.division, lc.division) as division, catalog_type, 0 as dataAvailable
from LOCALIZED_PRODUCTS lp
right join LOCAL_CATALOG lc on lp.ID = lc.CTN and lc.COUNTRY=substr(lp.Locale,4,2)
where lc.COUNTRY=substr('<xsl:value-of select="$locale"/>',4,2) and lp.ID is NULL
order by ID
      </sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
