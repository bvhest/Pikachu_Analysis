<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:template match="/">
    <entries ct="PMT" ts="{$ts}">
      <entry includeinreport='yes'>
        <sql:execute-query>
          <sql:query name="select">
select to_char(sysdate,'YYYYMMDDHH24MISS') end, count(*) count 
from octl 
where content_type = 'PMT' 
and status != 'PLACEHOLDER' 
and lastmodified_ts = to_date('<xsl:value-of select="$ts"/>','YYYYMMDDHH24MISS')
          </sql:query>
        </sql:execute-query>
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>