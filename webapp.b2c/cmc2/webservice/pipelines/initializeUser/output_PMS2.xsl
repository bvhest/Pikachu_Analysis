<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:my="http://pww.cmc.philips.com/local-functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >
  <xsl:import href="output.xsl"/>
  
  <xsl:param name="sessionID"/>
  
  <xsl:template match="/">
    <xsl:element name="InitializeUserRoot">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_initializeUser_EMP v1.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="sessionID" select="$sessionID"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="Result">
        <xsl:value-of select="'true'"/>
      </xsl:element>
      
      <xsl:element name="SessionID">
        <xsl:value-of select="$sessionID"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="sessionID" select="''"/>
    
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    
    <xsl:element name="sessionID">
      <xsl:value-of select="$sessionID"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
