<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="table"/>
  <xsl:param name="owner"/>
  
  <xsl:template match="/root">
      <sql:execute-query>
        <sql:query>
          select column_name from all_tab_columns
          where table_name='<xsl:value-of select="$table"/>'
          order by column_id
        </sql:query>
      </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>