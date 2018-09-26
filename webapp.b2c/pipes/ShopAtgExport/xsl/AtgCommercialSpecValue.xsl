<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/CSChapter/CSItem/CSValue" group-by="CSValueCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../../../@masterLastModified" order="descending"/>
            <xsl:variable name="lastModified" select="../../../@lastModified" as="xs:dateTime"/>
            <xsl:variable name="mlastModified" select="../../../@masterLastModified" as="xs:dateTime"/>
            <xsl:variable name="lastExportDate" select="../../../@LastExportDate" as="xs:dateTime"/>
            <xsl:variable name="locale" select="../../../@Locale"/>
            <xsl:variable name="itemCode" select="concat(CSValueCode,'_',$locale)"/>
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../../../following-sibling::MasterProduct[@CTN=current()/../../../CTN]" />
              <xsl:variable name="itemCode" select="concat(CSValueCode,'_',$locale)"/>
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(CSValueCode,'_',$master-product/@Locale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-value-translation" id="{$itemCode}">
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

              <xsl:if test="$master-product and $master-product/CSChapter/CSItem/CSValue[CSValueCode=current-grouping-key()]">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-value-translation" id="{$master-itemCode}">
                  <xsl:variable name="csvalue-name" select="$master-product/CSChapter/CSItem/CSValue[CSValueCode=current-grouping-key()]/CSValueName" />
                  <set-property name="value">
                    <xsl:choose>
                      <xsl:when test="string-length($csvalue-name)=0">
                        <xsl:text> </xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$csvalue-name"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </set-property>
                </add-item>
              </xsl:if>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="comm-spec-value" id="{CSValueCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat($locale,'=',$itemCode)"/>
                </set-property>

                <xsl:if test="$master-product and $master-product/CSChapter/CSItem/CSValue[CSValueCode=current-grouping-key()]">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($master-product/@Locale,'=',$master-itemCode)"/>
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
