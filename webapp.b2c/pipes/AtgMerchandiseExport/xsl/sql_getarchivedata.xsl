<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="channel" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates />
      <sql:execute-query>
        <sql:query name="get-channel-data">
          select distinct ch.startexec, cc.priority_group
          from channels ch
          inner join channel_catalogs cc
             on cc.customer_id=ch.id
          where ch.name = '<xsl:value-of select="$channel" />'
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>