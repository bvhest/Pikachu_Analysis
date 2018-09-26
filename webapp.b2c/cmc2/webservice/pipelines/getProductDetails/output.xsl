<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="../em-product-templates.xsl"/>
  
  <xsl:param name="pmt-preview-url"/>
  <xsl:param name="relative-url-prefix"/>
              
  <xsl:param name="userID" select="''"/>
  <xsl:param name="ctn" select="''"/>
  <xsl:param name="schema" select="''"/>
  
  <xsl:template match="root">
    <xsl:element name="Products">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="DocType" select="'ListOverview'"/>
      <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
      <xsl:attribute name="NrOfProductsInThisResult" select="count(distinct-values(products/sql:rowset/sql:row/sql:ctn))"/>
      <xsl:attribute name="NrOfProductsTotal" select="count(distinct-values(products/sql:rowset/sql:row/sql:ctn))"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="em:getSchema($schema)"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="ctn" select="$ctn"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:for-each-group select="products/sql:rowset/sql:row" group-by="sql:ctn">
        <xsl:sort select="current()/sql:ctn" order="ascending"/>
        
        <xsl:call-template name="Product">
          <xsl:with-param name="pmt-preview-url"><xsl:value-of select="$pmt-preview-url"/></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>
    
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="ctn" select="''"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="ctn">
      <xsl:for-each select="tokenize($ctn, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>