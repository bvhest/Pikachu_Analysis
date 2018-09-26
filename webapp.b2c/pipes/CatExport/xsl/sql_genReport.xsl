<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:param name="channel"/>
	<!-- -->
	<xsl:template match="/">
  	<batch>
  		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  			<sql:query>
                  select cle.CTN,
                  	     cle.LOCALE,
                  	     1 as result,
                  	    'Exported' as remark,
                         to_char(c.startexec,'YYYYMMDD"T"HH24MISS') exporttimestamp
                    from channels c 
         left outer join CUSTOMER_LOCALE_EXPORT cle 
                      on cle.customer_id = c.name
                     and cle.lasttransmit = c.startexec
                   where c.name = '<xsl:value-of select="$channel"/>'                 	 
                order by cle.ctn, cle.locale
  			</sql:query>
  		</sql:execute-query>
  	</batch>
  </xsl:template>
</xsl:stylesheet>