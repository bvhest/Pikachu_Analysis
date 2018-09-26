<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Convert a xUCDM 1.1+ product to xUCDM 1.2.
    
    1. Add mandatory elements: ProductCluster, AssetList, ObjectAssetList.
    2. Convert ProductReferences to ProductRefs. 
       Note: this does not take into account the deprecated ProductReference element directly under Product.
    3. Normalize element ordering for elements that have some sort of ranking attribute.
  -->
  
  <xsl:import href="xucdm_product_marketing_1_2_normalize.xsl"/>
  
  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="CTN" />
      <xsl:apply-templates select="Code12NC" />
      <xsl:apply-templates select="GTIN" />
      <xsl:apply-templates select="ProductType" />
      <xsl:apply-templates select="MarketingVersion" />
      <xsl:apply-templates select="MarketingStatus" />
      <xsl:apply-templates select="LifecycleStatus" />
      <xsl:apply-templates select="CRDate" />
      <xsl:apply-templates select="CRDateYW" />
      <xsl:apply-templates select="ModelYears" />
      <xsl:apply-templates select="ProductDivision" />
      <xsl:apply-templates select="ProductOwner" />
      <xsl:apply-templates select="DTN" />
      <xsl:apply-templates select="ProductName" />
      <xsl:apply-templates select="FullProductName" />
      <xsl:apply-templates select="NamingString" />
      <xsl:apply-templates select="ShortDescription" />
      <xsl:apply-templates select="WOW" />
      <xsl:apply-templates select="SubWOW" />
      <xsl:apply-templates select="MarketingTextHeader" />
      <xsl:apply-templates select="KeyBenefitArea"/>
      <xsl:apply-templates select="SystemLogo"/>
      <xsl:apply-templates select="PartnerLogo"/>
      <xsl:apply-templates select="FeatureLogo"/>
      <xsl:apply-templates select="FeatureImage"/>
      <xsl:apply-templates select="FeatureHighlight"/>
      <xsl:apply-templates select="CSChapter"/>
      <xsl:apply-templates select="Filters" />
      <xsl:apply-templates select="FeatureCompareGroups" />
      <xsl:apply-templates select="Disclaimers" />
      <xsl:apply-templates select="KeyValuePairs" />
      <xsl:apply-templates select="AccessoryByPacked"/>
      <xsl:apply-templates select="Award"/>
      <xsl:choose>
        <xsl:when test="exists(ProductClusters)">
          <xsl:apply-templates select="ProductClusters" />
        </xsl:when>
        <xsl:otherwise>
          <ProductClusters/>
        </xsl:otherwise>
      </xsl:choose>
      <ProductRefs>
        <xsl:apply-templates select="ProductReferences|ProductRefs/ProductReference"/>
      </ProductRefs>
      <xsl:apply-templates select="SellingUpFeature">
        <xsl:sort select="FeatureCode"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="ConsumerSegment">
        <xsl:sort select="ConsumerSegmentCode"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="RichTexts" />
      <xsl:apply-templates select="GreenData" />
      <xsl:choose>
        <xsl:when test="exists(AssetList)">
          <xsl:apply-templates select="AssetList" />
        </xsl:when>
        <xsl:otherwise>
          <AssetList/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="exists(ObjectAssetList)">
          <xsl:apply-templates select="ObjectAssetList" />
        </xsl:when>
        <xsl:otherwise>
          <ObjectAssetList/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Product/ProductReferences">
    <ProductReference>
      <xsl:apply-templates select="@*|node()"/>
    </ProductReference>
  </xsl:template>
  
</xsl:stylesheet>