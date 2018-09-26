<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:my="http://www.philips.com/pika" 
    extension-element-prefixes="my">

  <xsl:include href="objectAssets.xsl" />

  <xsl:strip-space elements="*" />
  
  <xsl:variable name="atgNullValue" select="'__NULL__'"/>

  <xsl:function name="my:atgNULL">
    <xsl:param name="value"/>
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="not($value) or $value=''">
          <xsl:value-of select="$atgNullValue"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>

  <xsl:template match="/">
    <gsa-template>
      <import-items>
        <xsl:for-each-group select="/Products/Product/Award" group-by="AwardCode">
          <xsl:for-each select="current-group()">
            <xsl:sort select="../@masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="../@lastModified" as="xsl:dateTime" />
            <xsl:variable name="lastExportDate" select="../@LastExportDate" as="xsl:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="master-product" select="../following-sibling::MasterProduct[@CTN=current()/../CTN]" />
              <xsl:variable name="itemCode" select="concat(AwardCode,'_',../@Locale)" />
              <xsl:variable name="master-itemCode" select="if ($master-product) then
                                                             concat(AwardCode,'_',$master-product/@Locale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="award-translation"
                  id="{$itemCode}">
                <set-property name="awardName">
                  <xsl:value-of select="AwardName" />
                </set-property>
                <set-property name="place">
                  <xsl:value-of select="my:atgNULL(AwardPlace)" />
                </set-property>
                <set-property name="awardDescription">
                  <xsl:value-of select="AwardDescription" />
                </set-property>
                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap(../@Locale, .., 'award', AwardCode)" />
                </set-property>
              </add-item>
              
              <xsl:if test="$master-product and $master-product/Award[AwardCode=current-grouping-key()]">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="award-translation"
                    id="{$master-itemCode}">
                  <set-property name="awardName">
                    <xsl:value-of select="$master-product/Award[AwardCode=current-grouping-key()]/AwardName" />
                  </set-property>
                  <set-property name="place">
                    <xsl:value-of select="my:atgNULL($master-product/Award[AwardCode=current-grouping-key()]/AwardPlace)" />
                  </set-property>
                  <set-property name="awardDescription">
                    <xsl:value-of select="$master-product/Award[AwardCode=current-grouping-key()]/AwardDescription" />
                  </set-property>
                </add-item>
              </xsl:if>
              
              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="../@Locale" />
                <xsl:with-param name="prd" select=".." />
                <xsl:with-param name="objectName" select="'award'" />
                <xsl:with-param name="objectId" select="AwardCode" />
              </xsl:call-template>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="award"
                  id="{AwardCode}">
                <set-property name="awardRank">
                  <xsl:value-of select="AwardRank" />
                </set-property>
                <set-property name="awardType">
                  <xsl:value-of select="@AwardType" />
                </set-property>
                <set-property name="awardCode">
                  <xsl:value-of select="AwardCode" />
                </set-property>
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat(../@Locale,'=',$itemCode)" />
                </set-property>
                
                <xsl:if test="$master-product and $master-product/Award[AwardCode=current-grouping-key()]">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat($master-product/@Locale,'=',$master-itemCode)" />
                  </set-property>
                </xsl:if>
                
                <set-property name="awardDate">
                  <xsl:value-of select="my:atgNULL(AwardDate)" />
                </set-property>
                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap('', .., 'award', AwardCode)" />
                </set-property>
              </add-item>
              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="''" />
                <xsl:with-param name="prd" select=".." />
                <xsl:with-param name="objectName" select="'award'" />
                <xsl:with-param name="objectId" select="AwardCode" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
