<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="ct"/>

  <xsl:template match="/">
  <root>
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0"> 
      <sql:query name="locales">
		
        select ct, locale, priority_group, exportmasterlocale
          from 
              ( select distinct '<xsl:value-of select="$ct"/>' ct, ll.locale , cc.priority_group, max(cc.masterlocaleenabled) as exportmasterlocale
                from locale_language  ll 
                inner join channel_catalogs cc
                   on ll.locale = cc.locale
                inner join channels c 
                   on cc.customer_id = c.id 
                where c.name = '<xsl:value-of select="$channel"/>'
                  and cc.enabled = 1
                group by '<xsl:value-of select="$ct"/>', ll.locale, cc.priority_group
              union
                select '<xsl:value-of select="concat($ct,'_Master')"/>' ct,'master_global' locale, cc.priority_group, 0 as exportmasterlocale
                from channel_catalogs cc
                inner join channels c 
                   on cc.customer_id = c.id 
                where c.name = '<xsl:value-of select="$channel"/>'
                  and cc.enabled = 1
                  and cc.locale = 'master_global'
              )      
        order by ct, priority_group, locale  
      </sql:query>
    </sql:execute-query>
    
    <sql:execute-query>
	  <sql:query name="timestamp">
		select startexec from channels where name = '<xsl:value-of select="$channel"/>'
	  </sql:query>	  
    </sql:execute-query>
    
  </root>
  </xsl:template>
</xsl:stylesheet>