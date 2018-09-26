<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

  <xsl:param name="ct" /> 
 
  <xsl:template match="/">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
select to_char(NVL(endexec, sysdate-365), 'yyyy-mm-dd hh24:mi:ss') as lastrun_ts
  from content_type_schedule
 where content_type = '<xsl:value-of select="$ct"/>'
        </sql:query>
      </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>