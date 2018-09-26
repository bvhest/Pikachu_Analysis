<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="timestamp"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="update-last-transmit">
          update customer_locale_export
             set lasttransmit = to_date('<xsl:value-of select="$timestamp"/>','YYYYMMDDHH24MISS')
               , flag=0
           where customer_id = '<xsl:value-of select="$channel"/>'
             and flag > 0
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>

</xsl:stylesheet>