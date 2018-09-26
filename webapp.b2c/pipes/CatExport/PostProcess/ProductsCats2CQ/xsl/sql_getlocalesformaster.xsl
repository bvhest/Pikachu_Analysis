<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>

  <!-- Get the active locales that have masterlocaleenabled = 1 for the specified channel -->
  <xsl:template match="/">
    <masterlocales>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
            select cc.locale, wm_concat(cc.catalog_type) catalog_types
              from channels c

            inner join channel_catalogs cc
               on c.id = cc.customer_id
            
            where c.name = '<xsl:value-of select="$channel"/>'
              and cc.enabled = 1
              and cc.product_type = 'CATEGORYTREE'
              and cc.enabled = 1
              and cc.masterlocaleenabled = 1
            
            group by cc.locale
        </sql:query>
      </sql:execute-query>
    </masterlocales>
  </xsl:template>
</xsl:stylesheet>