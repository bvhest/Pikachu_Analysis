<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="exportdate"/>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="exportdate"><xsl:value-of select="$exportdate"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select 
  ll.locale, 
  case when outcount is null then 0 else outcount end as outcount, 
  case when incount is null then 0 else incount end as incount,
  case 
	when ((outcount is null) or (outcount = 0)) then 0 
	else (100*((case when incount is null then 0 else incount end)/outcount)) 
  end as percentage
from (
  select distinct languagecode as locale
  from locale_language
) ll
left outer join 
(
  select locale, count(ctn) as outcount
  from customer_locale_export
  where 
    customer_id = 'TranslationExport'
    and to_char(lasttransmit,'yyyy-mm-dd"T"hh24:mi:ss') = '<xsl:value-of select="$exportdate"/>'
  group by locale
) tecount on tecount.locale = ll.locale
left outer join
(
  select te.locale, count(te.ctn) as incount
  from (
    select locale, ctn, lasttransmit 
    from customer_locale_export
    where 
      customer_id = 'TranslationExport'
      and to_char(lasttransmit,'yyyy-mm-dd"T"hh24:mi:ss') = '<xsl:value-of select="$exportdate"/>'
  ) te
  inner join (
    select locale, id as ctn, lastmodified as lasttransmit 
    from raw_localized_products
    where 
      lastmodified &gt; to_date('<xsl:value-of select="$exportdate"/>','yyyy-mm-dd"T"hh24:mi:ss')
  ) ti on ti.locale = te.locale and te.ctn = ti.ctn
  group by te.locale
) ticount on ticount.locale = ll.locale
order by ll.locale
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>