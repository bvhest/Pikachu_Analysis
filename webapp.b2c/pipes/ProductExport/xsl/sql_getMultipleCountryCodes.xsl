<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:ws="http://apache.org/cocoon/source/1.0">

	<xsl:template match="/">      
      <sql:execute-query>
        <sql:query>
          select country_code from locale_language group by (country_code) having count(country_code) > 1  
        </sql:query>
      </sql:execute-query>
    </xsl:template>
</xsl:stylesheet>