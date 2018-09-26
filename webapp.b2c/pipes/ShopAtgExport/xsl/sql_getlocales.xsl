<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="delta"/>
  
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0"> 
        <sql:query name="locales">
          select distinct ll.locale, ll.islatin
            from locale_language  ll 
      inner join channel_catalogs cc
              on ll.locale = cc.locale
      inner join channels c 
              on cc.customer_id = c.id 
           where c.name = '<xsl:value-of select="$channel"/>'
             and cc.enabled = 1
--and ll.locale in ('nl_BE','fr_BE','en_GB','nl_NL')
        order by locale                   
      </sql:query>
    </sql:execute-query>
    
        <sql:execute-query>
    <sql:query name="timestamp">
    <xsl:choose>
      <xsl:when test="$delta='y'">select startexec from channels where name = '<xsl:value-of select="$channel"/>'</xsl:when>
      <xsl:otherwise>select startexec from channels where name = '<xsl:value-of select="$channel"/>FullExtract'</xsl:otherwise>
    </xsl:choose>
    </sql:query>    
      </sql:execute-query>
    
  </root>
  </xsl:template>
</xsl:stylesheet>