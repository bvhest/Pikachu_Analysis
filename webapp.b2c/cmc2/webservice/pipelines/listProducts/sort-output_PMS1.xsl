<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:pf="http://tempuri.org/"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="../em-product-templates.xsl"/>
  <xsl:param name="ctnRestriction" select="''"/>
  
  <xsl:template match="Products">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      
      <xsl:apply-templates select="CallParameters"/>
      
      <xsl:apply-templates select="CountryColumns"/>
      <xsl:apply-templates select="CountryColumnsChannels"/>
      
      <xsl:variable name="products" select="."/>
      
      <xsl:for-each select="tokenize($ctnRestriction, ',')">
        <xsl:apply-templates select="$products/Product[MasterData/CTN=current()]"/>  
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CountryColumns">
    <xsl:copy> 
      <xsl:for-each select="CountryColumn">
        <xsl:sort select="@seq" data-type="number"/>
      
        <xsl:copy-of select="current()"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CountryColumnsChannels">
    <xsl:for-each-group select="CountryColumn" group-by="@channelID">

        <xsl:element name="CountryColumns{current-grouping-key()}">
          <xsl:for-each select="current-group()">
            <xsl:sort select="@seq" data-type="number"/>
            <xsl:copy-of select="current()"/>
          </xsl:for-each>
        </xsl:element>
      
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="Product">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>