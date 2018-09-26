<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="channel"/>
      
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="select-batches">
           select distinct batch from customer_locale_export
           where customer_id='<xsl:value-of select="$channel"/>'
           and batch > 0
           order by batch
         </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>