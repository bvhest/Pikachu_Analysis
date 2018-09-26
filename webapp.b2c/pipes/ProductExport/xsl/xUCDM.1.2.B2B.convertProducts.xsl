<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0" 
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    xmlns:local="http://www.philips.com/local"
    exclude-result-prefixes="sql xsl cinclude"
    extension-element-prefixes="cmc2-f asset-f local">
    
  <xsl:import href="xUCDM.1.2.convertProducts.xsl" />
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl" />
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>

  <xsl:variable name="doc-types" select="document($doctypesfilepath)/doctypes" />
  <!--
    1. Wrap KeyBenefitArea in KeyBenefitAreas
    2. Wrap Feature in Features.
    3. Wrap SystemLogo in SystemLogos
    4. Wrap PartnerLogo in PartnerLogos
    5. Wrap FeatureLogo in FeatureLogos
    6. Wrap FeatureImage in FeatureImages
    7. Wrap FeatureHighlight in FeatureHighlights
    8. Wrap CSChapter in CSChapters
    9. Wrap CSItem in CSItems
    10. Wrap CSValue in CSValues
    11. Wrap AccessoryByPacked in AccessoryByPackeds (?)
    12. Wrap Award in Awards.
  -->
  <xsl:template match="Product" exclude-result-prefixes="cinclude sql dir">
    <Product>
      <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]" />
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))" />
      <xsl:if test="@masterLastModified">
        <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))" />
      </xsl:if>
      <xsl:call-template name="OptionalHeaderAttributes" />
      <xsl:call-template name="OptionalHeaderData">
        <xsl:with-param name="ctn" select="CTN" />
        <xsl:with-param name="language" select="../../sql:language" />
        <xsl:with-param name="locale" select="@Locale" />
        <xsl:with-param name="division" select="../../sql:division" />
      </xsl:call-template>
      <xsl:apply-templates select="CTN" />
      <xsl:apply-templates select="Code12NC" />
      <xsl:apply-templates select="GTIN" />
      <xsl:apply-templates select="ProductType" />
      <xsl:apply-templates select="MarketingVersion" />
      <!-- BHE (30/9/2009): include empty elements for mandatory items.
      -->
      <MarketingStatus>
        <xsl:choose>
          <xsl:when test="not(MarketingStatus)">
            <xsl:text>Final Published</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="MarketingStatus" />
          </xsl:otherwise>
        </xsl:choose>
      </MarketingStatus>
      <xsl:apply-templates select="CRDate" />
      <xsl:apply-templates select="CRDateYW" />
      <xsl:apply-templates select="ModelYears" />
      <xsl:apply-templates select="ProductDivision" />
      <xsl:apply-templates select="ProductOwner" />
      <xsl:apply-templates select="DTN" />
      <xsl:call-template name="docatalogdata">
        <xsl:with-param name="sop" select="ancestor::sql:row/sql:sop" />
        <xsl:with-param name="eop" select="ancestor::sql:row/sql:eop" />
        <xsl:with-param name="sos" select="ancestor::sql:row/sql:sos" />
        <xsl:with-param name="eos" select="ancestor::sql:row/sql:eos" />
        <xsl:with-param name="rank" select="ancestor::sql:row/sql:priority" />
        <xsl:with-param name="deleted" select="ancestor::sql:row/sql:deleted" />
        <xsl:with-param name="deleteafterdate" select="ancestor::sql:row/sql:deleteafterdate" />
      </xsl:call-template>
      <xsl:call-template name="docategorization">
        <xsl:with-param name="cats" select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row" />
      </xsl:call-template>
      <xsl:variable name="remove-object-keys-dd"
        select="local:filter-object-keys-dd(RichTexts/RichText[@type='DimensionDiagramTable'], ObjectAssetList)" />
      <xsl:call-template name="doAssets">
        <xsl:with-param name="id" select="CTN" />
        <xsl:with-param name="language" select="../../sql:language" />
        <xsl:with-param name="locale" select="@Locale" />
        <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))" />
        <xsl:with-param name="catalogtype" select="../../sql:catalogtype" />
        <xsl:with-param name="remove-object-keys-dd" select="$remove-object-keys-dd" />
      </xsl:call-template>
      <xsl:apply-templates select="ProductName" />
      <xsl:apply-templates select="FullProductName"/>
      <xsl:apply-templates select="NamingString" />
      <xsl:apply-templates select="ShortDescription" />
      <xsl:apply-templates select="WOW" />
      <xsl:apply-templates select="SubWOW" />
      <xsl:apply-templates select="MarketingTextHeader" />
      <KeyBenefitAreas>
        <xsl:apply-templates select="KeyBenefitArea">
          <xsl:sort data-type="number" select="KeyBenefitAreaRank" />
        </xsl:apply-templates>
      </KeyBenefitAreas>
      <SystemLogos>
        <xsl:apply-templates select="SystemLogo">
          <xsl:sort data-type="number" select="SystemLogoRank" />
        </xsl:apply-templates>
      </SystemLogos>
      <PartnerLogos>
        <xsl:apply-templates select="PartnerLogo">
          <xsl:sort data-type="number" select="PartnerLogoRank" />
        </xsl:apply-templates>
      </PartnerLogos>
      <FeatureLogos>
        <xsl:apply-templates select="FeatureLogo">
          <xsl:sort data-type="number" select="FeatureLogoRank" />
        </xsl:apply-templates>
      </FeatureLogos>
      <FeatureImages>
        <xsl:apply-templates select="FeatureImage">
          <xsl:sort data-type="number" select="FeatureImageRank" />
        </xsl:apply-templates>
      </FeatureImages>
      <FeatureHighlights>
        <xsl:apply-templates select="FeatureHighlight">
          <xsl:sort data-type="number" select="FeatureHighlightRank" />
        </xsl:apply-templates>
      </FeatureHighlights>
      <CSChapters>
        <xsl:apply-templates select="CSChapter[CSItem]">
          <xsl:sort data-type="number" select="CSChapterRank" />
        </xsl:apply-templates>
      </CSChapters>
      <Filters>
        <xsl:apply-templates select="Filters/Purpose" />
      </Filters>
      <!-- BHE: mandatory element FeatureCompareGroups 
      -->
      <FeatureCompareGroups>
        <xsl:apply-templates select="FeatureCompareGroups/FeatureCompareGroup" />
      </FeatureCompareGroups>
      <!-- BHE: mandatory element Disclaimers 
      -->
      <Disclaimers>
        <xsl:apply-templates select="Disclaimers/Disclaimer" />
      </Disclaimers>
      <!-- BHE: new order KeyValuePairs in tree & element is mandatory -->
      <KeyValuePairs>
        <xsl:call-template name="doKeyValuePairs" />
      </KeyValuePairs>
      <AccessoryByPackeds>
        <xsl:call-template name="doAccessories">
          <xsl:with-param name="cschapters">
            <csc>
              <xsl:copy-of select="CSChapter" />
            </csc>
          </xsl:with-param>
          <xsl:with-param name="abp">
            <abp>
              <xsl:copy-of select="AccessoryByPacked" />
            </abp>
          </xsl:with-param>
        </xsl:call-template>
      </AccessoryByPackeds>
      <Awards>
        <xsl:apply-templates select="Award">
          <xsl:sort data-type="number" select="AwardRank" />
        </xsl:apply-templates>
      </Awards>
      <ProductClusters>
        <xsl:call-template name="ProductCluster" />
      </ProductClusters>
      <ProductRefs>
        <xsl:call-template name="doProductReference" />
      </ProductRefs>
      <xsl:apply-templates select="SellingUpFeature" />
      <xsl:apply-templates select="ConsumerSegment" />
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN" />
        <xsl:with-param name="language" select="../../sql:language" />
        <xsl:with-param name="locale" select="@Locale" />
      </xsl:call-template>
      <xsl:apply-templates select="RichTexts">
        <xsl:with-param name="remove-object-keys-dd" select="$remove-object-keys-dd" />
      </xsl:apply-templates>
    </Product>
  </xsl:template>
  <!-- Wrap Feature elements inside a Features element -->
  <xsl:template match="KeyBenefitArea">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank" />
      <Features>
        <xsl:apply-templates select="Feature" />
      </Features>
    </xsl:copy>
  </xsl:template>
  <!-- Wrap CSItem elements -->
  <xsl:template match="CSChapter">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|CSChapterCode|CSChapterName|CSChapterRank" />
      <CSItems>
        <xsl:apply-templates select="CSItem" />
      </CSItems>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="CSItem[ancestor::CSChapter]">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|CSItemCode|CSItemName|CSItemRank|CSItemIsFreeFormat" />
      <!-- Add CSItemIsFreeFormat if it is missing -->
      <xsl:if test="not(CSItemIsFreeFormat)">
        <CSItemIsFreeFormat>0</CSItemIsFreeFormat>
      </xsl:if>
      <!-- Wrap CSValue elements -->
      <CSValues>
        <xsl:apply-templates select="CSValue" />
      </CSValues>
      <xsl:apply-templates select="UnitOfMeasure" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="RichTexts">
    <xsl:param name="remove-object-keys-dd" />
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="RichText">
        <xsl:with-param name="remove-object-keys-dd" select="$remove-object-keys-dd" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="RichText[@type='DimensionDiagramTable']">
    <xsl:param name="remove-object-keys-dd" />
    <xsl:variable name="rt-items" select="Item[not(@code=$remove-object-keys-dd)]" />
    <xsl:if test="exists($rt-items)">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|$rt-items" />
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template match="RichText[@type!='DimensionDiagramTable']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <!-- Add CLP Asset that points to the product GAL for families that do not have their own CLP Assets -->
  <xsl:template match="ProductCluster/@code" mode="missing-family-clp">
    <xsl:param name="product" />
    <xsl:if test="empty($product/ObjectAssetList/Object[id=current()]/Asset[ResourceType='CLP'])">
      <xsl:sequence
        select="asset-f:createVirtualAsset(.,'CLP','global', asset-f:buildScene7Url($imagepath, $product/CTN, 'GAL', 'global', ''), $product/@lastModified, 'Cluster Lifestyle image - highres 2400x2400', '', '')" />
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="doAssets">
    <!-- This template overrides the template of the same name in xucdm-product-external -->
    <xsl:param name="id" />
    <xsl:param name="language" />
    <xsl:param name="locale" />
    <xsl:param name="lastModified" />
    <xsl:param name="catalogtype" />
    <xsl:param name="remove-object-keys-dd" />

    <xsl:variable name="options">
      <scene7-url-base><xsl:value-of select="$imagepath"/></scene7-url-base>
      <include-caption/>
      <include-extent/>
    </xsl:variable>

    <Assets>
      <xsl:choose>
        <xsl:when test="$type = 'locale'">
          <!-- Product assets -->
          <xsl:variable name="assetlist">
            <xsl:sequence select="AssetList/Asset[ResourceType!='L3D']"/>
          </xsl:variable>
          <xsl:sequence select="asset-f:createAssets($id, $assetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS',$locale, asset-f:buildScene7Url($imagepath, $id, 'IMS', $locale, ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL',$locale, asset-f:buildScene7Url($imagepath, $id, 'GAL', $locale, ''), $lastModified, 'Product gallery image set', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'URL',$locale, asset-f:buildProductDetailPageUrl(., $locale, $system, $catalogtype, $domains), $lastModified, 'Product URL', '', '')"/>
          <!-- Object assets -->
          <xsl:variable name="objectassetlist">
            <xsl:for-each select="ObjectAssetList/Object[not(id=$remove-object-keys-dd)]">
              <Object>
                <xsl:copy-of select="id|Asset"/>
              </Object>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="asset-f:createObjectAssets($objectassetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
        <xsl:when test="$type = 'masterlocale'">
          <!-- Product assets -->
          <xsl:variable name="assetlist">
            <xsl:sequence select="../../sql:pmt/Product/AssetList/Asset[ResourceType!='L3D']"/>
          </xsl:variable>
          <xsl:sequence select="asset-f:createAssets($id, $assetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS', $locale, asset-f:buildScene7Url($imagepath, $id, 'IMS', $locale, ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL', $locale, asset-f:buildScene7Url($imagepath, $id, 'GAL', $locale, ''), $lastModified, 'Product gallery image set', '', '')"/>
          <!-- Object assets -->
          <xsl:variable name="objectassetlist">
            <xsl:for-each select="../../sql:pmt/Product/ObjectAssetList/Object[not(id=$remove-object-keys-dd)]">
              <Object>
                <xsl:copy-of select="id|Asset"/>
              </Object>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="asset-f:createObjectAssets($objectassetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
        <xsl:when test="$type = 'master'">
          <!-- Product assets -->
          <xsl:variable name="assetlist">
            <xsl:sequence select="AssetList/Asset[ResourceType!='L3D'][Language='' or Language = 'en_US' or Language='global']"/>
          </xsl:variable>
          <xsl:sequence select="asset-f:createAssets($id, $assetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS','global', asset-f:buildScene7Url($imagepath, $id, 'IMS', 'global', ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL','global', asset-f:buildScene7Url($imagepath, $id, 'GAL', 'global', ''), $lastModified, 'Product gallery image set', '', '')"/>
          <!-- Object assets -->
          <xsl:variable name="objectassetlist">
            <xsl:for-each select="../../sql:pmt/Product/ObjectAssetList/Object[not(id=$remove-object-keys-dd)][exists(Asset[Language='' or Language = 'en_US' or Language='global'])]">
              <Object>
                <xsl:copy-of select="id|Asset[Language='' or Language = 'en_US' or Language='global']"/>
              </Object>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="asset-f:createObjectAssets($objectassetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
      </xsl:choose>
      <!-- Create a CLP asset with the product gallery image for every family that doesn't have a CLP asset -->
      <xsl:apply-templates select="ProductClusters/ProductCluster[@type='family']/@code" mode="missing-family-clp">
        <xsl:with-param name="product" select="." />
      </xsl:apply-templates>
      
      <!-- Virtual ZIP assets - Asset types are configured in CCR -->
      <!-- ZPI = A1_,A2_,A3_,A4_,A5_,APS,CL_,D1_,D2_,D3_,D4_,D5_,PDP,LPN,PBS,RFT,U1_,U2_,U3_,U4_,U5_,PUP -->
      <xsl:variable name="zpi-ids" select="ProductClusters/ProductCluster[@type='family']/@code"/>
      <xsl:sequence select="asset-f:createVirtualAsset($id,'ZPI',$locale, concat('http://www.p4c.philips.com/cgi-bin/zip.pl?p=ZPI&amp;locale=',$locale,'&amp;d=l4b','&amp;ids=',string-join(($id,$zpi-ids),',')), $lastModified, 'Zip with Product images', '001', 'zip')"/>
      
      <!-- ZPD = CON,GVR,LAD,LAS,LBD,LCA,LCB,LCC,LCD,LCR,LCV,LDR,LDD,LFR,LGU,LLT,LOP,LPC,LPD,LPI,LPW,LPX,LQE,LRU,LSP,LSQ,LUF,LUG,LUT,LVI,LVV,LWD,RFT -->
      <xsl:variable name="zpd-ids" select="RichTexts/RichText[@type='DimensionDiagramTable']/Item/@code"/>
      <xsl:if test="exists($zpd-ids)">
        <xsl:sequence select="asset-f:createVirtualAsset($id,'ZPD',$locale, concat('http://www.p4c.philips.com/cgi-bin/zip.pl?p=ZPD&amp;locale=',$locale,'&amp;d=l4b','&amp;ids=',string-join($zpd-ids,',')), $lastModified, 'Zip with Product diagrams', '001', 'zip')"/>
      </xsl:if>
      <!-- Z3D = 3D1,3D2,...,3D7,RFT -->
      <xsl:variable name="z3d-ids" select="RichTexts/RichText[@type='3DDrawing']/Item/@code"/>
      <xsl:if test="exists($z3d-ids)">
        <xsl:sequence select="asset-f:createVirtualAsset($id,'L3D',$locale, concat('http://www.p4c.philips.com/cgi-bin/zip.pl?p=Z3D&amp;locale=',$locale,'&amp;d=l4b','&amp;ids=',string-join(($id,$z3d-ids),',')), $lastModified, 'Zip with 3D drawings', '001', 'zip')"/>
      </xsl:if>
    </Assets>
  </xsl:template>
  <!--
    Filter dimension diagram object keys to remove 'OXDA','IXDD','OXDA','IXDA' RichTexts and corresponding object assets
    if 'OLDD','ILDD','OLDA','ILDA' diagrams are availiable.
  -->
  <xsl:function name="local:filter-object-keys-dd">
    <xsl:param name="richtexts-dd" />
    <xsl:param name="object-asset-list" />
    <xsl:variable name="dd-pref" select="$richtexts-dd/Item[substring(@referenceName,1,4)=('OLDD','ILDD','OLDA','ILDA')]" />
    <xsl:variable name="dd-backup" select="$richtexts-dd/Item[substring(@referenceName,1,4)=('OXDD','IXDD','OXDA','IXDA','OF3D','IF3D')]" />
    <xsl:variable name="dd-wrong" select="$richtexts-dd/Item[substring(@referenceName,1,4)=('OF3D','IF3D')]" />
    <xsl:variable name="object-keys-dd" select="$object-asset-list/Object[Asset/ResourceType='GVR']/id" />
    <xsl:variable name="dd-pref-code" select="$dd-pref/@code" />
    <xsl:variable name="dd-backup-code" select="$dd-backup/@code" />
    <xsl:variable name="dd-wrong-code" select="$dd-wrong/@code" />
    <xsl:choose>
      <xsl:when test="exists($object-keys-dd)">
        <xsl:choose>
          <xsl:when test="$dd-pref-code and $object-keys-dd=$dd-pref-code">
            <!-- Pref diagram: remove backup codes -->
            <xsl:sequence select="$dd-backup-code" />
          </xsl:when>
          <xsl:otherwise>
            <!-- Remove wrong items -->
            <xsl:sequence select="$dd-wrong-code" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
