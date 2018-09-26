<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!--
    This stylesheet normalizes the element order for XML files that conform to xUCDM Product External 1.2.  
  -->
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Node">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="MarketingVersion" />
      <xsl:apply-templates select="MarketingStatus" />
      <xsl:apply-templates select="LifecycleStatus" />
      <xsl:apply-templates select="Owner" />
      <xsl:apply-templates select="Name" />
      <xsl:apply-templates select="WOW" />
      <xsl:apply-templates select="SubWOW" />
      <xsl:apply-templates select="MarketingTextHeader" />
      <xsl:apply-templates select="KeyBenefitArea">
        <xsl:sort data-type="number" select="KeyBenefitAreaRank" />
        <xsl:sort select="KeyBenefitAreaCode" />
      </xsl:apply-templates>
      <xsl:apply-templates select="SystemLogo">
        <xsl:sort data-type="number" select="SystemLogoRank" />
      </xsl:apply-templates>
      <xsl:apply-templates select="CSChapter">
        <xsl:sort data-type="number" select="CSChapterRank" />
      </xsl:apply-templates>
      <xsl:apply-templates select="Filters" />
      <xsl:apply-templates select="Award">
        <xsl:sort data-type="number" select="AwardRank" />
      </xsl:apply-templates>
      <xsl:apply-templates select="ProductReferences">
        <xsl:sort select="ProductReferenceType" />
      </xsl:apply-templates>
      <xsl:apply-templates select="ProductRefs" />
      <xsl:apply-templates select="RichTexts" />
      <xsl:apply-templates select="AssetList" />
      <xsl:apply-templates select="ObjectAssetList" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="KeyBenefitArea">
    <KeyBenefitArea>
      <xsl:apply-templates select="KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank" />
      <xsl:apply-templates select="Feature">
        <xsl:sort data-type="number" select="FeatureTopRank" />
        <xsl:sort data-type="number" select="FeatureRank" />
      </xsl:apply-templates>
    </KeyBenefitArea>
  </xsl:template>

  <xsl:template match="CSChapter">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|CSChapterCode|CSChapterName|CSChapterRank"/>
      <xsl:apply-templates select="CSItem">
        <xsl:sort data-type="number" select="CSItemRank"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CSItem">
    <CSItem>
      <xsl:apply-templates select="@*|CSItemCode|CSItemName|CSItemRank|CSItemIsFreeFormat" />
      <xsl:apply-templates select="CSValue">
        <xsl:sort data-type="number" select="CSValueRank" />
      </xsl:apply-templates>
      <xsl:apply-templates select="UnitOfMeasure" />
    </CSItem>
  </xsl:template>
  
  <xsl:template match="Filters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Purpose">  
        <xsl:sort select="@type"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Purpose">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="Features|CSItems" mode="mFilters"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Features" mode="mFilters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Feature">
        <xsl:sort data-type="number" select="@rank" />
        <xsl:sort select="@code" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CSItems" mode="mFilters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="CSItem">
        <xsl:sort data-type="number" select="@rank" />
        <xsl:sort select="@code" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Disclaimers">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Disclaimer">
        <xsl:sort data-type="number" select="@rank" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductClusters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ProductCluster">
        <xsl:sort data-type="number" select="@rank" />
        <xsl:sort select="@code"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <!-- Convert ProductReferences to ProductRefs -->
  <xsl:template match="ProductReferences[empty(preceding-sibling::ProductReferences)]">
    <ProductRefs>
      <xsl:apply-templates select=".|following-sibling::ProductReferences" mode="convert"/>
    </ProductRefs>
  </xsl:template>
  <xsl:template match="ProductReferences[exists(preceding-sibling::ProductReferences)]"/>
  
  <xsl:template match="ProductReferences" mode="convert">
    <ProductReference>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="CTN">
        <xsl:sort data-type="number" select="@rank" />
      </xsl:apply-templates>
    </ProductReference>
  </xsl:template>
  
  <xsl:template match="ProductRefs">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ProductReference" mode="mProductRefs">
        <xsl:sort select="ProductReferenceType" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductReference" mode="mProductRefs">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="CTN">
        <xsl:sort select="text()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="Product">
        <xsl:sort select="@ctn"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Merge RichText children into one RichText for each RichText type
    and order the children.
  -->
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="RichText" group-by="@type">
        <xsl:sort select="@type"/>
        
        <RichText type="{current-grouping-key()}">
          <xsl:choose>
            <xsl:when test="current-group()/Chapter">
              <xsl:for-each-group select="current-group()/*" group-starting-with="Chapter">
                <xsl:sort select="self::Chapter/@rank"/>
                <xsl:sort select="self::Chapter/@code"/>
                <xsl:apply-templates select="self::Chapter"/>
                <xsl:apply-templates select="current-group()[self::Item]">
                  <xsl:sort select="@rank"/>
                  <xsl:sort select="@code"/>
                </xsl:apply-templates>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="current-group()/Item">
                <xsl:sort select="@rank"/>
                <xsl:sort select="@code"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </RichText>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="BulletList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="BulletItem">
        <xsl:sort data-type="number" select="@rank"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="SubList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="SubItem">
        <xsl:sort data-type="number" select="@rank"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="AssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset">
        <xsl:sort select="ResourceType"/>
        <xsl:sort select="Language"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ObjectAssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Object" mode="mObjectAssetList">
        <xsl:sort select="id"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Object" mode="mObjectAssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset">
        <xsl:sort select="ResourceType"/>
        <xsl:sort select="Language"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
