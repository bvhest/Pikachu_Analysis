<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>
  <!-- Query for the CONTENT_TYPES-homepage & tab -->
  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select lpad(cts.id,5,0) as id,
       cts.id as idReal,
       ct.reference_name,
       ct.content_type,
       cts.description,
       cts.MachineAffinity,
       to_char(cts.StartExec,'DD-MM-YYYY HH24:MI:SS') startexec,
       to_char(cts.StartExec,'YYYYMMDDHH24MISS') startexec2,
       to_char(cts.EndExec,'DD-MM-YYYY HH24:MI:SS') endexec,
       to_char(cts.EndExec,'YYYYMMDDHH24MISS') endexec2,
       floor(((sysdate - cts.StartExec)*24*60*60)/60) as minutes_duration,
       apt.Avg_Runtime_Minutes as avg_runtime,
       apt.Max_Runtime_Minutes as max_runtime,
       cts.pipeline
from CONTENT_TYPES ct
left outer join PCU_AVG_PROCESS_TIMES apt
  on ct.content_type = apt.process_name
left outer join CONTENT_TYPE_SCHEDULE cts 
  on ct.content_type = cts.content_type
where cts.pipeline is not null
  and cts.machineaffinity not like 'deprecated%'
order by cts.StartExec desc nulls last
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>