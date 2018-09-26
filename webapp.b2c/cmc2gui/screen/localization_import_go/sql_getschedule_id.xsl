<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="schedule_id">
select * from content_type_schedule where not(description like 'FL%') order by id
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
