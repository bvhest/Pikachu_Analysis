<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<Products>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="product">
select *
from 
(
  select mp.ID, rmp.lastModified, mp.division, mp.data
  from Master_Products mp
  inner join raw_master_products rmp on rmp.ctn = mp.id and rmp.data_type = 'Product'
  where
    mp.status = 'Final Published'
  order by rmp.lastModified desc
) d
where
   rownum &lt;= 15			
				</sql:query>
			</sql:execute-query>
		</Products>
	</xsl:template>
</xsl:stylesheet>