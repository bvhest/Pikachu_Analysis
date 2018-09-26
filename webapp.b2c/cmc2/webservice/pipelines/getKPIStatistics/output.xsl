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
                xmlns:pf="http://tempuri.org/"
                >
  <xsl:import href="../em-functions.xsl"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="/root">
    <xsl:element name="KPIStatisticsRoot">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_KPIStatistics_EMP v1.xsd'"/>
      
      <xsl:element name="Users">
        <xsl:for-each select="owners/UrgencyStatisticsRoot">
          <xsl:variable name="userID" select="CallParameters/userID"/>
         
          <xsl:element name="User">
            <xsl:attribute name="id" select="$userID"/>
            <xsl:attribute name="green" select="Columns/Column/Count[@Urgency='Green']"/>
            <xsl:attribute name="grey" select="Columns/Column/Count[@Urgency='Grey']"/>
            <xsl:attribute name="orange" select="Columns/Column/Count[@Urgency='Orange']"/>
            <xsl:attribute name="red" select="Columns/Column/Count[@Urgency='Red']"/>
            <xsl:attribute name="login-count" select="/root/owners/LoginCount[@userID=$userID]/@count"/>
            <xsl:attribute name="name" select="/root/owners/User[@userID=$userID]/pf:GetDetailsResult/pf:FullName"/>
            <xsl:attribute name="status" select="/root/owners/User[@userID=$userID]/@status"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      
      <xsl:element name="Products">
        <xsl:for-each-group select="products/Product" group-by="@ctn">
          <xsl:variable name="globallive" select="if (current-group()[@globallive != '']) then (current-group()/@globallive[string() != ''])[1] else ''"/>
          <xsl:element name="Product">
            <xsl:apply-templates select="@ctn|@owner|@marketingclass|@cr_date"/>
            <xsl:apply-templates select="@magcode|@pmtversion|@modified|@categorycode"/>
            <xsl:attribute name="globallive" select="$globallive"/>
            
            <xsl:for-each select="current-group()">
              <xsl:element name="ContentStatus">
                <xsl:attribute name="columnID" select="@columnid"/>
                <xsl:attribute name="rank" select="@rank"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each-group>
        
        <!-- 
        <xsl:apply-templates select="products/Product"/>
         -->
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Product">
    <xsl:element name="Product">
      <xsl:apply-templates select="@ctn|@owner|@marketingclass|@cr_date"/>
      <!-- <xsl:attribute name="name" select="/root/owners/User[@userID=current()/@owner]/pf:GetDetailsResult/pf:FullName"/> -->
      <xsl:apply-templates select="@modified|@categorycode"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
  </xsl:template>
  
</xsl:stylesheet>
