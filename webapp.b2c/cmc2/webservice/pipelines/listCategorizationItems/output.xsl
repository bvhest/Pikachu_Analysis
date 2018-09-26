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
  <xsl:param name="categoryCode" select="''"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="/root/sql:rowset">
    <xsl:element name="CategorizationItemsRoot">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_categorizationItems_EMP v1.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="categoryCode" select="$categoryCode"/>
        </xsl:call-template>
      </xsl:element>
       
      <xsl:for-each select="sql:row"> 
        <xsl:element name="ctn">
          <xsl:value-of select="sql:object_id"/>
        </xsl:element>
      </xsl:for-each>
      
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="categoryCode" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="categoryCode">
      <xsl:value-of select="$categoryCode"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
