<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="image-config-pmt" select="document('../config/doctypeConfig_PMT.xml')/imageconfigs" />
  <xsl:variable name="image-config-fmt" select="document('../config/doctypeConfig_FMT.xml')/imageconfigs" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Products">
    <xsl:apply-templates select="Product" />
  </xsl:template>
  
  <xsl:template match="Nodes">
    <xsl:apply-templates select="Node" />
  </xsl:template>

  <xsl:template match="Products/Product">
    <xsl:apply-templates select="AssetList/Asset">
      <xsl:with-param name="id" select="CTN"/>
      <xsl:with-param name="owner" select="'PMT'"/>
      <xsl:with-param name="image-config" select="$image-config-pmt"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="ObjectAssetList/Object">
      <xsl:with-param name="owner" select="'PMT'"/>
      <xsl:with-param name="image-config" select="$image-config-pmt"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="Nodes/Node">
    <xsl:apply-templates select="AssetList/Asset">
      <xsl:with-param name="id" select="@code"/>
      <xsl:with-param name="owner" select="'FMT'"/>
      <xsl:with-param name="image-config" select="$image-config-fmt"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="ObjectAssetList/Object">
      <xsl:with-param name="owner" select="'FMT'"/>
      <xsl:with-param name="image-config" select="$image-config-fmt"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList/Object">
    <xsl:param name="image-config"/>
    <xsl:param name="owner"/>
    <xsl:apply-templates select="Asset">
      <xsl:with-param name="id" select="id"/>
      <xsl:with-param name="image-config" select="$image-config"/>
      <xsl:with-param name="owner" select="$owner"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="Asset">
    <xsl:param name="id"/>
    <xsl:param name="owner"/>
    <xsl:param name="image-config"/>
    <xsl:if test="$image-config/imageconfig[doctype=current()/ResourceType]">
      <xsl:if test="Modified != '' and InternalResourceIdentifier != ''">
        <asset id="{$id}" type="{ResourceType}" owner="{$owner}"
               locale="{if (empty(Language) or Language='') then 'global' else Language}"
               modified="{replace(Modified,'[^0-9]','')}"
               ccrsource="{substring-after(InternalResourceIdentifier/text(),'/mprdata/')}"/>
      </xsl:if>      
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
