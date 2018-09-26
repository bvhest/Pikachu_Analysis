<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                extension-element-prefixes="cmc2-f"
                exclude-result-prefixes="sql xsl cinclude data" 
            > 

  <!--  base the transformation on the default xUCDM transformation -->
   <!-- <xsl:import href="../../../common/xsl/xucdm-product-external.xsl"/>
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:include href="../../../../cmc2/xsl/common/cmc2.function.xsl"/> -->
   <xsl:import href="../xUCDM.1.1.convertProducts.xsl" />
   <!-- ETL -->
    
    <xsl:param name="doctypesfilepath"/>
    <xsl:param name="type"/>
    <xsl:param name="channel"/>
    <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level" select="''"/>
  <xsl:param name="system" select="'PikachuB2C'"/>
  
 <!--  <xsl:variable name="assetschannel">
    <xsl:choose>
     
     
      <xsl:when test="$broker-level != ''">
        <xsl:value-of select="concat('SyndicationL', $broker-level)"/>
      </xsl:when>
     
    </xsl:choose>
  </xsl:variable> -->
   
  <!-- ETL -->
    <xsl:template match="Products">
    <Products>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:apply-templates select="node()"/>
    </Products>
  </xsl:template>
 <xsl:template match="Product">
    <Product>
    <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]"/>
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
      <xsl:if test="@masterLastModified">
        <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))"/>
      </xsl:if>
      <xsl:call-template name="OptionalHeaderAttributes"/>
      <xsl:call-template name="OptionalHeaderData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="division" select="../../sql:division"/>
      </xsl:call-template>
      <xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>
      <xsl:apply-templates select="ModelYears"/>
      <xsl:apply-templates select="ProductDivision"/>
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="DTN"/>
      <xsl:apply-templates select="ProductType"/>
      <xsl:call-template name="docatalogdata">
        <xsl:with-param name="sop" select="ancestor::sql:row/sql:sop"/>
        <xsl:with-param name="eop" select="ancestor::sql:row/sql:eop"/>
        <xsl:with-param name="sos" select="ancestor::sql:row/sql:sos"/>
        <xsl:with-param name="eos" select="ancestor::sql:row/sql:eos"/>
        <xsl:with-param name="lgp" select="ancestor::sql:row/sql:local_going_price"/>
        <xsl:with-param name="rank" select="ancestor::sql:row/sql:priority"/>
        <xsl:with-param name="deleted" select="ancestor::sql:row/sql:deleted"/>
        <xsl:with-param name="deleteafterdate" select="ancestor::sql:row/sql:deleteafterdate"/>
      </xsl:call-template>
      <xsl:call-template name="docategorization">
        <xsl:with-param name="cats" select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row"/>
      </xsl:call-template>
      <xsl:call-template name="doAssets">
        <xsl:with-param name="id" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
        <xsl:with-param name="catalogtype" select="../../sql:catalogtype"/>
      </xsl:call-template>
      <xsl:apply-templates select="ProductName"/>
      <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <xsl:apply-templates select="KeyBenefitArea">
        <xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="SystemLogo">
        <xsl:sort data-type="number" select="SystemLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="PartnerLogo">
        <xsl:sort data-type="number" select="PartnerLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureLogo">
        <xsl:sort data-type="number" select="FeatureLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureImage">
        <xsl:sort data-type="number" select="FeatureImageRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureHighlight">
        <xsl:sort data-type="number" select="FeatureHighlightRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="CSChapter[CSItem]">
        <xsl:sort data-type="number" select="CSChapterRank"/>
      </xsl:apply-templates>
      <xsl:call-template name="doFilters"/>
      <xsl:apply-templates select="FeatureCompareGroups"/>
      <xsl:apply-templates select="Disclaimers"/>
      <xsl:call-template name="doAccessories">
        <xsl:with-param name="cschapters"><csc><xsl:copy-of select="CSChapter"/></csc></xsl:with-param>
        <xsl:with-param name="abp"><abp><xsl:copy-of select="AccessoryByPacked"/></abp></xsl:with-param>
      </xsl:call-template>
      <!-- Green2 modification -->
      <xsl:call-template name="doAwards">
        <xsl:with-param name="Awards"><xsl:copy-of select="Award[not(@AwardType=$exclude-award-types)]"/></xsl:with-param>
      </xsl:call-template>
      <!-- end Green2 -->
      <xsl:call-template name="doProductReference"/>
      <xsl:apply-templates select="SellingUpFeature"/>
      <xsl:apply-templates select="ConsumerSegment"/>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:call-template name="doKeyValuePairs"/>
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
  
  </Product>
  </xsl:template>
  
</xsl:stylesheet>