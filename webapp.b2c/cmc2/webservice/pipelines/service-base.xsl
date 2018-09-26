<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                >

  <xsl:import href="service-functions.xsl"/>
  
  <xsl:param name="userID" select="'anonymous'"/>
  <!-- __noauth=1 will skip authentication to avoid overhead for internal calls -->
  <xsl:param name="__noauth"/>
  
  <xsl:variable name="uap" select="if ($__noauth) then () else svc:get-active-user-profile(upper-case($userID))"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$__noauth or $uap">
        <xsl:apply-templates select="*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="svc:get-error(401)"/>
        <xsl:copy-of select="fn:error(fn:QName('http://pww.cmc.philips.com/CMCService/errors/1.0', 'err:unauthorized'), 'You are not authorized for this operation')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="/root">
    <xsl:choose>
      <xsl:when test="octl/sql:rowset/node()">
        <xsl:apply-templates select="octl/sql:rowset"/>
      </xsl:when>
      <xsl:when test="sql:rowset/node()">
        <xsl:apply-templates select="sql:rowset"/>
      </xsl:when>
      <xsl:when test="error">
        <xsl:apply-templates select="error"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="svc:get-error(404)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

