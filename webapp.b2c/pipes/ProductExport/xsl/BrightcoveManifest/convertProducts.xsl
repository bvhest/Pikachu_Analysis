<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:my="http://www.philips.com/local" 
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
  extension-element-prefixes="cmc2-f my asset-f">
  
  <xsl:param name="doctypesfilepath" />
  <xsl:param name="channel" />
  <xsl:param name="type" />
  <xsl:param name="asset-syndication" />
  <xsl:param name="broker-level" />
  <xsl:param name="system" />
  <xsl:param name="exportdate" />
  <xsl:param name="full" />

  <xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl" />
  <xsl:import href="../../../../pipes/common/xsl/xUCDM-external-assets.xsl" />
  <xsl:import href="file.function.xsl" />

  <xsl:variable name="doctypes" select="document('../../../../cmc2/xml/doctype_attributes.xml')/doctypes" />
  <xsl:variable name="domains" select="document('../../../../cmc2/xml/countryDomains.xml')/domains" />

  <xsl:variable name="publisher-id" select="'23648075001'" />
  <xsl:variable name="preparer" select="'Philips'" />
  <xsl:variable name="report-success" select="'TRUE'" />
  <xsl:variable name="overlay-update" select="'TRUE'" />
  <xsl:variable name="active" select="'TRUE'" />
  <xsl:variable name="notification-email-list" select="('cmst@philips.com','pikachu.b2c.support@philips.com','freek.segers@philips.com')" />

  <xsl:template match="/root">
    <xsl:element name="publisher-upload-manifest">
      <xsl:attribute name="publisher-id" select="$publisher-id" />
      <xsl:attribute name="preparer" select="$preparer" />
      <xsl:attribute name="report-success" select="$report-success" />
      <xsl:for-each select="$notification-email-list">
        <xsl:element name="notify">
          <xsl:attribute name="email" select="." />
        </xsl:element>
      </xsl:for-each>
      <xsl:apply-templates select="sql:rowset" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="sql:rowset[@name='Product']">
    <xsl:apply-templates mode="titles" />
  </xsl:template>

  <xsl:template match="sql:row" mode="titles">
    <xsl:variable name="brightcoveVideoDoctypes" select="$doctypes/doctype[@BrightcoveAssets='yes'][@suffix=('mp4','flv')]/@code" />
    <!-- title -->
    <xsl:apply-templates select="sql:data/Product/AssetList/Asset[ResourceType=$brightcoveVideoDoctypes][Md5]" mode="ProductTitle" />
    <!-- title -->
    <xsl:apply-templates select="sql:data/Product/ObjectAssetList/Object/Asset[ResourceType=$brightcoveVideoDoctypes][Md5]" mode="FeatureObjectTitle" />
  </xsl:template>

  <xsl:template match="Asset" mode="Asset">
    <xsl:param name="type" />
    <xsl:param name="id" />
    <xsl:variable name="filename" select="my:get-file-name($id, .)" />
    <xsl:variable name="encode-to" select="upper-case(substring-after($filename,'.'))" />
    <xsl:element name="asset">
      <xsl:attribute name="filename" select="$filename" />
      <xsl:attribute name="refid" select="concat($filename, '-', Md5 )" />
      <xsl:attribute name="size" select="Extent" />
      <xsl:attribute name="hash-code" select="Md5" />
      <xsl:attribute name="ccr-filepath" select="substring-after(InternalResourceIdentifier,'mprdata/')" />
      <xsl:attribute name="mimeType" select="Format" />
      <xsl:if test="$type='VIDEO_FULL'">
        <xsl:attribute name="encode-to" select="$encode-to" />
        <xsl:attribute name="encode-multiple" select="'true'" />
        <xsl:attribute name="h264-preserve-as-rendition" select="'true'" />
      </xsl:if>
      <xsl:attribute name="type" select="$type" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="Asset" mode="ProductTitle">
    <xsl:variable name="Product" select="../.." />
    <xsl:variable name="Row" select="$Product/../.." />
    <xsl:variable name="id" select="$Product/CTN" />
    <xsl:variable name="video-full-dt" select="./ResourceType" />
    <xsl:variable name="video-still-dt" select="$doctypes/doctype[@code=$video-full-dt]/@Preview" />
    <xsl:variable name="thumbnail-dt" select="$doctypes/doctype[@code=$video-full-dt]/@Thumbnail" />
    <xsl:variable name="video-still-asset" select="../Asset[ResourceType=$video-still-dt]" />
    <xsl:variable name="thumbnail-asset" select="../Asset[ResourceType=$thumbnail-dt]" />
    <xsl:variable name="locale" select="if (Language != '') then Language else 'global'" />
    <xsl:variable name="catalogtype" select="$Row/sql:categorization_catalogtype" />

    <xsl:apply-templates select="../Asset[ResourceType=$video-full-dt]" mode="Asset">
      <xsl:with-param name="type" select="'VIDEO_FULL'" />
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>
    <xsl:apply-templates select="../Asset[ResourceType=$video-still-dt]" mode="Asset">
      <xsl:with-param name="type" select="'VIDEO_STILL'"/>
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>
    <xsl:apply-templates select="../Asset[ResourceType=$thumbnail-dt]" mode="Asset">
      <xsl:with-param name="type" select="'THUMBNAIL'" />
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>

    <xsl:element name="title">
      <xsl:attribute name="name" select="cmc2-f:formatFullProductName($Product/NamingString)" />
      <xsl:attribute name="refid" select="concat(cmc2-f:escape-scene7-id($id),'-',$video-full-dt,'-',$locale,'-001')" />
      <xsl:attribute name="active" select="$active" />
      <xsl:attribute name="start-date" select="$Row/sql:sop" />
      <xsl:attribute name="end-date" select="$Row/sql:eop" />
      <xsl:attribute name="video-full-refid" select="concat(my:get-file-name($id, .),'-', Md5)" />
      <xsl:if test="$video-still-asset">
        <xsl:attribute name="video-still-refid" select="concat(my:get-file-name($id, $video-still-asset),'-', $video-still-asset/Md5)" />
      </xsl:if>
      <xsl:if test="$thumbnail-asset">
        <xsl:attribute name="thumbnail-refid" select="concat(my:get-file-name($id, $thumbnail-asset),'-', $thumbnail-asset/Md5)" />
      </xsl:if>
      <xsl:attribute name="language" select="$locale" />
      <xsl:attribute name="overlay-update" select="$overlay-update" />
      <xsl:element name="short-description">
        <xsl:value-of select="$Product/WOW" />
      </xsl:element>
      <xsl:element name="long-description">
        <xsl:value-of select="$Product/MarketingTextHeader" />
      </xsl:element>
      <xsl:element name="related-link-url">
        <xsl:value-of select="asset-f:buildProductDetailPageUrl(., $Row/sql:locale, $system, $catalogtype, $domains )" />
      </xsl:element>
      <xsl:element name="related-link-text">
        <xsl:value-of select="$Product/ProductName" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>CTN=</xsl:text>
        <xsl:value-of select="$Product/CTN" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>locale=</xsl:text>
        <xsl:value-of select="$Row/sql:locale" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>BasicType=</xsl:text>
        <xsl:value-of select="substring-before($Product/CTN,'/')" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Doctype=</xsl:text>
        <xsl:value-of select="$video-full-dt" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>MD5=</xsl:text>
        <xsl:value-of select="./Md5" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Owner=PHILIPS</xsl:text>
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Share=Premium</xsl:text>
      </xsl:element>
      <xsl:call-template name="Categorization-Tags">
        <xsl:with-param name="Row" select="$Row" />
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Asset" mode="FeatureObjectTitle">
    <!-- jdb test code -->	
    <!-- xsl:variable name="id" select="concat('tst_',../id)"/-->
    <xsl:variable name="id" select="../id" />
    <xsl:variable name="video-full-dt" select="./ResourceType" />
    <xsl:variable name="video-still-dt" select="$doctypes/doctype[@code=$video-full-dt]/@Preview" />
    <xsl:variable name="thumbnail-dt" select="$doctypes/doctype[@code=$video-full-dt]/@Thumbnail" />
    <xsl:variable name="video-still-asset" select="../Asset[ResourceType=$video-still-dt]" />
    <xsl:variable name="thumbnail-asset" select="../Asset[ResourceType=$thumbnail-dt]" />
    <xsl:variable name="locale" select="if (Language != '') then Language else 'global'" />
    <xsl:variable name="Row" select="../../../../.." />
    <xsl:variable name="Product" select="../../.." />
    <!-- jdb test code -->
    <!-- xsl:variable name="ctn" select="concat('tst_',$Product/CTN)"/-->
    <xsl:variable name="ctn" select="$Product/CTN" />
    <xsl:variable name="Feature" select="$Product/KeyBenefitArea/Feature[FeatureCode=$id]" />
    <xsl:variable name="catalogtype" select="$Row/sql:categorization_catalogtype" />

    <xsl:apply-templates select="../Asset[ResourceType=$video-full-dt]" mode="Asset">
      <xsl:with-param name="type" select="'VIDEO_FULL'" />
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>
    <xsl:apply-templates select="../Asset[ResourceType=$video-still-dt]" mode="Asset">
      <xsl:with-param name="type" select="'VIDEO_STILL'" />
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>
    <xsl:apply-templates select="../Asset[ResourceType=$thumbnail-dt]" mode="Asset">
      <xsl:with-param name="type" select="'THUMBNAIL'" />
      <xsl:with-param name="id" select="$id" />
    </xsl:apply-templates>

    <xsl:element name="title">
      <xsl:attribute name="name" select="$Feature/FeatureName" />
      <xsl:attribute name="refid" select="concat(cmc2-f:escape-scene7-id($id),'-',$video-full-dt,'-',$locale,'-001')" />
      <xsl:attribute name="active" select="$active" />
      <xsl:attribute name="start-date" select="$Row/sql:sop" />
      <xsl:attribute name="end-date" select="$Row/sql:eop" />
      <xsl:attribute name="video-full-refid" select="concat(my:get-file-name($id, .),'-',Md5)" />
      <xsl:if test="$video-still-asset">
        <xsl:attribute name="video-still-refid" select="concat(my:get-file-name($id, $video-still-asset),'-', $video-still-asset/Md5)" />
      </xsl:if>
      <xsl:if test="$thumbnail-asset">
        <xsl:attribute name="thumbnail-refid" select="concat(my:get-file-name($id, $thumbnail-asset),'-', $thumbnail-asset/Md5)" />
      </xsl:if>
      <xsl:attribute name="language" select="Asset[ResourceType='FML']/Language" />
      <xsl:attribute name="overlay-update" select="$overlay-update" />
      <xsl:element name="short-description">
        <xsl:value-of select="$Feature/FeatureLongDescription" />
      </xsl:element>
      <xsl:element name="long-description">
        <xsl:value-of select="$Feature/FeatureGlossary" />
      </xsl:element>
      <xsl:element name="related-link-url">
        <xsl:value-of select="asset-f:buildProductDetailPageUrl($Product, $Row/sql:locale, $system, $catalogtype, $domains )" />
      </xsl:element>
      <xsl:element name="related-link-text">
        <xsl:value-of select="$Product/ProductName" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>FeatureCode=</xsl:text>
        <xsl:value-of select="$id" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>CTN=</xsl:text>
        <xsl:value-of select="$ctn" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>locale=</xsl:text>
        <xsl:value-of select="$Row/sql:locale" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>BasicType=</xsl:text>
        <xsl:value-of select="substring-before($ctn,'/')" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Doctype=</xsl:text>
        <xsl:value-of select="$video-full-dt" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>MD5=</xsl:text>
        <xsl:value-of select="Md5" />
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Owner=PHILIPS</xsl:text>
      </xsl:element>
      <xsl:element name="tag">
        <xsl:text>Share=Premium</xsl:text>
      </xsl:element>
      <xsl:call-template name="Categorization-Tags">
        <xsl:with-param name="Row" select="$Row" />
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template name="Categorization-Tags">
    <xsl:param name="Row" />
    <xsl:element name="tag">
      <xsl:text>CMC-group=</xsl:text>
      <xsl:value-of select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='MASTER']/sql:groupcode" />
    </xsl:element>
    <xsl:element name="tag">
      <xsl:text>CMC-cat=</xsl:text>
      <xsl:value-of select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='MASTER']/sql:categorycode" />
    </xsl:element>
    <xsl:element name="tag">
      <xsl:text>CMC-subcat=</xsl:text>
      <xsl:value-of select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='MASTER']/sql:subcategorycode" />
    </xsl:element>
    <!-- Take the first CONSUMER categorization group -->
    <xsl:for-each select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='CONSUMER'][not(sql:groupcode=preceding-sibling::sql:row/sql:groupcode)]/sql:groupcode">
      <xsl:element name="tag">
        <xsl:text>Website-group=</xsl:text>
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:for-each>
    <!-- Take the first CONSUMER categorization category -->
    <xsl:for-each select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='CONSUMER'][not(sql:categorycode=preceding-sibling::sql:row/sql:categorycode)]/sql:categorycode">
      <xsl:element name="tag">
        <xsl:text>Website-cat=</xsl:text>
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:for-each>
    <!-- Take all CONSUMER categorization subcategories (?) -->
    <xsl:for-each select="$Row/sql:rowset[@name='cat']/sql:row[sql:catalogcode='CONSUMER']/sql:subcategorycode">
      <xsl:element name="tag">
        <xsl:text>Website-subcat=</xsl:text>
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
