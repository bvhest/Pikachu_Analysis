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
  nvl(todocount,0) as todocount, 
  nvl(outcount,0) as outcount, 
  nvl(incount,0) as incount,
  case 
    when nvl(outcount,0) = 0 then 0 
    else round((100*(nvl(incount,0)/outcount)),1) 
  end as percentage
from (
  select distinct languagecode as locale
  from locale_language
) ll
left outer join 
(
  select co.locale, count(mp.id) as todocount
  from (select * from MASTER_PRODUCTS where Status = 'Final Published') mp
  inner join (select distinct id from SUBCAT_PRODUCTS) SP on SP.ID = MP.ID
  inner join (
    select distinct ll.languagecode as locale, co.object_id 
    from catalog_objects co
    inner join locale_language ll on ll.country = co.country
    where
        sysdate &lt; (select max(EOP) from catalog_objects inner_co where co.object_id = inner_co.object_id and inner_co.customer_id is not null)
        and co.deleted = 0
        and co.customer_id is not null
  ) co on mp.id = co.object_id
  inner join (
      select distinct ll.languagecode as locale, lt.division
      from language_translations lt     
        inner join locale_language ll on ll.locale = lt.locale 
      where 
          lt.enabled > 0
  ) ces on ces.locale = co.locale and ces.division = mp.division
  left join (select o.object_id, o.localisation 
              from octl o
              left join octl_control oc
                on oc.modus        = 'BATCH'
               and oc.content_type = o.content_type
               and oc.localisation = o.localisation
               and oc.object_id    = o.object_id
             where o.content_type = 'PMT_Translated'
               and oc.needsprocessing_flag = 1
    <xsl:if test="$exportdate ne ''">
    and substr(remark, 8, 14) = '<xsl:value-of select="$exportdate"/>'
    </xsl:if>
  ) o on o.localisation = co.locale and o.object_id = mp.id
  group by co.locale
) tdcount on tdcount.locale = ll.locale
left outer join 
(
  select cle.locale, count(cle.ctn) as outcount
  from (select object_id ctn, localisation locale
        from octl
        where content_type = 'PMT_Translated'
        and status != 'PLACEHOLDER'
        <xsl:if test="$exportdate ne ''">
        and substr(remark, 8, 14) = '<xsl:value-of select="$exportdate"/>'
        </xsl:if>
        ) cle
  inner join MASTER_PRODUCTS MP on MP.ID = CLE.CTN and (MP.Status = 'Final Published')
  inner join (select distinct id from SUBCAT_PRODUCTS) SP on SP.ID = CLE.CTN
  inner join (
    select distinct ll.languagecode as locale, co.object_id 
    from catalog_objects co
    inner join locale_language ll on ll.country = co.country
    where
        sysdate &lt; (select max(EOP) from catalog_objects inner_co where co.object_id = inner_co.object_id and inner_co.customer_id is not null)
        and co.deleted = 0
        and co.customer_id is not null
  ) co on cle.ctn = co.object_id and cle.locale = co.locale
  group by cle.locale
) tecount on tecount.locale = ll.locale
left outer join
(
  select te.locale, count(te.ctn) as incount
  from (
      select cle.locale, cle.ctn
      from (select object_id ctn, localisation locale
            from octl
            where content_type = 'PMT_Translated'
            and status = 'Final Published'
            <xsl:if test="$exportdate ne ''">
            and substr(remark, 8, 14) = '<xsl:value-of select="$exportdate"/>'
            </xsl:if>
            ) cle
      inner join MASTER_PRODUCTS MP on MP.ID = CLE.CTN and (MP.Status = 'Final Published')
      inner join (select distinct id from SUBCAT_PRODUCTS) SP on SP.ID = CLE.CTN
      inner join (
        select distinct ll.languagecode as locale, co.object_id 
    from catalog_objects co
    inner join locale_language ll on ll.country = co.country
    where
        sysdate &lt; (select max(EOP) from catalog_objects inner_co where co.object_id = inner_co.object_id and inner_co.customer_id is not null)
        and co.deleted = 0
        and co.customer_id is not null
  ) co on cle.ctn = co.object_id and cle.locale = co.locale
  ) te

  group by te.locale
) ticount on ticount.locale = ll.locale
<xsl:if test="$exportdate ne ''">
where nvl(outcount,0) &gt; 0
</xsl:if>
order by ll.locale

      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>