<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:strip-space elements="*" />


  <xsl:param name="doctypesfilepath" />
  <xsl:include href="objectAssets.xsl" />


  <xsl:template match="/Products">
    <gsa-template>
      <import-items>
        <xsl:variable name="featurelist">
          <features>
            <xsl:for-each select="Product/KeyBenefitArea/Feature|Product/FeatureLogo">
              <xsl:if test="string(node-name(.))='Feature' 
                            or (    string(node-name(.))='FeatureLogo' 
                                and count(current-group()/KeyBenefitArea/Feature[FeatureCode=current()/FeatureCode])=0
                            )">
                <feature>
                  <xsl:variable name="feature-type" select="string(node-name(.))" />
                  <xsl:attribute name="featuretype" select="$feature-type" />
                  <code>
                    <xsl:value-of select="FeatureCode" />
                  </code>

                  <xsl:variable name="ctn" select="ancestor::Product/CTN" />
                  <xsl:variable name="master-product" select="ancestor::Product/following-sibling::MasterProduct[@CTN=$ctn]" />
                  <Product>
                    <CTN>
                      <xsl:value-of select="$ctn" />
                    </CTN>
                    <ObjectAssetList>
                      <xsl:copy-of select="ancestor::Product/ObjectAssetList/@*" />
                      <xsl:copy-of select="ancestor::Product/ObjectAssetList/Object[id=current()/FeatureCode]" />
                    </ObjectAssetList>
                  </Product>
                  <lastModified>
                    <xsl:value-of select="ancestor::Product/@lastModified" />
                  </lastModified>
                  <masterLastModified>
                    <xsl:value-of select="ancestor::Product/@masterLastModified" />
                  </masterLastModified>
                  <lastExportDate>
                    <xsl:value-of select="ancestor::Product/@LastExportDate" />
                  </lastExportDate>
                  <locale>
                    <xsl:value-of select="ancestor::Product/@Locale" />
                  </locale>
                  <masterLocale>
                    <xsl:value-of select="$master-product/@Locale" />
                  </masterLocale>
                  <catalog>
                    <xsl:value-of select="ancestor::Product/@Catalog" />
                  </catalog>
                  <feature-details>
                    <xsl:copy-of select="node()" />
                  </feature-details>
                  <master-feature-details>
                    <xsl:copy-of select="if ($feature-type='Feature') then 
                                           $master-product/KeyBenefitArea/Feature[FeatureCode=current()/FeatureCode]/*
                                         else
                                           $master-product/FeatureLogo[FeatureCode=current()/FeatureCode]/*
                                        " />
                  </master-feature-details>
                </feature>
              </xsl:if>
            </xsl:for-each>
          </features>
        </xsl:variable>

        <xsl:for-each-group select="$featurelist/features/feature" group-by="code">
          <xsl:for-each select="current-group()">
            <xsl:sort select="masterLastModified" order="descending" />
            <xsl:variable name="lastModified" select="lastModified" as="xs:dateTime" />
            <xsl:variable name="lastExportDate" select="lastExportDate" as="xs:dateTime" />
            <xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
              <xsl:variable name="global" select="''" />
              <xsl:variable name="featuretype" select="@featuretype" />
              <xsl:variable name="itemCode" select="concat(feature-details/FeatureCode,'_',locale)" />
              <xsl:variable name="master-itemCode" select="if (masterLocale) then
                                                             concat(feature-details/FeatureCode,'_',masterLocale)
                                                           else ()" />

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="feature-translation" id="{$itemCode}">
                <set-property name="glossary">
                  <xsl:value-of select="feature-details/FeatureGlossary" />
                </set-property>
                <set-property name="displayName">
                  <xsl:choose>
                    <xsl:when test="$featuretype='Feature'">
                      <xsl:value-of select="feature-details/FeatureName" />
                    </xsl:when>
                    <xsl:when test="$featuretype='FeatureLogo'">
                      <xsl:value-of select="feature-details/FeatureReferenceName" />
                    </xsl:when>
                  </xsl:choose>
                </set-property>
                <set-property name="how">
                  <xsl:value-of select="feature-details/FeatureHow" />
                </set-property>
                <set-property name="why">
                  <xsl:value-of select="feature-details/FeatureWhy" />
                </set-property>
                <set-property name="longDescription">
                  <xsl:value-of select="feature-details/FeatureLongDescription" />
                </set-property>
                <set-property name="what">
                  <xsl:value-of select="feature-details/FeatureWhat" />
                </set-property>
                <set-property name="shortDescription">
                  <xsl:value-of select="feature-details/FeatureShortDescription" />
                </set-property>

                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap(locale,Product,'featuretransl',feature-details/FeatureCode)" />
                </set-property>
              </add-item>

              <xsl:if test="master-feature-details/*">
                <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="feature-translation" id="{$master-itemCode}">
                  <set-property name="glossary">
                    <xsl:value-of select="master-feature-details/FeatureGlossary" />
                  </set-property>
                  <set-property name="displayName">
                    <xsl:choose>
                      <xsl:when test="$featuretype='Feature'">
                        <xsl:value-of select="master-feature-details/FeatureName" />
                      </xsl:when>
                      <xsl:when test="$featuretype='FeatureLogo'">
                        <xsl:value-of select="master-feature-details/FeatureReferenceName" />
                      </xsl:when>
                    </xsl:choose>
                  </set-property>
                  <set-property name="how">
                    <xsl:value-of select="master-feature-details/FeatureHow" />
                  </set-property>
                  <set-property name="why">
                    <xsl:value-of select="master-feature-details/FeatureWhy" />
                  </set-property>
                  <set-property name="longDescription">
                    <xsl:value-of select="master-feature-details/FeatureLongDescription" />
                  </set-property>
                  <set-property name="what">
                    <xsl:value-of select="master-feature-details/FeatureWhat" />
                  </set-property>
                  <set-property name="shortDescription">
                    <xsl:value-of select="master-feature-details/FeatureShortDescription" />
                  </set-property>
                </add-item>
              </xsl:if>

              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="locale" />
                <xsl:with-param name="prd" select="Product" />
                <xsl:with-param name="objectName" select="'featuretransl'" />
                <xsl:with-param name="objectId" select="feature-details/FeatureCode" />
              </xsl:call-template>

              <add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="feature" id="{feature-details/FeatureCode}">
                <set-property name="translations" add="true">
                  <xsl:value-of select="concat(locale,'=',$itemCode)" />
                </set-property>
                <xsl:if test="master-feature-details/*">
                  <set-property name="translations" add="true">
                    <xsl:value-of select="concat(masterLocale,'=',$master-itemCode)" />
                  </set-property>
                </xsl:if>
                <set-property name="assetMap">
                  <xsl:value-of select="my:objectAssetMap($global,Product,'feature',feature-details/FeatureCode)" />
                </set-property>
              </add-item>
              <xsl:call-template name="objectAssetList">
                <xsl:with-param name="locale" select="$global" />
                <xsl:with-param name="prd" select="Product" />
                <xsl:with-param name="objectName" select="'feature'" />
                <xsl:with-param name="objectId" select="feature-details/FeatureCode" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
