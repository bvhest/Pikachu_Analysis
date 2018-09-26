<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>

  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select * from 
(
select 'pikachu' as section
,      'pikachu_channel_home' as screen
,      to_char(c.sequence, '00009') as id
,      to_char(c.sequence) as idReal
,      case 
         when c.name like '%/%' 
         then substr(c.name, 1 ,instr(c.name, '/', 1, 1)-1) 
         else c.name 
         end as content_type
,      c.pipeline
,      c.machineaffinity
,      'channel' as process_type
,      c.name
,      to_char(c.StartExec,'DD-MM-YYYY HH24:MI:SS') startexec
,      to_char(c.EndExec,'DD-MM-YYYY HH24:MI:SS') endexec
,      to_char(c.StartExec,'YYYYMMDDHH24MISS') startexec2
,      to_char(c.EndExec,'YYYYMMDDHH24MISS') endexec2
,      c.type as type
,      c.sequence
from   channels c
where  c.machineaffinity like 'all%'
  and  (sysdate-c.startexec) > 7
UNION ALL
select 'cmc2' as section
,      'content_type' as screen
,      to_char(cts.sequence, '00009') as id
,      to_char(cts.sequence) as idReal
,      ct.content_type
,      cts.pipeline
,      cts.machineaffinity
,      'content type' as process_type
,      cts.content_type as name
,      to_char(cts.StartExec,'DD-MM-YYYY HH24:MI:SS') startexec
,      to_char(cts.EndExec,'DD-MM-YYYY HH24:MI:SS') endexec
,      to_char(cts.StartExec,'YYYYMMDDHH24MISS') startexec2
,      to_char(cts.EndExec,'YYYYMMDDHH24MISS') endexec2
,      cts.description as type
,      cts.sequence
from   content_type_schedule cts
inner join content_types ct
   on ct.content_type = cts.content_type
where  cts.machineaffinity like 'all%'
  and  (sysdate-cts.startexec) > 7
)
order by startexec2 desc
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>