<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:my="http://www.philips.com/pika"
    extension-element-prefixes="my">
  <xsl:strip-space elements="*" />

  <xsl:param name="doctypesfilepath" />
  <xsl:include href="objectAssets.xsl" />

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/AccessoryByPacked" group-by="AccessoryByPackedCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../@masterLastModified" order="descending" />
            
            <xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../following-sibling::MasterProduct[@CTN=current()/../CTN]" />
              <xsl:variable name="locale" select="../@Locale" />
              <xsl:variable name="global" select="''" />
              <xsl:variable name="itemCode" select="concat(AccessoryByPackedCode,'_',../@Locale)" />
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(AccessoryByPackedCode,'_',$master-product/@Locale)
                                                           else ()" />
              
              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="accessory-bypacked-translation"
                        id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="AccessoryByPackedName" />
                </set-property>
              </add-item>
              
              <xsl:if test="$master-product and $master-product/AccessoryByPacked[AccessoryByPackedCode=current-grouping-key()]">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="accessory-bypacked-translation"
                          id="{$master-itemCode}">
                  <set-property name="name">
                    <xsl:value-of select="$master-product/AccessoryByPacked[AccessoryByPackedCode=current-grouping-key()]/AccessoryByPackedName" />
                  </set-property>
                </add-item>
              </xsl:if>
              
              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="accessory-bypacked"
                        id="{AccessoryByPackedCode}">
                <set-property name="reference">
                  <xsl:value-of select="AccessoryByPackedReference" />
                </set-property>
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat(../@Locale,'=',$itemCode)" />
                </set-property>
                <xsl:if test="$master-product and $master-product/AccessoryByPacked[AccessoryByPackedCode=current-grouping-key()]">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($master-product/@Locale,'=',$master-itemCode)" />
                  </set-property>
                </xsl:if>
                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap($global,..,'accessory-bypacked',AccessoryByPackedCode)" />
                </set-property>
              </add-item>
              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="$global" />
                <xsl:with-param name="prd" select=".." />
                <xsl:with-param name="objectName" select="'accessory-bypacked'" />
                <xsl:with-param name="objectId" select="AccessoryByPackedCode" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
