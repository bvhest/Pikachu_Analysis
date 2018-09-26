<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="p_run_schedule"/>
  <xsl:param name="p_output_content_type"/>
 
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="qry_dashboard_details">
-- sub query, showing the input content types:
SELECT pl.ts_start      AS sort_order
     , '<xsl:value-of select="$p_run_schedule"/>' as run_schedule -- hidden column
     , pl.process_name  AS process_name
     , to_char(pl.ts_start,'YYYY-MM-DD HH24:MI:SS')      AS start_time
     , to_char(pl.ts_end,'YYYY-MM-DD HH24:MI:SS')        AS end_time
     , pl.object_count_in  AS volume_in
     , pl.object_count_out AS volume_out
     , to_char(ROUND(pl.secs_runtime/60,0),'9990') AS runtime_minutes
     , (CASE  
         WHEN pl.object_count_out = 0 AND pl.secs_runtime != 0 THEN '0' 
         WHEN pl.object_count_out = 0 AND pl.secs_runtime  = 0 THEN '0' 
         ELSE to_char(ROUND(pl.secs_runtime/pl.object_count_out,1),'9990.0')
        END ) AS seconds_per_object
  FROM pcu_process_logging pl
 WHERE pl.run_schedule  = '<xsl:value-of select="$p_run_schedule"/>' -- param1
   AND pl.process_name IN (SELECT DISTINCT input_content_type FROM ctl_relations WHERE output_content_type = '<xsl:value-of select="$p_output_content_type"/>')  -- param2
   AND pl.modus         = 'BATCH'
   AND pl.ts_end       != TO_DATE('19000101','YYYYMMDD') -- don't select processes that did not finish
 ORDER BY 1 ASC
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>
