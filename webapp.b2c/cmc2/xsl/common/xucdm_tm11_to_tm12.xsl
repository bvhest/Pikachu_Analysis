<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!--
    Convert a xUCDM 1.1+ treenode to xUCDM 1.2.
    
    1. Add mandatory elements: AssetList, ObjectAssetList.
    2. Convert ProductReferences to ProductRefs. 
       Note: this does not take into account the deprecated ProductReference element directly under Product.
    3. Normalize element ordering for elements that have some sort of ranking attribute.
  -->
  
  <xsl:import href="xucdm_treenode_marketing_1_2_normalize.xsl"/>
    
  <!-- ProductReferenceType mapping -->
  <xsl:variable name="prt-map">
    <prt name12="Accessory" name11="hasAsAccessory"/>
    <prt name12="Performer" name11="isAccessoryOf"/>
    <prt name12="assigned" name11="assigned"/>
    <!--prt name12="???" name11="hasPredecessor"/-->
  </xsl:variable>

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
      <xsl:apply-templates select="KeyBenefitArea"/>
      <xsl:apply-templates select="SystemLogo"/>
      <xsl:apply-templates select="CSChapter"/>
      <xsl:apply-templates select="Filters" />
      <xsl:apply-templates select="Award"/>
      <ProductRefs>
        <xsl:apply-templates select="ProductRefs/ProductReference"/>
        <xsl:for-each-group select="ProductReferences/ProductReference[@ProductReferenceType=$prt-map/prt/@name11]" group-by="@ProductReferenceType">
          <ProductReference ProductReferenceType="{current-grouping-key()}">
            <xsl:apply-templates select="current-group()/CTN">
              <xsl:sort select="../ProductReferenceRank" data-type="number"/>
            </xsl:apply-templates>
          </ProductReference>
        </xsl:for-each-group>
      </ProductRefs>
      <xsl:apply-templates select="RichTexts" />
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
    
  <xsl:template match="ProductReferences/ProductReference/CTN">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="rank" select="../ProductReferenceRank"/>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@ProductReferenceType">
    <xsl:attribute name="ProductReferenceType" select="$prt-map/prt[@name11=string(current())]/@name12" />
  </xsl:template>
</xsl:stylesheet>
