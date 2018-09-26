<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select *
from
(	  
	select tecount.exportdate, tecount.count, 
	  case 
		when ((tecount.count is null) or (tecount.count = 0)) then 0 
		else (100*((case when ticount.count is null then 0 else ticount.count end)/tecount.count)) 
	  end as percentage
	from (
	  select 
	    to_char(lasttransmit, 'yyyy-mm-dd"T"hh24:mi:ss') as exportdate, count(ctn) as count
	  from customer_locale_export
	  where 
	    customer_id = 'TranslationExport'
	    and not (lasttransmit is null)
	  group by lasttransmit  
	) tecount
	left outer join
	(
	  select to_char(te.lasttransmit, 'yyyy-mm-dd"T"hh24:mi:ss') as exportdate, count(te.ctn) as count
	  from (
	    select locale, ctn, lasttransmit 
	    from customer_locale_export
	    where 
	      customer_id = 'TranslationExport'
	  ) te
	  inner join (
	    select locale, id as ctn, lastmodified as lasttransmit 
	    from raw_localized_products
	  ) ti on ti.locale = te.locale and te.ctn = ti.ctn and te.lasttransmit &lt;= ti.lasttransmit
	  group by te.lasttransmit
	) ticount on ticount.exportdate = tecount.exportdate
	order by exportdate desc
)
where rownum &lt; 60
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>