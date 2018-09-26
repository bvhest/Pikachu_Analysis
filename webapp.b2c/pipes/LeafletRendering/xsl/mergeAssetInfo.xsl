<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:local="http://pww.pkachu.philips.com/functions/local"
    extension-element-prefixes="local">

  <xsl:import href="../Assets/XSL/rendering-functions.xsl"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="root">
    <xsl:copy>
      <xsl:for-each-group select="batch/asset" group-by="concat(@type,@locale,@id)">
        <xsl:apply-templates select="current-group()[1]"/>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <!-- Add cache information to the asset -->
  <xsl:template match="asset">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="cachename" select="local:get-asset-cache-filename(.)"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>