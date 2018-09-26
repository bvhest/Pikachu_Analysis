<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                >
  
  <xsl:param name="userID"/>
                
  <xsl:import href="../service-base.xsl"/>
  
  <xsl:template match="/root">
    <xsl:choose>
      <!-- Requested profile is for authenticated user; already retrieved in service-base.xsl -->
      <xsl:when test="$userID = '' or $__auth_user = $userID">
        <xsl:apply-templates select="$uap"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="t-uap" select="svc:get-user-profile($userID)"/>
        <xsl:choose>
          <xsl:when test="exists($t-uap)">
            <xsl:apply-templates select="$t-uap"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="svc:get-error(404)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="AuthorisationProfile">
    <xsl:apply-templates select="." mode="transfer-ns"/>
  </xsl:template>
  
  <xsl:template match="*[namespace-uri()='']" mode="transfer-ns">
    <xsl:element name="tns:{local-name()}" namespace="http://pww.cmc.philips.com/CMCService/types/1.0">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" mode="transfer-ns"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
