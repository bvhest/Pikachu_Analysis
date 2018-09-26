<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="svcURL" />

  <xsl:template match="entry">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="entry/content">
    <xsl:variable name="o" select="../@o" />
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get/ObjectCategorization/none/{$o}" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="AssetList">
    <xsl:variable name="o" select="ancestor::entry/@o"/>
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:copy copy-namespaces="no">
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/AssetList/master_global/{$o}" />
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/AssetList/{$l}/{$o}" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ObjectAssetList">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:for-each-group select="FeatureLogo|FeatureImage|KeyBenefitArea/Feature" group-by="FeatureCode">
      <xsl:for-each select="current-group()">
        <xsl:if test="position() = 1">
          <i:include xmlns:i="http://apache.org/cocoon/include/1.0"
                     src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{current-grouping-key()}" />
          <i:include xmlns:i="http://apache.org/cocoon/include/1.0" 
                     src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{current-grouping-key()}" />
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each-group>
    <xsl:for-each select=" Award[@AwardType='global']/AwardCode
                          |AccessoryByPacked/AccessoryByPackedCode
                          |NamingString/MasterBrand/BrandCode
                          |NamingString/Partner/PartnerBrand/BrandCode
                          |NamingString/Concept/ConceptCode
                          |SystemLogo/SystemLogoCode
                          |PartnerLogo/PartnerLogoCode">
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{.}" />
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{.}" />
    </xsl:for-each>
  </xsl:template>
    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>