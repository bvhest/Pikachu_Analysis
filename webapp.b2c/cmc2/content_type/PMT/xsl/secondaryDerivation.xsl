<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry/secondary">
    <xsl:copy copy-namespaces="no">
      <!--xsl:apply-templates select="@*|node()"/-->
      <xsl:variable name="object" select="../@o"/>
      <xsl:variable name="ct" select="../@ct"/>
      <xsl:variable name="locale" select="../@l"/>
      <xsl:for-each select="currentrelations/sql:rowset/sql:row[sql:input_content_type='RichText'][sql:data/object/RichTexts]">      
        <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','RichText','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>',1,1</relation>
      </xsl:for-each>
      <xsl:for-each select="../content/Product">
        <xsl:variable name="product" select="."/>
        <xsl:for-each-group select="FeatureLogo|FeatureImage|KeyBenefitArea/Feature" group-by="FeatureCode">
          <xsl:for-each select="current-group()">
            <xsl:if test="position() = 1">
              <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','master_global','<xsl:value-of select="FeatureCode"/>',1,1</relation>
              <xsl:if test="$product/ObjectAssetList/Object[id=current()/FeatureCode]/Asset[Language = $locale]">
                <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','<xsl:value-of select="$locale"/>','<xsl:value-of select="FeatureCode"/>',1,1</relation>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each-group>

		<!-- added for gifting -->
        <xsl:for-each-group select="RichTexts/RichText/Item" group-by="@code">
            <xsl:for-each select="current-group()">
              <xsl:if test="position() = 1">
                <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','master_global','<xsl:value-of select="current-grouping-key()"/>',1,1</relation>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each-group>
        
        <xsl:for-each-group select=" Award/AwardCode
                              |AccessoryByPacked/AccessoryByPackedCode
                              |NamingString/MasterBrand/BrandCode
                              |NamingString/Partner/PartnerBrand/BrandCode                      
                              |NamingString/Concept/ConceptCode
                              |NamingString/Family/FamilyCode                              
                              |SystemLogo/SystemLogoCode
                              |PartnerLogo/PartnerLogoCode
                              |ProductClusters/ProductCluster/@code
                              |GreenData/PhilipsGreenLogo[@publish='true']/Code
                              |GreenData/*[name() = ('EnergyLabel', 'EcoFlower', 'BlueAngel')][@publish='true']/ApplicableFor/Code
                              " group-by=".">
          <xsl:variable name="key" select="current-grouping-key()"/>
          <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','master_global','<xsl:value-of select="$key"/>',1,1</relation>
          <xsl:if test="$product/ObjectAssetList/Object[id=$key]/Asset[Language = $locale]">
            <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','<xsl:value-of select="$locale"/>','<xsl:value-of select="$key"/>',1,1</relation>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
