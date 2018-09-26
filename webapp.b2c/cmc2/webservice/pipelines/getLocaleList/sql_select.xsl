<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:template match="/root">
    <root>
      <sql:execute-query name="getLocaleList">
        <sql:query>
            select locale from locale_language order by locale     
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
