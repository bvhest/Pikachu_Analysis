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
  <xsl:param name="scopeRestriction" select="''"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>  
  
  <xsl:template match="Categorization">
    <xsl:element name="CategorizationRoot">
      <xsl:attribute name="DocTimeStamp" select="@DocTimeStamp"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <!-- xsl:attribute name="DocType" select="''"/-->
      <xsl:attribute name="DocVersion" select="'v1'"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_category_EMP v1.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="scopeRestriction" select="$scopeRestriction"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="Categorization">
        <xsl:attribute name="lastModified" select="em:formatDate(current-dateTime())"/>
        
        <xsl:for-each select="Catalog/FixedCategorization/Group"> 
          <xsl:call-template name="Group"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="Category">
    <xsl:element name="Category">
      <xsl:attribute name="code" select="CategoryCode"/>
      <xsl:attribute name="referenceName" select="CategoryReferenceName"/>
      <xsl:attribute name="seq" select="CategoryRank"/>
      
      <xsl:element name="Name">
        <xsl:value-of select="CategoryName"/>
      </xsl:element>
      
      <xsl:for-each select="L3/L4/L5/L6/SubCategory"> 
        <xsl:call-template name="SubCategory"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="Group">
    <xsl:element name="Group">
      <xsl:attribute name="code" select="GroupCode"/>
      <xsl:attribute name="referenceName" select="GroupReferenceName"/>
      <xsl:attribute name="seq" select="GroupRank"/>
      
      <xsl:element name="Name">
        <xsl:value-of select="GroupName"/>
      </xsl:element>
      
      <xsl:for-each select="Category">
        <xsl:call-template name="Category"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="SubCategory">
    <xsl:element name="SubCategory">
      <xsl:attribute name="code" select="SubCategoryCode"/>
      <xsl:attribute name="referenceName" select="SubCategoryReferenceName"/>
      <xsl:attribute name="seq" select="SubCategoryRank"/>
      
      <xsl:element name="Name">
        <xsl:value-of select="SubCategoryName"/>
      </xsl:element>
      
      <xsl:for-each select="sql:rowset/sql:row"> 
        <xsl:element name="CTN">
          <xsl:attribute name="code" select="current()/sql:object_id"/>
          <xsl:attribute name="name" select="current()/sql:namingstringshort"/>
          <xsl:attribute name="deleted" select="current()/sql:deleted"/>
          <xsl:attribute name="lastmodified" select="current()/sql:lastmodified"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="scopeRestriction" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="scopeRestriction">
      <xsl:value-of select="$scopeRestriction"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
