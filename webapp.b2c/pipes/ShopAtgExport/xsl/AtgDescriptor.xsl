<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/NamingString/Descriptor" group-by="DescriptorCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../../following-sibling::MasterProduct[@CTN=current()/../../CTN]" />
              <xsl:variable name="locale" select="../../@Locale" />
              <xsl:variable name="itemCode" select="concat(DescriptorCode,'_',$locale)" />
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(DescriptorCode,'_',$master-product/@Locale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="descriptor-translation"
                        id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="DescriptorName" />
                </set-property>
              </add-item>

              <xsl:if test="$master-product and $master-product/NamingString/Descriptor">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="descriptor-translation"
                          id="{$master-itemCode}">
                  <set-property name="name">
                    <xsl:value-of select="$master-product/NamingString/Descriptor/DescriptorName" />
                  </set-property>
                </add-item>
              </xsl:if>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="descriptor"
                        id="{DescriptorCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat($locale,'=',$itemCode)" />
                </set-property>
                <xsl:if test="$master-product and $master-product/NamingString/Descriptor">
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
