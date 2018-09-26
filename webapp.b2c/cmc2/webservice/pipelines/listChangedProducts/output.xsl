<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="../em-functions.xsl"/>
            
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="userID" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="since" select="''"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="root">
    <xsl:element name="Products">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="DocType" select="'ListOverview'"/>
      <xsl:attribute name="DocVersion" select="'v1'"/>
      <xsl:attribute name="NrOfProductsInThisResult" select="count(distinct-values(products/sql:rowset/sql:row/sql:ctn))"/>
      <xsl:attribute name="NrOfProductsTotal" select="count(distinct-values(products/sql:rowset/sql:row/sql:ctn))"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="'xUCDM_listChangedProducts_v1_WIP.xsd'"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="ctnRestriction" select="$ctnRestriction"/>
          <xsl:with-param name="since" select="$since"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:for-each select="products/sql:rowset/sql:row">
        <xsl:element name="Product">
          <xsl:attribute name="CTN" select="sql:ctn"/>
          <xsl:attribute name="lastModified" select="em:formatDate(sql:lastmodifieddate)"/>
	    </xsl:element>
	  </xsl:for-each>  
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="ctnRestriction" select="''"/>
    <xsl:param name="since" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="ctnRestriction">
      <xsl:value-of select="$ctnRestriction"/>
    </xsl:element>
    <xsl:element name="since">
      <xsl:value-of select="$since"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>