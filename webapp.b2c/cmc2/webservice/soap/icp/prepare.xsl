<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  <xsl:template match="sql:*"/>
  
  <xsl:template match="tns:Object|sql:data">
    <Products>
      <xsl:apply-templates select="Product"/>
    </Products>
  </xsl:template>
  
  <xsl:template match="octl">
    <xsl:apply-templates select="sql:rowset/sql:row/sql:data"/>
  </xsl:template>
  
</xsl:stylesheet>
