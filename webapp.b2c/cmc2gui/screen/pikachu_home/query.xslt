<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>
  <xsl:param name="section"/>
  <!-- Query for the CHANNELS-tab -->
  <xsl:template match="/">
  <root>
	<xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select lpad(ch.id,5,0) as id,
	ch.id as idReal,
	ch.Name,
	ch.Type,
	ch.Location,
	ch.Pipeline,
	ch.MachineAffinity,
	ch.StartExec,
	ch.EndExec,
	nvl(ch.resultcode,0) resultcode,
	to_char(ch.StartExec,'YYYYMMDDHH24MISS') startexec2, 
	to_char(ch.EndExec,'YYYYMMDDHH24MISS') endexec2,
    floor(((sysdate - ch.StartExec)*24*60*60)/60) as minutes_duration,
    apt.Avg_Runtime_Minutes as avg_runtime,
    apt.Max_Runtime_Minutes as max_runtime
from Channels ch
left outer join PCU_AVG_PROCESS_TIMES apt
  on ch.Name = apt.process_name
where ch.machineaffinity not like 'deprecated%'
<xsl:if test="$section and not($section = ('pikachu','home'))">
	and ch.type = '<xsl:value-of select="$section"/>'
</xsl:if>
order by ch.startexec desc nulls last
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>