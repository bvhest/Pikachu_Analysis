<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>

  <xsl:template match="/">
    <root>  
      <sql:execute-query>
        <sql:query>
          select distinct 
                 ch.startexec, cc.locale
               , case 
                   when masterlocaleenabled=1 then 
                     'en_'||substr(cc.locale, 4) 
                 end as masterlocale
               , cc.priority_group
          from channels ch
          inner join channel_catalogs cc
             on cc.customer_id=ch.id
          where name = '<xsl:value-of select="$channel"/>'
            and enabled=1 and localeenabled=1
          order by cc.priority_group, cc.locale
        </sql:query>    
      </sql:execute-query>    
    </root>
  </xsl:template>
</xsl:stylesheet>