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
          select distinct cc.LOCALE
            from CHANNEL_CATALOGS cc
      inner join CHANNELS c 
              on c.id = cc.customer_id
           where c.Name = '<xsl:value-of select="$channel"/>'
             and cc.ENABLED = 1 
             and (cc.localeenabled = 1 or cc.masterlocaleenabled = 1)
--and cc.locale in ('nl_NL', 'de_DE', 'en_GB')
        order by cc.LOCALE      
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
