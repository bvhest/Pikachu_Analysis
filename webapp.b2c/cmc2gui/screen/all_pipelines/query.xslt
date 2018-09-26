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
    select 'cmc2' as section, 'content_type' as screen
         , to_char(cts.sequence, '00009') as id, to_char(cts.id) as idReal
         , ct.content_type
         , cts.description
         , cts.MachineAffinity
         , cts.StartExec start_ts
         , cts.EndExec end_ts
         , to_char(cts.StartExec,'DD-MM-YYYY HH24:MI:SS') startexec
         , to_char(cts.EndExec,'DD-MM-YYYY HH24:MI:SS') endexec
         , to_char(cts.StartExec,'YYYYMMDDHH24MISS') startexec2
         , to_char(cts.EndExec,'YYYYMMDDHH24MISS') endexec2
         , cts.pipeline,
         ((cts.EndExec - cts.StartExec) * 1440) duration_in_min,
         ((cts.EndExec - cts.StartExec) * 24) duration_in_hours
              
    from CONTENT_TYPES ct
    
    inner join content_type_schedule cts
       on ct.content_type = cts.content_type
        
    where cts.pipeline is not null

  union

    select 'pikachu' as section, 'pikachu_channel_home' as screen
         , to_char(c.sequence, '00009') as id, to_char(c.id) as idReal
         , case 
             when c.name like '%/%' 
             then substr(c.name, 1 ,instr(c.name, '/', 1, 1)-1) 
             else c.name 
             end as content_type
         , c.type as description
         , c.machineaffinity
         , c.StartExec start_ts
         , c.EndExec end_ts
         , to_char(c.StartExec,'DD-MM-YYYY HH24:MI:SS') startexec
         , to_char(c.EndExec,'DD-MM-YYYY HH24:MI:SS') endexec
         , to_char(StartExec,'YYYYMMDDHH24MISS') startexec2
         , to_char(EndExec,'YYYYMMDDHH24MISS') endexec2
         , c.pipeline,
		 ((EndExec - StartExec) * 1440) duration_in_min,
		 ((EndExec - StartExec) * 24) duration_in_hours
    
    from channels c
)
where machineaffinity not like 'deprecated%'
   or start_ts > end_ts
   
order by id

      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>