<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="runId"/>
  <xsl:param name="runMode"/>
  
  <xsl:template match="/">
    <root>
      <xsl:if test="$runId != ''">
        <xsl:variable name="cur-time" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]')" />
        <xsl:variable name="modus" select="if ($runMode != '') then $runMode else 'BATCH'" />
        
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query>
            insert into pcu_process_logging (
                PROCESS_NAME
              , TS_START
              , DAY_OF_WEEK
              , PROCESS_TYPE
              , MODUS
              , RUN_SCHEDULE)
            values (
                'Start run'
              , to_date('<xsl:value-of select="$cur-time" />', 'yyyy-mm-dd hh24:mi:ss')
              , to_char(to_date('<xsl:value-of select="$cur-time" />', 'yyyy-mm-dd hh24:mi:ss'), 'DAY')
              , '<xsl:value-of select="$modus" />'
              , '<xsl:value-of select="$runId" />'
            )
          </sql:query>
        </sql:execute-query>
      </xsl:if>
    </root>
  </xsl:template>
    
</xsl:stylesheet>
