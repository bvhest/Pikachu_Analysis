<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
      xmlns:local="http://www.philips.com/local"
      xmlns:sql="http://apache.org/cocoon/SQL/2.0"
      xmlns:source="http://apache.org/cocoon/SQL/2.0"
      exclude-result-prefixes="sql source"
      extension-element-prefixes="asset-f">

  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level"/>
  <xsl:param name="system"/>

  <xsl:variable name="doc-types" select="document($doctypesfilepath)/doctypes"/>

  <xsl:variable name="assets-channel">
    <xsl:choose>
      <xsl:when test="$asset-syndication != ''">
        <xsl:value-of select="$asset-syndication"/>
      </xsl:when>
      <xsl:when test="$broker-level != ''">
        <xsl:value-of select="ccncat('SyndicationL', $broker-level)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$channel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/Products">
    <Nodes>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="DocType" select="sql:rowset/sql:row[1]/sql:content_type/text()"/>
      <xsl:attribute name="DocVersion"><xsl:text>xUCDM_treenode_external_1_2.xsd</xsl:text></xsl:attribute>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:data/Node"/>
    </Nodes>
  </xsl:template>

  <!--+
      | 1. Fix Country and Locale
      | 2. Convert Assets
      +-->
  <xsl:template match="Node">
    <xsl:copy>
      <xsl:variable name="locale" select="if (@Locale = '') then ../../sql:localisation else @Locale"/>
      <xsl:variable name="country" select="if (@Country = '') then substring($locale, 4) else @Country"/>
      
      <xsl:if test="empty(@Country)">
        <xsl:attribute name="Country" select="$country"/>
      </xsl:if>
      <xsl:if test="empty(@Locale)">
        <xsl:attribute name="Locale" select="$locale"/>
      </xsl:if>
      
      <xsl:apply-templates select="@*[not(local-name()='isLocalized')]"/>

      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="LifecycleStatus"/>
      <xsl:apply-templates select="Owner"/>
      
      <Assets>
        <xsl:variable name="options">
          <scene7-url-base><xsl:value-of select="$imagepath"/></scene7-url-base>
          <include-caption/>
        </xsl:variable>
        <xsl:sequence select="asset-f:createVirtualAsset(@code,'GAL',$locale, asset-f:buildScene7Url($imagepath, @code, 'GAL', $locale, ''), @lastModified, 'Product gallery image set', '', '')"/>
        <xsl:sequence select="asset-f:createVirtualAsset(@code,'IMS',$locale, asset-f:buildScene7Url($imagepath, @code, 'IMS', $locale, ''), @lastModified, 'Single product shot', '', '')"/>
        <xsl:sequence select="asset-f:createVirtualAsset(@code,'URL',$locale, asset-f:buildFamilyDetailPageUrl(@code, $locale, 'LP_PROF_ATG', $system), @lastModified, 'Family URL', '', '')"/>
        <xsl:sequence select="asset-f:createAssets(@code, AssetList, $doc-types, $assets-channel, @lastModified, $options)"/>
        <!-- Create a CLP asset with a product image if the family doesn't have its own CLP asset -->
        <xsl:if test="empty(AssetList/Asset[ResourceType='CLP'])">
          <xsl:variable name="ctn" select="ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN[1]/text()"/>
          <xsl:if test="$ctn != ''">
            <xsl:sequence select="asset-f:createVirtualAsset(@code,'CLP','global', asset-f:buildScene7Url($imagepath, $ctn, 'GAL', 'global', ''), @lastModified, 'Cluster Lifestyle image - highres 2400x2400', '', '')"/>
          </xsl:if>
        </xsl:if>
        <xsl:sequence select="asset-f:createObjectAssets(ObjectAssetList, $doc-types, $assets-channel, @lastModified, $options)"/>
      </Assets>
      
      <xsl:apply-templates select="Name"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <xsl:apply-templates select="KeyBenefitArea"/>
      <xsl:apply-templates select="CSChapter"/>
      <xsl:apply-templates select="SystemLogo"/>
      <xsl:apply-templates select="Filters"/>
      <xsl:apply-templates select="Award"/>      
      <xsl:apply-templates select="ProductRefs"/>
      <xsl:apply-templates select="RichTexts"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
