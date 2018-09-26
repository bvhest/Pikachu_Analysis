<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:pf="http://tempuri.org/"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="output.xsl"/>
  <xsl:import href="../em-product-templates_pms2.xsl"/>
                  
  <!-- override to add email -->
  <xsl:template name="ProductOwner">
    <xsl:param name="data"/>
    <xsl:variable name="product-owners" select="/root/products/accounts"/>
    
    <xsl:element name="ProductOwner">
      <xsl:attribute name="columnID" select="'POW'"/>
      <xsl:attribute name="accountID" select="sql:owner"/>
      <xsl:attribute name="email" select="$product-owners/account[@accountID = current()/sql:owner]/pf:GetDetailsResult/pf:Email"/>
      
      <xsl:value-of select="$product-owners/account[@accountID = current()/sql:owner]/pf:GetDetailsResult/pf:FullName"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Relative URLs -->
  <xsl:template name="ThumbnailURL">
    <xsl:param name="url"/>
    
    <xsl:element name="ThumbnailURL">
      <xsl:value-of select="em:getRelativeImageURL($url, $relative-url-prefix)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="MediumImageURL">
    <xsl:param name="url"/>
    
    <xsl:element name="MediumImageURL">
      <xsl:value-of select="em:getRelativeImageURL($url, $relative-url-prefix)"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>