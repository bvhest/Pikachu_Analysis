<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="ts"/>
  <xsl:param name="catalog-id"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="update-last-transmit">
          update customer_locale_export
             set lasttransmit = to_date('<xsl:value-of select="$ts"/>','YYYYMMDDHH24MISS')
           where customer_id = '<xsl:value-of select="$channel"/>'
             and ctn = '<xsl:value-of select="$catalog-id"/>'
             and flag > 0
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>