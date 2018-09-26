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
  <xsl:param name="ctn" select="''"/>
  
  <xsl:template match="/">
    <xsl:element name="parameters">
      <xsl:element name="__auth_user">
        <xsl:value-of select="$__auth_user"/>
      </xsl:element>
      <xsl:element name="userID">
        <xsl:value-of select="$userID"/>
      </xsl:element>
      <xsl:element name="ctn">
        <xsl:value-of select="$ctn"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  </xsl:stylesheet>
