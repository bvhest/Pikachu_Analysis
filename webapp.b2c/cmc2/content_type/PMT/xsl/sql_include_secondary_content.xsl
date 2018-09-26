<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">
  
  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:import href="base.xsl"/>
  
  <xsl:variable name="includesec">yes</xsl:variable>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry/content/octl/sql-rowset/sql-row[sql-content_type='PMT_Translated']/sql-data/Product">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="NamingString/Range">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="$includesec='yes'">
        <xsl:sequence select="cmc2-f:get-octl-sql(RangeCode, 'RangeText', $l)"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="RichTexts">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:variable name="o" select="ancestor::entry/@o"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="$includesec='yes'">
        <xsl:sequence select="cmc2-f:get-octl-sql($o, 'RichText', $l)"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Disclaimers">
    <xsl:copy-of select="." />
    <xsl:copy-of select="../KeyValuePairs" />
    <xsl:copy-of select="../AccessoryByPacked" />
    <!-- ReviewStatistics will be populated from Award -->
    <ReviewStatistics/>
    <xsl:copy-of select="../Award"/>
    <!-- include PMA Awards -->
    <Award>
      <xsl:variable name="l" select="ancestor::entry/@l"/>
      <xsl:variable name="o" select="ancestor::entry/@o"/>
      <xsl:if test="$includesec='yes'">
        <xsl:sequence select="cmc2-f:get-octl-sql($o, 'PMA', $l)"/>
      </xsl:if>
    </Award>
  </xsl:template>
  <!-- -->
  <xsl:template match="KeyValuePairs|AccessoryByPacked|Award"/>  <!-- copied above, after Disclaimers -->
  
  <xsl:template match="ObjectAssetList">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:for-each-group select="../FeatureLogo|../FeatureImage|../KeyBenefitArea/Feature" group-by="FeatureCode">
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1 and $includesec='yes'">
            <xsl:if test="$l-master-assets-from = 'assetlist'">
              <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
            </xsl:if>
            <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>

      <!-- added for gifting -->
      <xsl:for-each-group select="../RichTexts/RichText/Item" group-by="@code">
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1 and $includesec='yes'">
            <xsl:if test="$l-master-assets-from = 'assetlist'">
              <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
            </xsl:if>
            <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>
      
      <!-- deleted Award/AwardCode below -->
      <xsl:for-each-group select=" ../AccessoryByPacked/AccessoryByPackedCode
                            |../NamingString/MasterBrand/BrandCode
                            |../NamingString/Partner/PartnerBrand/BrandCode
                            |../NamingString/Concept/ConceptCode
                            |../NamingString/Family/FamilyCode
                            |../SystemLogo/SystemLogoCode
                            |../PartnerLogo/PartnerLogoCode
                            |../ProductClusters/ProductCluster/@code"
                          group-by=".">
        <xsl:if test="$includesec='yes'">
          <xsl:if test="$l-master-assets-from = 'assetlist'">
            <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
          </xsl:if>
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
        </xsl:if>
      </xsl:for-each-group>
      
      <!-- Green awards -->
      <xsl:for-each-group select="../GreenData/PhilipsGreenLogo[@publish='true']/Code
                                 |../GreenData/EnergyLabel[@publish='true']/EnergyClasses/EnergyClass[1]/Code
                                 |../GreenData/*[name() = ('EnergyLabel', 'EcoFlower', 'BlueAngel')][@publish='true']/ApplicableFor[1]/Code"
                          group-by=".">
        <xsl:if test="$includesec='yes'">
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
        </xsl:if>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
