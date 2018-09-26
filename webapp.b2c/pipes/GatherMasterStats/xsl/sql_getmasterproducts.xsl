<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="/">
		<batch exportdate="12">
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
select 
	cc.ctn, nvl(cc.division, mp.division) as division, mp.brand, mp.lastmodified, 'Master' as locale, 
	to_char(sop,'YYYY-MM-DD') as sop, to_char(eop,'YYYY-MM-DD') as eop
from 
	MASTER_PRODUCTS mp
    right outer join (
        select ctn, min(sop) as sop, max(eop) as eop, min( division) as division
        from customer_catalog
        group by ctn
    ) cc on cc.ctn = mp.id
where 
	mp.status = 'Final Published' or mp.status is NULL
order by cc.ctn
				</sql:query>
			</sql:execute-query>
			</batch>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
