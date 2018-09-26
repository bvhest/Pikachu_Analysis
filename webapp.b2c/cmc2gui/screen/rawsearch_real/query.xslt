<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="/h:request/h:requestParameters">
    <root>
      <xsl:choose>
        <xsl:when test="lower-case(h:parameter[@name='Locale']/h:value) = 'master'">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="master">
select mp.ID, 'master' as locale 
from master_products mp
where DATA like '%<xsl:value-of select="h:parameter[@name='Search']/h:value"/>%'
and rownum &lt; 200
order by mp.ID</sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:otherwise>
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="locale">
select lp.ID, lp.locale 
from LOCALIZED_PRODUCTS lp
where 
	DATA like '%<xsl:value-of select="h:parameter[@name='Search']/h:value"/>%'
	and lp.locale = '<xsl:value-of select="h:parameter[@name='Locale']/h:value"/>'
and rownum &lt; 200
order by lp.ID</sql:query>
          </sql:execute-query>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
