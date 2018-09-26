<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://www.philips.com/pika"
    extension-element-prefixes="my">

  <xsl:strip-space elements="*" />

  <xsl:param name="doctypesfilepath" />

  <xsl:include href="objectAssets.xsl" />

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/PartnerLogo" group-by="PartnerLogoCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="itemCode" select="PartnerLogoCode" />
              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="partner-logo" id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="PartnerLogoName" />
                </set-property>
                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap('',..,'partner-logo',PartnerLogoCode)" />
                </set-property>
              </add-item>
              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="''" />
                <xsl:with-param name="prd" select=".." />
                <xsl:with-param name="objectName" select="'partner-logo'" />
                <xsl:with-param name="objectId" select="PartnerLogoCode" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
