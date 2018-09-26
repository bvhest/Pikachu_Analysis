<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="delta"/>

  <xsl:template match="/">
  <root>
  
   	  <sql:execute-query>
		<sql:query name="timestamp">
		<xsl:choose>
			<xsl:when test="$delta='y'">select startexec from channels where name = '<xsl:value-of select="$channel"/>'</xsl:when>
			<xsl:otherwise>select startexec from channels where name = '<xsl:value-of select="$channel"/>FullExtract'</xsl:otherwise>
		</xsl:choose>
		</sql:query>	  
      </sql:execute-query>

   	  <sql:execute-query>
		<sql:query name="maxbatch">
			select max(batch) as maxbatch from customer_locale_export where customer_id = '<xsl:value-of select="$channel"/>'
		</sql:query>	  
      </sql:execute-query>

	  
  </root>
  </xsl:template>
</xsl:stylesheet>