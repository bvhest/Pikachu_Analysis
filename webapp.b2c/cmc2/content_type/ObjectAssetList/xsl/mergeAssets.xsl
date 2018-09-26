<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Merge ObjectMsg from inbox with ObjectMsg from cache. 
  -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="AssetsToCompare">
    <xsl:copy copy-namespaces="no">
      <!-- First ProductMsg is the inbox version. Merge the assets with the cached assets. -->
      <xsl:apply-templates select="ObjectsMsg[1]" mode="merge"/>
      <xsl:apply-templates select="ObjectsMsg[2]"/>
      <!-- Save the merged version for storage -->
      <store>
        <xsl:apply-templates select="ObjectsMsg[1]" mode="merge"/>
      </store>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectsMsg" mode="merge">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="Object" mode="merge">
        <xsl:with-param name="cached-assets" select="following-sibling::ObjectsMsg/Object/Asset"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Object" mode="merge">
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
