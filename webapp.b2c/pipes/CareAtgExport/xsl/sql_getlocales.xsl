<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel">test</xsl:param>
  <xsl:param name="delta"/>
  
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0"> 
    	  <sql:query name="locales">
		<!-- Retrieve all locales that are exportable for this channel. Join to ATG_CATALOGS to filter out invalid combinations of CATALOG and LOCALE  -->
		select ct, locale 
        from  
        ( 
          select distinct 'PCT' ct, ll.locale 
            from locale_language  ll 
          inner join channel_catalogs cc
             on ll.locale = cc.locale
          inner join channels c 
             on cc.customer_id = c.id 
          where c.name = '<xsl:value-of select="$channel"/>'
            and cc.enabled = 1    
		
          union

          select 'PCT_Master' ct,'master_global' locale 
          from dual
        )
		order by ct , LOCALE  
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