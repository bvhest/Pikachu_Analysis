<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="batchtype"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="locales">
          select distinct cc.locale 
			   from channels c 
           inner join  channel_catalogs cc
              on cc.customer_id = c.id
              and  cc.enabled = 1
           where c.name = '<xsl:value-of select="$channel"/>/delta'
--           and cc.locale in ('en_GB', 'nl_NL', 'de_DE') 
          order by cc.locale
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="timestamp">
          select startexec from channels where name = '<xsl:value-of select="concat($channel,'/',$batchtype)"/>'
        </sql:query>    
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
