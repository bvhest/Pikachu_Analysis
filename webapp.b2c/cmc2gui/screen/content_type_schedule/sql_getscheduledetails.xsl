<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:param name="schedule_id"/>
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
SELECT   ID, CONTENT_TYPE, PIPELINE
FROM content_type_schedule 
WHERE ID = '<xsl:value-of select="$schedule_id"/>'
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>