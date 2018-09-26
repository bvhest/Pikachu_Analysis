<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"  xmlns:my="http://www.philips.com/nvrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->      
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>  
  
  <xsl:template match="Product">
    <xsl:copy>
      <xsl:apply-templates select="@*|CTN"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  </xsl:stylesheet>
  