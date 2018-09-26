<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>

  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query>
          select distinct cc.locale, cc.catalog_type
            from channel_catalogs cc
      inner join channels c 
              on c.id = cc.customer_id
           where c.name = '<xsl:value-of select="$channel"/>'
             and cc.enabled = 1 
             and cc.localeenabled = 1
        order by cc.locale      
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
