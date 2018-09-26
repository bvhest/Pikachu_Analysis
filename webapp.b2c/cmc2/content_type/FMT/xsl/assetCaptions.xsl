<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="AssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset" mode="asset-caption">
        <xsl:with-param name="captions" select="../RichTexts/RichText[@type='AssetCaption']/Item"/>
        <xsl:with-param name="id" select="../CTN/text()"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList/Object">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="id"/>
      <xsl:apply-templates select="Asset" mode="asset-caption">
        <xsl:with-param name="captions" select="../RichTexts/RichText[@type='AssetCaption']/Item"/>
        <xsl:with-param name="id" select="id/text()"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Asset" mode="asset-caption">
    <xsl:param name="captions"/>
    <xsl:param name="id"/>
    
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="caption" select="$captions[@code=$id and docType=current()/ResourceType]"/> 
      <xsl:if test="$caption">
        <Caption>
          <xsl:value-of select="$caption/Head"/>
        </Caption>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>