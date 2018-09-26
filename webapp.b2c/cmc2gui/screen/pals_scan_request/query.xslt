<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query name="locale">
          select distinct ll.locale
          from locale_language ll
          order by locale
        </sql:query>
      </sql:execute-query>
      <!-- -->
      <sql:execute-query>
        <sql:query name="ct">
          select distinct content_type
          from content_types
          where content_type like '%Translated'
          order by content_type
        </sql:query>
      </sql:execute-query>    
    </root>
  </xsl:template>
</xsl:stylesheet>