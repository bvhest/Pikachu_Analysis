<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="channel"/>
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
            select distinct  cc.locale languagecode
                 , to_char(c.startexec,'YYYYMMDD"T"HH24MISS') exporttimestamp
                 , cc.priority_group
              from channels c
        inner join channel_catalogs cc
                on c.id = cc.customer_id
               and c.name = '<xsl:value-of select="$channel"/>'
               and cc.enabled = 1
               and cc.product_type = 'CATEGORYTREE'    
            -- where cc.locale  in ('en_AU')
          order by cc.priority_group, cc.locale
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>