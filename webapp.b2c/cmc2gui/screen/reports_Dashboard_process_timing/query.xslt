<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="p_output_content_type"/>
  <xsl:param name="p_end_date"/>
  <xsl:param name="p_period"/>
 
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="Process Timing">
-- time-averaged run time per content type
select pl.process_name
     , pl.day_of_week
     , to_char(pl.start_time,'DDD') AS day_of_year
     , to_char(pl.start_time,'YYYY-MM-DD HH24:MI:SS') AS start_time
     , to_char(pl.end_time,'YYYY-MM-DD HH24:MI:SS') AS end_time
     , pl.runtime_minutes
	 , pl.object_count_out
     , ROUND( AVG(pl.runtime_minutes)
                OVER (PARTITION BY pl.process_name 
                      ORDER BY pl.start_time 
                      RANGE INTERVAL '7' DAY PRECEDING
                     ) 
              , 0) AS moving_7day_average
     , apt.max_bound_minutes
     , apt.min_bound_minutes
     , ROUND( AVG(pl.runtime_minutes)
                OVER (PARTITION BY pl.process_name 
                      ORDER BY pl.start_time 
                      RANGE INTERVAL '28' DAY PRECEDING
                     ) 
              , 0)                                    AS avg_runtime_minutes
     , ROUND(pl.object_count_out/pl.runtime_minutes, 1) as objects_per_minute
FROM 
(
SELECT pl1.ts_start      AS sort_order
     , pl1.process_name
     , pl1.day_of_week
     , pl1.ts_start      AS start_time
     , pl1.ts_end        AS end_time
     , -1                AS volume_in
     , pl1.object_count_out  AS volume_out
     , ROUND((2+pl1.secs_runtime)/60,1) AS runtime_minutes
     , pl1.object_count_out
     , (CASE  
         WHEN pl1.object_count_out = 0 AND pl1.secs_runtime != 0 THEN '0' 
         WHEN pl1.object_count_out = 0 AND pl1.secs_runtime  = 0 THEN '0' 
         ELSE to_char(ROUND(pl1.secs_runtime/pl1.object_count_out,1),'9990.0')
        END ) AS seconds_per_object
  FROM pcu_process_logging pl1
 WHERE pl1.process_name  = '<xsl:value-of select="$p_output_content_type"/>' -- param
   AND pl1.modus         = 'BATCH'
   AND pl1.ts_start BETWEEN TO_DATE('<xsl:value-of select="$p_end_date"/>', 'YYYY-MM-DD HH24:MI:SS')-<xsl:value-of select="$p_period"/> AND TO_DATE('<xsl:value-of select="$p_end_date"/>', 'YYYY-MM-DD HH24:MI:SS') 
   AND pl1.ts_end       != TO_DATE('19000101','YYYYMMDD') -- don't select processes that did not finish
) pl
 INNER JOIN pcu_avg_process_times apt
    ON apt.process_name = pl.process_name
ORDER BY pl.start_time DESC
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>
