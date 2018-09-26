<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param2">en_UK</xsl:param>
  <xsl:param name="id">HQ1212/23</xsl:param>
  <xsl:param name="param1">raw</xsl:param>
  <xsl:variable name="db" select="substring($param1,1,3)"/>
  <xsl:variable name="type" select="substring-after($param1,'_')"/>
  <xsl:variable name="locale" select="$param2"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:attribute name="locale"><xsl:value-of select="$locale"/></xsl:attribute>
      <xsl:attribute name="ctn"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
      <xsl:attribute name="db"><xsl:value-of select="$db"/></xsl:attribute>
      <!-- -->
      <xsl:choose>
        <xsl:when test="upper-case($locale)='MASTER'">
          <xsl:choose>
            <xsl:when test="$db='raw'">
              <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                <sql:query>
select DATA
from RAW_MASTER_PRODUCTS
where CTN='<xsl:value-of select="$id"/>' and DATA_TYPE='<xsl:value-of select="$type"/>'
      </sql:query>
              </sql:execute-query>
            </xsl:when>
            <xsl:otherwise>
              <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                <sql:query>
select DATA
from MASTER_PRODUCTS
where ID='<xsl:value-of select="$id"/>'
      </sql:query>
              </sql:execute-query>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$db='raw'">
              <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                <sql:query>
select DATA
from RAW_LOCALIZED_PRODUCTS
where LOCALE='<xsl:value-of select="$locale"/>' and ID='<xsl:value-of select="$id"/>'
      </sql:query>
              </sql:execute-query>
            </xsl:when>
            <xsl:when test="$db='tri'">
              <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                <sql:query>
select DATA
from TRIGO_LOCALIZED_PRODUCTS
where LOCALE='<xsl:value-of select="$locale"/>' and ID='<xsl:value-of select="$id"/>'
      </sql:query>
              </sql:execute-query>
            </xsl:when>
            <xsl:otherwise>
              <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
                <sql:query>
select DATA
from LOCALIZED_PRODUCTS
where LOCALE='<xsl:value-of select="$locale"/>' and ID='<xsl:value-of select="$id"/>'
      </sql:query>
              </sql:execute-query>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>
