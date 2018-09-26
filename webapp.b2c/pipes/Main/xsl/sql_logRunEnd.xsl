<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="runId"/>
  <xsl:param name="runMode"/>
  
  <xsl:template match="/">
    <root>
      <xsl:if test="$runId != ''">
        <xsl:variable name="cur-time" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]')" />
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query>
            update pcu_process_logging set TS_END = to_date('<xsl:value-of select="$cur-time" />', 'yyyy-mm-dd hh24:mi:ss')
            where RUN_SCHEDULE = '<xsl:value-of select="$runId" />'
          </sql:query>
        </sql:execute-query>
      </xsl:if>
    </root>
  </xsl:template>
    
</xsl:stylesheet>
