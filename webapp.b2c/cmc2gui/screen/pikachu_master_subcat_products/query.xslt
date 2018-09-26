<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>
  <xsl:param name="subcat">ACCESSORIES_MED_SU</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select sp.ID, mp.Status, 1 as dataAvailable
from SUBCAT_PRODUCTS sp
inner join MASTER_PRODUCTS mp on mp.ID=sp.ID
where sp.SubCategoryCode='<xsl:value-of select="$subcat"/>'
union
select sp.ID, mp.Status, 0 as dataAvailable
from SUBCAT_PRODUCTS sp
left join MASTER_PRODUCTS mp on mp.ID=sp.ID
where sp.SubCategoryCode='<xsl:value-of select="$subcat"/>' and mp.ID is NULL
order by ID
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>