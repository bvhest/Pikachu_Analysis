<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:status="http://apache.org/cocoon/status/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale">en_UK</xsl:param>
  <xsl:param name="repeat">daily</xsl:param>
  
  <xsl:template match="/">
    <root>
		<xsl:apply-templates/>
    </root>
  </xsl:template>
  
  <xsl:template match="status:statusinfo">
      <xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          select * from 
          (
            select id,Name,Pipeline,StartExec,EndExec,machineaffinity,sequence
            from Channels  
              union
            select cts.id,ct.display_name as name,cts.Pipeline,cts.StartExec,cts.EndExec,cts.machineaffinity,cts.sequence
            from content_type_schedule cts 
            inner join content_types ct 
            on cts.content_type = ct.content_type
          )
          where (  substr(MachineAffinity,1,3) = 'all' 
          		        or 
                   MachineAffinity = substr('<xsl:value-of select="@status:host"/>', 1, length(MachineAffinity))
          	     ) 
            and (  'x<xsl:value-of select="$repeat"/>x'='xx'
          		        or 
                   MachineAffinity like '%(<xsl:value-of select="$repeat"/>)%'
          	     ) 
          order by sequence asc
      </sql:query>
      </sql:execute-query>
  </xsl:template>
  
  <xsl:template match="*|node()">
		<xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
