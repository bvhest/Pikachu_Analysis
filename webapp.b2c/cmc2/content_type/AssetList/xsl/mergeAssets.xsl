<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Merge ProductMsg from inbox with ProductMsg from cache. 
  -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="AssetsToCompare">
    <xsl:copy copy-namespaces="no">
      <!-- First ProductMsg is the inbox version. Merge the assets with the cached assets. -->
      <xsl:apply-templates select="ProductsMsg[1]" mode="merge"/>
      <xsl:apply-templates select="ProductsMsg[2]"/>
      <!-- Save the merged version for storage -->
      <store>
        <xsl:apply-templates select="ProductsMsg[1]" mode="merge"/>
      </store>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductsMsg" mode="merge">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="Product" mode="merge">
        <xsl:with-param name="cached-assets" select="following-sibling::ProductsMsg/Product/Asset"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product" mode="merge">
    <xsl:param name="cached-assets"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <!-- Add cached assets that are not in the inbox Product to get a full Asset list for the product -->
      <xsl:apply-templates select="for $a in $cached-assets
                                   return
                                    if (empty(Asset[ResourceType=$a/ResourceType][Language=$a/Language]))
                                    then
                                      $a
                                    else
                                      ()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
