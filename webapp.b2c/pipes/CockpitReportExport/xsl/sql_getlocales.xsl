<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0" name="locales">
      	 <sql:query name="locales">
    select distinct cc.locale
      from channel_catalogs cc
inner join channels c 
        on c.id       = cc.customer_id
     where c.name     = '<xsl:value-of select="$channel"/>'
       and cc.enabled = 1
  order by cc.locale      
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>