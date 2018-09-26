<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:dir="http://apache.org/cocoon/directory/2.0" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="runmode" select="''"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query name="sql_setNeedsProcessingFlags: merge octl_control">
            MERGE INTO octl_control t
            USING (select distinct 
                          'catalog_log'   as content_type
                        , 'none'          as localisation
                        , catalog_id      as object_id
                     from catalog_objects
                    where needsprocessing_flag in (-2,-3)
                  ) s
              ON (t.modus = '<xsl:value-of select="$modus"/>' AND t.content_type = s.content_type AND t.localisation = s.localisation and t.object_id = s.object_id)
            WHEN NOT MATCHED THEN INSERT 
                  (modus, content_type, localisation, object_id, needsprocessing_ts, needsprocessing_flag, intransaction_flag, batch_number)
               VALUES
                  ('<xsl:value-of select="$modus"/>', s.content_type, s.localisation, s.object_id, sysdate, 1, 0, NULL)
            WHEN MATCHED THEN UPDATE
               SET t.needsprocessing_ts   = sysdate
                 , t.needsprocessing_flag = 1
                 , t.intransaction_flag   = 0
                 , t.batch_number         = NULL
               WHERE t.modus              = '<xsl:value-of select="$modus"/>'
                 AND t.needsprocessing_flag != 1
        </sql:query>
      </sql:execute-query>
      
      <sql:execute-query>
        <sql:query name="sql_setNeedsProcessingFlags: update catalog_objects">
            UPDATE catalog_objects 
               SET needsprocessing_flag = -needsprocessing_flag
             WHERE needsprocessing_flag in (-2,-3)
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>