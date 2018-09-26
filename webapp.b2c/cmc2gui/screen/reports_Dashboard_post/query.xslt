<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="p_date"/>
  <xsl:param name="p_runmode"/>
  <xsl:param name="p_details"/>
  <xsl:param name="p_period">60</xsl:param>

  <xsl:variable name="file" select="document('./gui_dashboard_process_selection.xml')" />
  <xsl:variable name="apos">&apos;</xsl:variable>
 
	<xsl:variable name="processNameList">
		<xsl:if test="$p_details != 0">		
			<xsl:value-of 
			  select="string-join(for $tmp in $file/process_names/process_name[@processLevel=$p_details] return concat($apos,$tmp/@name,$apos), ',')" />
		</xsl:if>		
	</xsl:variable>
	
	<xsl:variable name="sub_query_details">
		<xsl:if test="string-length($processNameList) gt 0">
			AND pl.process_name IN (<xsl:value-of select="$processNameList"/>)
		</xsl:if>
	</xsl:variable>

 <xsl:template match="/">
  <root>
     <sql:execute-query>
      <sql:query name="qry_dashboard_run_id">
		SELECT distinct pl.run_schedule as run_schedule
			FROM pcu_process_logging pl
			WHERE to_date('<xsl:value-of select="$p_date"/>','YYYYMMDD') = TRUNC(pl.ts_start)
			   AND pl.modus = '<xsl:value-of select="$p_runmode"/>'
			   <xsl:if test="$p_runmode != 'MANUAL' ">
					AND rownum = 1
			   </xsl:if>			   
      </sql:query>
        <sql:execute-query>
            <sql:query name="qry_dashboard_main">
			    SELECT pl.ts_start      AS sort_order 
					, '<sql:ancestor-value name="run_schedule" level="1"/>' as run_schedule 
					, pl.process_name  AS process_name
					, to_char(pl.ts_start,'YYYY-MM-DD HH24:MI:SS')      AS start_time
					, to_char(pl.ts_end,'YYYY-MM-DD HH24:MI:SS')        AS end_time
					, pl.object_count_in   AS volume_in
					, pl.object_count_out  AS volume_out
					, to_char(ROUND(pl.secs_runtime/60,0),'9990') AS runtime_minutes
					, (CASE  
						WHEN pl.object_count_out = 0 AND pl.secs_runtime != 0 THEN '0' 
						WHEN pl.object_count_out = 0 AND pl.secs_runtime  = 0 THEN '0' 
						ELSE to_char(ROUND(pl.secs_runtime/pl.object_count_out,1),'9990.0')
					   END ) AS seconds_per_object
               , <xsl:value-of select="$p_period"/> as period
				FROM pcu_process_logging pl
				WHERE pl.run_schedule  = RTRIM('<sql:ancestor-value name="run_schedule" level="1"/>') 
				    <xsl:copy-of select="$sub_query_details" />
					AND pl.modus = '<xsl:value-of select="$p_runmode"/>'
				ORDER BY 1 ASC
            </sql:query>
       </sql:execute-query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>
