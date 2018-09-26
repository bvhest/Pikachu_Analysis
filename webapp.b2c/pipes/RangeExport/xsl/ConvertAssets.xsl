<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
    exclude-result-prefixes="sql"
    extension-element-prefixes="asset-f">
    
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level"/>
  
  <xsl:variable name="assets-channel" select="if ($asset-syndication!='') then $asset-syndication 
                                         else if ($broker-level != '') then concat('SyndicationL', $broker-level)
                                         else 'FSS'"/>
  <xsl:variable name="doc-types" select="document($doctypesfilepath)/doctypes"/>
  <xsl:variable name="image-path" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Node">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|MarketingVersion|MarketingStatus|LifecycleStatus|Owner"/>

      <Assets>
        <xsl:variable name="options">
          <scene7-url-base><xsl:value-of select="$image-path"/></scene7-url-base>
          <include-extent/>
        </xsl:variable>
        <!-- Node assets -->
        <xsl:sequence select="asset-f:createAssets(@code, AssetList, $doc-types, $assets-channel, @lastModified, $options)"/>
        <!-- Object assets -->
        <xsl:sequence select="asset-f:createObjectAssets(ObjectAssetList, $doc-types, $assets-channel, @lastModified, $options)"/>
        
        <xsl:variable name="locale">
          <xsl:choose>
                <xsl:when test="@Locale != ''"><xsl:value-of select="@Locale"/></xsl:when>
                <xsl:otherwise>global</xsl:otherwise>
            </xsl:choose>  
          </xsl:variable>
        
        <!-- Add IMS for the products -->
        <xsl:for-each select="ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN
                            | ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product/@ctn">
          <xsl:sequence select="asset-f:createVirtualAsset(.,'IMS',$locale
                                        , asset-f:buildScene7Url($image-path, ., 'IMS', $locale, '')
                                        , ancestor::Node/@lastModified, 'Single product shot', '', '')" />
        </xsl:for-each>
      </Assets>
      <xsl:apply-templates select="Name|WOW|SubWOW|MarketingTextHeader|KeyBenefitArea|CSChapter|SystemLogo|Filters|Award|ProductRefs|RichTexts"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>