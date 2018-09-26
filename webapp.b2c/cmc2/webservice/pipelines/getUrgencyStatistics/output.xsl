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
  <xsl:import href="../em-functions.xsl"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="userID" select="''"/>
  <xsl:param name="authorizationRestriction" select="''"/>
  <xsl:param name="columnSelection" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="/root/sql:rowset">
    <xsl:element name="UrgencyStatisticsRoot">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_urgencyStatistics_EMP v1.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="authorizationRestriction" select="$authorizationRestriction"/>
          <xsl:with-param name="ctnRestriction" select="$ctnRestriction"/>
          <xsl:with-param name="columnSelection" select="$columnSelection"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="Columns">
        <xsl:for-each-group select="sql:row" group-by="sql:col"> 
          <xsl:element name="Column">
            <xsl:attribute name="columnID" select="current-grouping-key()"/>
            
            <xsl:for-each select="current-group()">
              <xsl:element name="Count">
                <xsl:attribute name="Urgency" select="sql:colour"/>
                
                <xsl:value-of select="sql:total"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each-group>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="authorizationRestriction" select="''"/>
    <xsl:param name="ctnRestriction" select="''"/>
    <xsl:param name="columnSelection" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="authorizationRestriction">
      <xsl:value-of select="$authorizationRestriction"/>
    </xsl:element>
    <xsl:element name="ctnRestriction">
      <xsl:for-each select="tokenize($ctnRestriction, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="columnSelection">
      <xsl:for-each select="tokenize($columnSelection, ',')">
        <xsl:element name="column">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
