<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="/h:request/h:requestParameters">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:attribute name="name"><xsl:value-of select="h:parameter[@name='Channel']/h:value"/>_<xsl:value-of select="h:parameter[@name='Search']/h:value"/></xsl:attribute>
update CUSTOMER_LOCALE_EXPORT
set lasttransmit=null
where CUSTOMER_ID='<xsl:value-of select="h:parameter[@name='Channel']/h:value"/>'
and CTN = '<xsl:value-of select="upper-case(h:parameter[@name='Search']/h:value)"/>'
	      </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
