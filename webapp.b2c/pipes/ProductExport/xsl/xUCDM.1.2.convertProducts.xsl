<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:sql="http://apache.org/cocoon/SQL/2.0"
      xmlns:cinclude="http://apache.org/cocoon/include/1.0"
      xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
      xmlns:local="http://www.philips.com/local"
      exclude-result-prefixes="sql xsl cinclude"
      extension-element-prefixes="asset-f local">
      
  <xsl:import href="../../common/xsl/xucdm-product-external-v1.2.xsl"/>
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>

  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="secureURL"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level" select="''"/>
  <xsl:param name="system"/>

  <xsl:variable name="assetschannel">
    <xsl:choose>
      <xsl:when test="$channel = 'FSSProducts'">FSS</xsl:when>
      <xsl:when test="$channel = 'AtgProducts'">ATG</xsl:when>      
      <xsl:when test="$channel = 'AtgGifting'">ATG</xsl:when>      
      <xsl:when test="$channel = 'AtgPCTProducts'">ATG_PCT</xsl:when>      
      <xsl:when test="$asset-syndication != ''">
        <xsl:value-of select="$asset-syndication"/>
      </xsl:when>
      <xsl:when test="$broker-level != ''">
        <xsl:value-of select="concat('SyndicationL', $broker-level)"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$channel"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="doctypes" select="document($doctypesfilepath)/doctypes"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>  <!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
  <xsl:variable name="domains" select="document('../../../cmc2/xml/countryDomains.xml')/domains"/>
  
  <xsl:template match="RichText[@type = 'Functionality']"/>
  <xsl:template match="CSValueDescription"/>
     
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:sos|sql:eos|sql:priority|sql:content_type|sql:localisation|sql:catalogtype|sql:categorization_catalogtype"/>
  <xsl:template match="sql:groupcode|sql:groupname|sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <xsl:template match="sql:deleteafterdate|sql:deleted"/>
  <xsl:template match="sql:rowset[@name='cat']"/>
  <xsl:template match="sql:pmt"/>
  <xsl:template match="sql:assetlist"/>
  <xsl:template match="sql:objectassetdata"/>
  <xsl:template match="sql:objectassetid"/>
  <xsl:template match="sql:productreference"/>
  <xsl:template match="sql:ctn"/>

  <xsl:template name="doKeyValuePairs">
    <xsl:choose>
      <xsl:when test="$type = 'locale'">
        <xsl:apply-templates select="KeyValuePairs/KeyValuePair|KeyValuePair"/>
      </xsl:when>
      <xsl:when test="$type = 'masterlocale'">
        <!-- use PMT -->
        <xsl:apply-templates select="../../sql:pmt/Product/KeyValuePairs/KeyValuePair|../../sql:pmt/Product/KeyValuePair"/>
      </xsl:when>
      <xsl:when test="$type = 'master'">
        <!-- use PMT_Master -->
        <xsl:apply-templates select="KeyValuePairs/KeyValuePair|KeyValuePair"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="doProductReference">
    <xsl:choose>
      <xsl:when test="$type = 'masterlocale'">
        <xsl:apply-templates select="../../sql:pmt/Product/ProductRefs/*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="ProductRefs/*|ProductReference"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Fix ProductReferenceType attributes -->
  <xsl:template match="@ProductReferenceType[.='hasChassis']">
    <xsl:attribute name="ProductReferenceType" select="'Chassis'"/>
  </xsl:template>
  <xsl:template match="@ProductReferenceType[.='isRefurbishedProductOf']">
    <xsl:attribute name="ProductReferenceType" select="'RefurbishedOf'"/>
  </xsl:template>
  
  <xsl:template name="doAssets">
    <!-- This template overrides the template of the same name in xucdm-product-external -->
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="catalogtype"/>
    
    <xsl:variable name="secureurlflag" select="../../sql:secureurlflag"/>
        
    <xsl:variable name="options">
      <scene7-url-base><xsl:value-of select="$imagepath"/></scene7-url-base>
      <include-extent/>
      <xsl:if test="$secureURL ='yes' and $secureurlflag ='yes'">
      	<secureURL>yes</secureURL>
      </xsl:if>  
    </xsl:variable>
    
    <Assets>
      <xsl:choose>
        <xsl:when test="$type = 'locale'">
          <!-- Product assets -->
          <xsl:sequence select="asset-f:createAssets($id, AssetList, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS',$locale, asset-f:buildScene7Url($imagepath, $id, 'IMS', $locale, ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL',$locale, asset-f:buildScene7Url($imagepath, $id, 'GAL', $locale, ''), $lastModified, 'Product gallery image set', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'URL',$locale, asset-f:buildProductDetailPageUrl(., $locale, $system, $catalogtype, $domains), $lastModified, 'Product URL', '', '')"/>
          
          <xsl:if test="$system='PikachuB2B'">
            <xsl:apply-templates select="ProductClusters/ProductCluster[@type='family']" mode="family-detail-page-assets">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="lastModified" select="$lastModified"/>
              <xsl:with-param name="locale" select="$locale"/>
              <xsl:with-param name="catalogtype" select="$catalogtype"/>
            </xsl:apply-templates>
          </xsl:if>
          
          <!-- Object assets -->
          <xsl:sequence select="asset-f:createObjectAssets(ObjectAssetList, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
        <xsl:when test="$type = 'masterlocale'">
          <!-- Product assets -->
          <xsl:sequence select="asset-f:createAssets($id, ../../sql:pmt/Product/AssetList, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS',$locale, asset-f:buildScene7Url($imagepath, $id, 'IMS', $locale, ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL',$locale, asset-f:buildScene7Url($imagepath, $id, 'GAL', $locale, ''), $lastModified, 'Product gallery image set', '', '')"/>
          <!-- Object assets -->
          <xsl:sequence select="asset-f:createObjectAssets(../../sql:pmt/Product/ObjectAssetList, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
        <xsl:when test="$type = 'master'">
          <!-- Product assets -->
          <xsl:variable name="assetlist">
            <xsl:copy-of select="AssetList/Asset[Language='' or Language = 'en_US' or Language='global']"/>
          </xsl:variable>
          <xsl:sequence select="asset-f:createAssets($id, $assetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
          <!-- Virtual assets -->
          <xsl:sequence select="asset-f:createVirtualAsset($id,'IMS','global', asset-f:buildScene7Url($imagepath, $id, 'IMS', 'global', ''), @lastModified, 'Single product shot', '', '')"/>
          <xsl:sequence select="asset-f:createVirtualAsset($id,'GAL','global', asset-f:buildScene7Url($imagepath, $id, 'GAL', 'global', ''), $lastModified, 'Product gallery image set', '', '')"/>
          <!-- Object assets -->
          <xsl:variable name="objectassetlist">
            <xsl:for-each select="ObjectAssetList/Object[exists(Asset[Language='' or Language = 'en_US' or Language='global'])]">
              <Object>
                <xsl:copy-of select="id|Asset[Language='' or Language = 'en_US' or Language='global']"/>
              </Object>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="asset-f:createAssets($id, $objectassetlist, $doctypes, $assetschannel, $lastModified, $options)"/>
        </xsl:when>
      </xsl:choose>
    </Assets>
  </xsl:template>

  <xsl:template match="ProductCluster" mode="family-detail-page-assets">
    <xsl:param name="id"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="locale"/>
    <xsl:param name="catalogtype"/>
    <xsl:variable name="url" select="asset-f:createVirtualAsset($id,'ORL',$locale, asset-f:buildFamilyDetailPageUrl(@code, $locale, $catalogtype, $system), $lastModified, 'Related URL', '', '')"/>
    <xsl:if test="$url != ''">
      <xsl:sequence select="$url"/>
    </xsl:if>
  </xsl:template>
    
</xsl:stylesheet>
