<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product" group-by="@Catalog">
          <xsl:variable name="currentcatalog" select="current-grouping-key()"/>
          <xsl:for-each-group select="/Products/Product[@Catalog=$currentcatalog]/CSChapter/CSItem/CSValue" group-by="CSValueCode">
            <xsl:for-each select="current-group()">
              <xsl:sort select="../../../@masterLastModified" order="descending"/>
                <xsl:variable name="lastModified" select="../../../@lastModified" as="xs:dateTime"/>
                <xsl:variable name="mlastModified" select="../../../@masterLastModified" as="xs:dateTime"/>
                <xsl:variable name="lastExportDate"     select="../../../@LastExportDate"     as="xs:dateTime"/>
                <xsl:variable name="catalogLocale" select="concat(../../../@Locale,'_',../../../@Catalog)"/>
                <xsl:variable name="itemCode" select="concat(CSValueCode,'_',$catalogLocale)"/>
                <!--
                <CSV>
                <ctn><xsl:value-of select="../../../CTN"/></ctn>
                <lm><xsl:value-of select="$lastModified"/></lm>
                <mlm><xsl:value-of select="$mlastModified"/></mlm>
                <lastExport><xsl:value-of select="$lastExportDate"/></lastExport>
                <catalogLocale><xsl:value-of select="$catalogLocale"/></catalogLocale>
                <itemCode><xsl:value-of select="$itemCode"/></itemCode>
                </CSV>
                -->
                <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
                  <xsl:variable name="catalogLocale" select="concat(../../../@Locale,'_',../../../@Catalog)"/>
                  <xsl:variable name="itemCode" select="concat(CSValueCode,'_',$catalogLocale)"/>
                  <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-value-translation" id="{$itemCode}">
                    <set-property name="value">
                      <xsl:choose>
                        <xsl:when test="string-length(CSValueName)=0">
                          <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="CSValueName"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </set-property>
                  </add-item>
                  <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-value" id="{CSValueCode}">
                    <set-property name="translations" add="true">
                    <xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/>
                    </set-property>
                  </add-item>
                </xsl:if>
            </xsl:for-each>
          </xsl:for-each-group>
          <xsl:for-each-group select="/Products/Product[@Catalog=$currentcatalog]/NavigationGroup/NavigationAttribute/NavigationValue" group-by="NavigationValueCode">
            <xsl:for-each select="current-group()">
              <xsl:sort select="../../../@masterLastModified" order="descending"/>
              <xsl:variable name="lastModified" select="../../../@lastModified" as="xs:dateTime"/>
              <xsl:variable name="lastExportDate" select="../../../@LastExportDate" as="xs:dateTime"/>
              <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
                <xsl:variable name="catalogLocale" select="concat(../../../@Locale,'_',../../../@Catalog)"/>
                <xsl:variable name="itemCode" select="concat(NavigationValueCode,'_',$catalogLocale)"/>
                <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-value-translation" id="{$itemCode}">
                  <set-property name="value">
                    <xsl:value-of select="NavigationValueName"/>
                  </set-property>
                </add-item>
                <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-value" id="{NavigationValueCode}">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/>
                  </set-property>
                </add-item>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
