<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" exclude-result-prefixes="sql xsl cinclude" extension-element-prefixes="cmc2-f">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="broker-level">5</xsl:param>
  <xsl:param name="include-keyvaluepairs">no</xsl:param>
  <xsl:variable name="vbroker-level" select="if($broker-level = 'min') then number(-1) else if($broker-level = '') then number(5) else number($broker-level)"/>
  <!-- -->
  <xsl:template match="/Products">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="Product"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="CTN"/>
      <xsl:if test="$vbroker-level ge 0">
        <xsl:copy-of select="Code12NC"/>
        <xsl:copy-of select="GTIN"/>
      </xsl:if>
      <xsl:copy-of select="MarketingVersion"/>
      <xsl:copy-of select="MarketingStatus"/>
      <xsl:copy-of select="CRDate"/>
      <xsl:copy-of select="CRDateYW"/>
      <xsl:copy-of select="ModelYears"/>
      <xsl:copy-of select="ProductDivision"/>
      <xsl:copy-of select="ProductOwner"/>
      <xsl:if test="$vbroker-level ge 0">
        <xsl:copy-of select="DTN"/>
        <xsl:copy-of select="Catalog"/>
        <xsl:copy-of select="Categorization"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 0">
        <xsl:copy-of select="Assets"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 0">
        <xsl:copy-of select="ProductName"/>
        <xsl:copy-of select="FullProductName"/>
        <xsl:call-template name="NamingString">
          <xsl:with-param name="ns" select="."/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:copy-of select="WOW"/>
        <xsl:copy-of select="SubWOW"/>
        <xsl:copy-of select="MarketingTextHeader"/>
        <xsl:for-each select="KeyBenefitArea">
          <xsl:call-template name="KeyBenefitArea">
            <xsl:with-param name="kba" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 3">
        <xsl:copy-of select="SystemLogo[SystemLogoCode = ../Assets/Asset/@code]"/>
        <xsl:copy-of select="PartnerLogo[PartnerLogoCode = ../Assets/Asset/@code]"/>
        <xsl:copy-of select="FeatureLogo[FeatureCode = ../Assets/Asset/@code]"/>
        <xsl:copy-of select="FeatureImage[FeatureCode = ../Assets/Asset/@code]"/>
        <xsl:copy-of select="FeatureHighlight[FeatureCode = ../Assets/Asset/@code]"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:copy-of select="CSChapter"/>
      </xsl:if>
      <Filters>
        <xsl:if test="$vbroker-level ge 2">
          <xsl:copy-of select="Filters/Purpose"/>
        </xsl:if>
      </Filters>
      <xsl:copy-of select="FeatureCompareGroups"/>
      <Disclaimers>
        <xsl:if test="$vbroker-level ge 2">
          <xsl:copy-of select="Disclaimers/Disclaimer"/>
        </xsl:if>
      </Disclaimers>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:copy-of select="AccessoryByPacked"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:for-each select="Award[@AwardType=('global','global_highlight')]">
          <xsl:call-template name="Award">
            <xsl:with-param name="award" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:copy-of select="ProductReference"/>
        <xsl:copy-of select="SellingUpFeature"/>
        <xsl:copy-of select="ConsumerSegment"/>
      </xsl:if>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:if test="$include-keyvaluepairs = 'yes'">
        <xsl:copy-of select="KeyValuePairs"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- BLOCK by default -->
  <xsl:template match="RichTexts"/>
  <!-- -->
  <xsl:template name="NamingString">
    <xsl:param name="ns"/>
    <NamingString>
      <xsl:if test="$vbroker-level ge 0">
        <xsl:copy-of select="$ns/NamingString/MasterBrand"/>
        <xsl:if test="Partner/PartnerBrand">
          <Partner>
            <xsl:copy-of select="$ns/NamingString/Partner/PartnerBrand"/>
            <xsl:copy-of select="$ns/NamingString/Partner/PartnerBrandType"/>
            <xsl:if test="$vbroker-level ge 2">
              <xsl:copy-of select="$ns/NamingString/Partner/PartnerProductName"/>
              <xsl:copy-of select="$ns/NamingString/Partner/PartnerProductIdentifier"/>
            </xsl:if>
          </Partner>
        </xsl:if>
        <xsl:copy-of select="$ns/NamingString/BrandString"/>
        <xsl:copy-of select="$ns/NamingString/BrandString2"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 1">
        <xsl:copy-of select="$ns/NamingString/Concept"/>
        <xsl:copy-of select="$ns/NamingString/Family"/>
        <xsl:copy-of select="$ns/NamingString/Range"/>
        <xsl:copy-of select="$ns/NamingString/BrandString2"/>
        <xsl:copy-of select="$ns/NamingString/Descriptor"/>
        <xsl:copy-of select="$ns/NamingString/Alphanumeric"/>
        <xsl:copy-of select="$ns/NamingString/VersionElement1"/>
        <xsl:copy-of select="$ns/NamingString/VersionElement2"/>
        <xsl:copy-of select="$ns/NamingString/VersionElement3"/>
        <xsl:copy-of select="$ns/NamingString/VersionElement4"/>
        <xsl:copy-of select="$ns/NamingString/VersionString"/>
        <xsl:copy-of select="$ns/NamingString/BrandedFeatureCode1"/>
        <xsl:copy-of select="$ns/NamingString/BrandedFeatureCode2"/>
      </xsl:if>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:copy-of select="$ns/NamingString/BrandedFeatureString"/>
        <xsl:copy-of select="$ns/NamingString/DescriptorBrandedFeatureString"/>
      </xsl:if>
    </NamingString>
  </xsl:template>
  <!-- -->
  <xsl:template name="KeyBenefitArea">
    <xsl:param name="kba"/>
    <KeyBenefitArea>
      <xsl:copy-of select="$kba/KeyBenefitAreaCode"/>
      <xsl:copy-of select="$kba/KeyBenefitAreaName"/>
      <xsl:copy-of select="$kba/KeyBenefitAreaRank"/>
      <xsl:if test="$vbroker-level ge 3">
        <xsl:copy-of select="$kba/Feature"/>
      </xsl:if>
    </KeyBenefitArea>
  </xsl:template>
  <!-- -->
  <!--xsl:template name="Feature">
    <xsl:param name="feature"/>
    <Feature>
      <xsl:copy-of select="$feature/FeatureCode"/>
      <xsl:copy-of select="$feature/FeatureReferenceName"/>
      <xsl:copy-of select="$feature/FeatureName"/>
      <xsl:copy-of select="$feature/FeatureShortDescription"/>
      <xsl:copy-of select="$feature/FeatureLongDescription"/>
      <xsl:if test="$vbroker-level ge 2">
        <xsl:copy-of select="$feature/FeatureGlossary"/>
        <xsl:copy-of select="$feature/FeatureWhy"/>
        <xsl:copy-of select="$feature/FeatureWhat"/>
        <xsl:copy-of select="$feature/FeatureHow"/>
      </xsl:if>
      <xsl:copy-of select="$feature/FeatureRank"/>
      <xsl:copy-of select="$feature/FeatureTopRank"/>
    </Feature>
  </xsl:template-->
  <!-- -->
  <xsl:template name="Award">
    <xsl:param name="award"/>
    <Award>
      <xsl:copy-of select="$award/@AwardType"/>
      <xsl:copy-of select="$award/AwardCode"/>
      <xsl:copy-of select="$award/AwardName"/>
      <xsl:copy-of select="$award/AwardDate"/>
      <xsl:copy-of select="$award/AwardPlace"/>
      <xsl:copy-of select="$award/Title"/>
      <xsl:copy-of select="$award/Issue"/>
      <xsl:copy-of select="$award/Rating"/>
      <xsl:copy-of select="$award/Trend"/>
      <xsl:copy-of select="$award/AwardAuthor"/>
      <xsl:copy-of select="$award/TestPros"/>
      <xsl:copy-of select="$award/TestCons"/>
      <xsl:copy-of select="$award/AwardDescription"/>
      <xsl:copy-of select="$award/AwardAcknowledgement"/>
      <xsl:copy-of select="$award/AwardVerdict"/>
      <xsl:copy-of select="$award/Award"/>
      <xsl:copy-of select="$award/Locales"/>
      <xsl:copy-of select="$award/AwardRank"/>
      <xsl:copy-of select="$award/SourceCode"/>
      <xsl:copy-of select="$award/Video"/>
      <xsl:copy-of select="$award/Category"/>
      <xsl:copy-of select="$award/SourceLocale"/>
    </Award>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>