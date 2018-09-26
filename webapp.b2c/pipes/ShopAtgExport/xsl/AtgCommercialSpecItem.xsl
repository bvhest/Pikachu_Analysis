<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/CSChapter/CSItem" group-by="CSItemCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../../following-sibling::MasterProduct[@CTN=current()/../../CTN]" />
              <xsl:variable name="locale" select="../../@Locale" />
              <xsl:variable name="itemCode" select="concat(CSItemCode,'_',$locale)" />
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(CSItemCode,'_',$master-product/@Locale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-item-translation"
                        id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="CSItemName" />
                </set-property>
              </add-item>

              <xsl:if test="$master-product and $master-product/CSChapter/CSItem[CSItemCode=current-grouping-key()]">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-item-translation"
                          id="{$master-itemCode}">
                  <set-property name="name">
                    <xsl:value-of select="$master-product/CSChapter/CSItem[CSItemCode=current-grouping-key()]/CSItemName" />
                  </set-property>
                </add-item>
              </xsl:if>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-item"
                        id="{CSItemCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat($locale,'=',$itemCode)" />
                </set-property>

                <xsl:if test="$master-product and $master-product/CSChapter/CSItem[CSItemCode=current-grouping-key()]">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($master-product/@Locale,'=',$master-itemCode)" />
                  </set-property>
                </xsl:if>
                
                <xsl:choose>
                  <xsl:when test="UnitOfMeasure/UnitOfMeasureCode">
                    <set-property name="unitOfMeasure">
                      <xsl:value-of select="UnitOfMeasure/UnitOfMeasureCode" />
                    </set-property>
                  </xsl:when>
                  <xsl:otherwise>
                    <set-property name="unitOfMeasure">
                      <xsl:text>__NULL__</xsl:text>
                    </set-property>
                  </xsl:otherwise>
                </xsl:choose>
              </add-item>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>

        <xsl:for-each-group select="current-group()/NavigationGroup/NavigationAttribute"
          group-by="NavigationAttributeCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="locale" select="../../@Locale" />
              <xsl:variable name="itemCode" select="concat(NavigationAttributeCode,'_',$locale)" />
              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-item-translation"
                id="{$itemCode}">
                <set-property name="name">
                  <xsl:value-of select="NavigationAttributeName" />
                </set-property>
              </add-item>
              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-item"
                id="{NavigationAttributeCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat($locale,'=',$itemCode)" />
                </set-property>
              </add-item>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
