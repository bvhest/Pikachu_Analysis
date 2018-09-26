<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel">test</xsl:param>

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0"> 
    	  <sql:query name="locales">
		<!-- Retrieve all locales that are exportable for this channel. Join to ATG_CATALOGS to filter out invalid combinations of CATALOG and LOCALE -->
		select distinct CC.LOCALE
      from CHANNEL_CATALOGS CC 
	   inner join CHANNELS C 
			  on CC.CUSTOMER_ID = C.ID 
	   where C.NAME = '<xsl:value-of select="$channel"/>' and cc.ENABLED = 1 
		<!--and ce.locale in ('en_GB') -->
		order by CC.LOCALE               
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