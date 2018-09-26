<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
      <xsl:variable name="ct" select="@ct"/>
      <xsl:variable name="l"  select="@l"/>
      <xsl:variable name="o"  select="@o"/>
  
    <!-- New OAL relations -->
    <xsl:variable name="newobjectassetlistrelations">
      <xsl:variable name="product" select="content/Product"/>
      <xsl:for-each-group select="$product/FeatureLogo|$product/FeatureImage|$product/KeyBenefitArea/Feature" group-by="FeatureCode">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
      <!-- Include RichText assets -->
      <xsl:for-each-group select="$product/RichTexts/RichText/Item" group-by="@code">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
      <!-- Include Award assets -->
      <xsl:for-each-group select="$product/Award" group-by="AwardCode">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
      <!-- Include ? assets -->
      <xsl:for-each select="$product/AccessoryByPacked/AccessoryByPackedCode
                           |$product/NamingString/MasterBrand/BrandCode
                           |$product/NamingString/Partner/PartnerBrand/BrandCode
                           |$product/NamingString/Concept/ConceptCode
                           |$product/NamingString/Family/FamilyCode
                           |$product/SystemLogo/SystemLogoCode
                           |$product/PartnerLogo/PartnerLogoCode
                           |$product/ProductClusters/ProductCluster/@code">
        <id><xsl:value-of select="."/></id>
      </xsl:for-each>
      <!-- Include Green assets -->
      <xsl:for-each-group select="$product/GreenData/PhilipsGreenLogo[@publish='true']/Code
                                 |$product/GreenData/EcoFlower[@publish='true']/Code" 
                                 group-by="Code">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
    </xsl:variable>  
    <!-- -->
    <!-- New OAL items -->
    <xsl:variable name="newobjectassetitems">
      <xsl:variable name="product" select="content/Product"/>
      <xsl:for-each-group select="$product/Award[AwardSourceCode]" group-by="AwardSourceCode">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
    </xsl:variable>  
    <!-- -->
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
        <xsl:with-param name="newobjectassetitems" select="$newobjectassetitems"/>
      </xsl:apply-templates>
      <secondary>
        <xsl:for-each select="$newobjectassetlistrelations/id">
          <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$l"/>','<xsl:value-of select="$o"/>','ObjectAssetList','master_global','<xsl:value-of select="."/>',1,1</relation>
        </xsl:for-each>
        <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$l"/>','<xsl:value-of select="$o"/>','KeyValuePairs','master_global','<xsl:value-of select="$o"/>',1,1</relation>        
      </secondary>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="content">
    <xsl:param name="newobjectassetlistrelations"/> 
    <xsl:param name="newobjectassetitems"/> 
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
        <xsl:with-param name="newobjectassetitems" select="$newobjectassetitems"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product">
    <xsl:param name="newobjectassetlistrelations"/> 
    <xsl:param name="newobjectassetitems"/> 
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()[not(local-name()='ObjectAssetList')]"/>
      <xsl:apply-templates select="ObjectAssetList">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
        <xsl:with-param name="newobjectassetitems" select="$newobjectassetitems"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList">
    <xsl:param name="newobjectassetlistrelations"/> 
    <xsl:param name="newobjectassetitems"/> 
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="*"/>
      <xsl:for-each select="$newobjectassetlistrelations/id">
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{.}"/>
      </xsl:for-each>
      <xsl:for-each select="$newobjectassetitems/id">
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{.}"/>
      </xsl:for-each>
    </xsl:copy>    
  </xsl:template>
</xsl:stylesheet>

