<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/KeyBenefitArea" group-by="KeyBenefitAreaCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../following-sibling::MasterProduct[@CTN=current()/../CTN]" />
              <xsl:variable name="itemCode" select="concat(KeyBenefitAreaCode,'_',../@Locale)" />
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(KeyBenefitAreaCode,'_',$master-product/@Locale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="key-benefit-area-translation"
                        id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="KeyBenefitAreaName" />
                </set-property>
              </add-item>

              <xsl:if test="$master-product and $master-product/KeyBenefitArea[KeyBenefitAreaCode=current-grouping-key()]">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="key-benefit-area-translation"
                          id="{$master-itemCode}">
                  <set-property name="name">
                    <xsl:value-of select="$master-product/KeyBenefitArea[KeyBenefitAreaCode=current-grouping-key()]/KeyBenefitAreaName" />
                  </set-property>
                </add-item>
              </xsl:if>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="key-benefit-area"
                        id="{KeyBenefitAreaCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat(../@Locale,'=',$itemCode)" />
                </set-property>
                <xsl:if test="$master-product and $master-product/KeyBenefitArea[KeyBenefitAreaCode=current-grouping-key()]">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($master-product/@Locale,'=',$master-itemCode)" />
                  </set-property>
                </xsl:if>
              </add-item>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
