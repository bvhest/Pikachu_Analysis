<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
(
select 'channel' as process_type
,      cle.customer_id as process_name
,      max(cle.lasttransmit) as last_transmit
from   customer_locale_export cle
inner join channels c
   on c.name = cle.customer_id
where  c.machineaffinity like 'all%'
group by 1, customer_id
having  (sysdate-max(cle.lasttransmit)) > 7
union all 
select 'content type' as process_type
,      o.content_type as process_name
,      max(o.lastmodified_ts) as last_transmit
from   octl o
inner join content_type_schedule cts
   on cts.content_type = o.content_type
where cts.machineaffinity like 'all%'
group by 1, o.content_type
having  (sysdate-max(o.lastmodified_ts)) > 7
)
order by last_transmit asc 
      </sql:query>

<!--
        <sql:query isstoredprocedure="true">
declare
begin
   Report_Functions.get_idle_processes3;
exception
   when others then raise_application_error (-20000, 'Error calling Report_Functions.get_idle_processes3():'||sqlerrm);
end;
        </sql:query>
-->

    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>