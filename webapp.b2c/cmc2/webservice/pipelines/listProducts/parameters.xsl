<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="__auth_user" select="'anonymous'"/>
  <xsl:param name="userID" select="''"/>
  <xsl:param name="authorizationRestriction" select="''"/>
  <xsl:param name="catalogTypeRestriction" select="''"/>
  <xsl:param name="productCatRestriction" select="''"/>
  <xsl:param name="requiringAttentionRestriction" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="query" select="''"/>
  <xsl:param name="sortBy" select="''"/>
  <xsl:param name="recordFrom" select="'0'"/>
  <xsl:param name="maxResults" select="'20'"/>
  
  <xsl:template match="/">
    <xsl:element name="parameters">
      <xsl:element name="__auth_user">
        <xsl:value-of select="$__auth_user"/>
      </xsl:element>
      <xsl:element name="userID">
        <xsl:value-of select="$userID"/>
      </xsl:element>
      <xsl:element name="authorizationRestriction">
        <xsl:value-of select="$authorizationRestriction"/>
      </xsl:element>
      <xsl:element name="productCatRestriction">
        <xsl:value-of select="$productCatRestriction"/>
      </xsl:element>
      <xsl:element name="requiringAttentionRestriction">
        <xsl:value-of select="$requiringAttentionRestriction"/>
      </xsl:element>
      <xsl:element name="ctnRestriction">
        <xsl:value-of select="$ctnRestriction"/>
      </xsl:element>
      <xsl:element name="query">
        <xsl:value-of select="$query"/>
      </xsl:element>
      <xsl:element name="sortBy">
        <xsl:value-of select="$sortBy"/>
      </xsl:element>
      <xsl:element name="recordFrom">
        <xsl:value-of select="$recordFrom"/>
      </xsl:element>
      <xsl:element name="maxResults">
        <xsl:value-of select="$maxResults"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  </xsl:stylesheet>
