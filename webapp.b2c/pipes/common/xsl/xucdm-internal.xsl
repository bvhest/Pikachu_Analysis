<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"  
    exclude-result-prefixes="cinclude sql"
    extension-element-prefixes="cmc2-f">

  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
    
  <xsl:param name="islatin"/>
  <xsl:param name="locale"/>
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="sql:language|sql:division"/>
  
  <xsl:template match="Product">
    <xsl:variable name="p-locale" select="if ($locale != '') then $locale else if (@Locale != '') then @Locale else ancestor::sql:row/sql:locale"/>
    <Product>
      <xsl:apply-templates select="@*[not(local-name() = ('lastModified','masterLastModified','Brand','Division','Locale'))]"/>
      <xsl:attribute name="Locale" select="$p-locale"/>
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
      <xsl:attribute name="Brand" select="NamingString/MasterBrand/BrandCode"/>
      <xsl:if test="ProductDivision/FormerPDCode">
        <xsl:attribute name="Division" select="if(ProductDivision/FormerPDCode='0300')then 'DAP' else 'CE'"/>
      </xsl:if>
      <xsl:if test="@masterLastModified">
        <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))"/>
      </xsl:if>
      <xsl:call-template name="OptionalHeaderAttributes"/>
      <xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="DTN"/>
      <xsl:call-template name="OptionalHeaderData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="$p-locale"/>
        <xsl:with-param name="division" select="../../sql:division"/>
      </xsl:call-template>
      <xsl:call-template name="ProductImage">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="$p-locale"/>
      </xsl:call-template>
      <xsl:call-template name="Assets">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="$p-locale"/>
      </xsl:call-template>
      <xsl:apply-templates select="ProductName"/>
      <xsl:apply-templates select="FullProductName"/>
      <xsl:apply-templates select="SEOProductName"/>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <!-- Deprecated in xUCDM 1.1
      <xsl:apply-templates select="MarketingTextBody"/>
      -->
      <MarketingTextBody/>      
      <xsl:apply-templates select="SupraFeature"/>
      <xsl:apply-templates select="ConsumerSegment"/>    
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
      <xsl:apply-templates select="CSChapter">
        <xsl:sort data-type="number" select="CSChapterRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="Disclaimers"/>
      <xsl:apply-templates select="AccessoryByPacked">
        <xsl:sort data-type="number" select="AccessoryByPackedRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="ReviewStatistics"/>
      <xsl:call-template name="Awards"/>
      <xsl:apply-templates select="ProductRefs/ProductReference"/>
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:apply-templates select="GreenData"/>
      <xsl:apply-templates select="ModelYears"/>    
      <xsl:apply-templates select="Filters"/>    
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="$p-locale"/>
      </xsl:call-template>
    </Product>
  </xsl:template>
  
  <!--+
      | Add rank attribute to GreenChapters and order them.
      | Block the GreenChapters if there are less than three areas.
      +-->
  <xsl:template match="GreenData/GreenChapter">
    <xsl:if test="count(parent::GreenData/GreenChapter) &gt;= 3">
      <xsl:copy-of select="cmc2-f:addGreenChapterRank(.)"/>
    </xsl:if>
  </xsl:template>

  <!--+
      | Add rank attribute to GreenChapters and order them.
      | Block the GreenChapters if there are less than three areas.
      +-->
  <xsl:template match="GreenData/EnergyLabel/ApplicableFor">
    <EnergyClasses>
      <EnergyClass>
        <xsl:apply-templates select="@*|node()"/>
      </EnergyClass>
    </EnergyClasses>
  </xsl:template>

  <!--+
      | Handle Awards.
      | Add "virtual" awards for Philips Green Logo, EcoFlower and BluaAngel for
      | Green 2 and Green 3 products.
      | Reorder Awards for specific placement of EcoFlower, Green Logo and
      | BlueAngel as ranked 2nd, 3rd and 4th.
      +-->
  <xsl:template name="Awards">
    <xsl:variable name="awards">
      <xsl:sequence select="(Award[@AwardType=('global','global_highlight')])[1]"/>
      <xsl:if test="GreenData/EcoFlower[@publish='true' and @isEcoFlowerProduct='true']">
        <xsl:call-template name="create-award">
          <xsl:with-param name="code" select="EcoFlower/Code"/>
          <xsl:with-param name="type" select="'global'"/>
          <xsl:with-param name="name" select="EcoFlower/Name"/>
          <xsl:with-param name="description" select="EcoFlower/LongDescription"/>
          <xsl:with-param name="text" select="EcoFlower/Text"/>
          <xsl:with-param name="acknowledgement" select="''"/>
          <xsl:with-param name="rank" select="2"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="GreenData/PhilipsGreenLogo[@isGreenProduct='true' and @publish='true']">
        <xsl:call-template name="create-award">
          <xsl:with-param name="code" select="GreenData/PhilipsGreenLogo/Code"/>
          <xsl:with-param name="type" select="'global'"/>
          <xsl:with-param name="name" select="GreenData/PhilipsGreenLogo/Name"/>
          <xsl:with-param name="description" select="GreenData/PhilipsGreenLogo/LongDescription"/>
          <xsl:with-param name="text" select="GreenData/PhilipsGreenLogo/Text"/>
          <xsl:with-param name="acknowledgement" select="''"/>
          <xsl:with-param name="rank" select="3"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="GreenData/BlueAngel[@publish='true' and @isBlueAngelProduct='true']">
        <xsl:call-template name="create-award">
          <xsl:with-param name="code" select="BlueAngel/Code"/>
          <xsl:with-param name="type" select="'global'"/>
          <xsl:with-param name="name" select="BlueAngel/Name"/>
          <xsl:with-param name="description" select="BlueAngel/LongDescription"/>
          <xsl:with-param name="text" select="BlueAngel/Text"/>
          <xsl:with-param name="acknowledgement" select="''"/>
          <xsl:with-param name="rank" select="4"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:sequence select="(Award[@AwardType=('global','global_highlight')])[position() gt 1]"/>
      <xsl:sequence select="Award[not(@AwardType=('global','global_highlight'))]"/>
    </xsl:variable>
    <xsl:apply-templates select="$awards/Award"/>
  </xsl:template>

  <xsl:template match="Award">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|AwardCode|AwardName|AwardDescription|AwardText|AwardAcknowledgement"/>
      <AwardRank>
        <xsl:value-of select="position()"/>
      </AwardRank>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template name="create-award">
    <xsl:param name="code" />
    <xsl:param name="type" />
    <xsl:param name="name" />
    <xsl:param name="description" />
    <xsl:param name="text" />
    <xsl:param name="acknowledgement" />
    <xsl:param name="rank" />
    
    <xsl:if test="$type != '' and $code != ''">
      <Award AwardType="{$type}">
        <AwardCode>
          <xsl:value-of select="$code"/>
        </AwardCode>
        <AwardName>
          <xsl:value-of select="$name"/>
        </AwardName>
        <AwardDescription>
          <xsl:value-of select="$description"/>
        </AwardDescription>
        <AwardText>
          <xsl:value-of select="$text"/>
        </AwardText>
        <AwardAcknowledgement>
          <xsl:value-of select="$acknowledgement"/>
        </AwardAcknowledgement>
        <AwardRank>
          <xsl:value-of select="$rank"/>
        </AwardRank>
      </Award>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="StartOfPublication"/>
    <xsl:attribute name="EndOfPublication"/>
  </xsl:template>
  
  <xsl:template name="ProductImage">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <ProductImage>
      <ProductImageFTLURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FTP&amp;alt=1</ProductImageFTLURL>
      <ProductImageEBURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=BPP&amp;alt=1</ProductImageEBURL>
    </ProductImage>
  </xsl:template>
  
  <xsl:template name="Assets">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <Assets>
      <Asset Type="DFU" Description="UserManual">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=DFU&amp;laco=<xsl:value-of select="$language"/>
      </Asset>
      <Asset Type="PSS" Description="Product Specification Sheet (Leaflet)">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=PSS&amp;laco=<xsl:value-of select="$language"/>
      </Asset>
      <Asset Type="FAQ" Description="Frequently asked questions">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FAQ&amp;laco=<xsl:value-of select="$language"/>
      </Asset>
      <Asset Type="TIP" Description="Tips to users">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TIP&amp;laco=<xsl:value-of select="$language"/>
      </Asset>
      <Asset Type="RTP" Description="Product picture front-top-left with reflection 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTP&amp;alt=1</Asset>
      <Asset Type="RTF" Description="Product picture front-top-left with reflection 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTF&amp;alt=1</Asset>
      <Asset Type="TRP" Description="Product picture front-top-right 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRP&amp;alt=1</Asset>
      <Asset Type="TRF" Description="Product picture front-top-right 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRF&amp;alt=1</Asset>
      <Asset Type="RCW" Description="Remote control image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RCW&amp;alt=1</Asset>
      <Asset Type="COW" Description="Connector side image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=COW&amp;alt=1</Asset>
      <!--Asset Type="EEF" Description="Electronics Explained Flash">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=EEF&amp;laco=<xsl:value-of select="$language"/></Asset-->
    </Assets>
  </xsl:template>
  
  <xsl:template match="Disclaimers">
    <xsl:for-each select="Disclaimer">
      <Disclaimer>
        <DisclaimerCode><xsl:value-of select="@code"/></DisclaimerCode>
        <DisclaimerName><xsl:value-of select="DisclaimerText"/></DisclaimerName>
      </Disclaimer>
    </xsl:for-each>
  </xsl:template>  
  <!-- If there is a Family and a Range, delete the Range -->
  <xsl:template match="Range[../Family]"/>  
  <!-- If there is a Family and a Range, use the Family -->  
  <xsl:template match="Family[../Range]">  
    <Family>
      <FamilyCode><xsl:value-of select="FamilyCode"/></FamilyCode>
      <FamilyName><xsl:value-of select="FamilyName"/></FamilyName>
      <!-- If ConceptNameUsed != 1, then set FamilyNameUsed = 1 -->
      <FamilyNameUsed><xsl:value-of select="if(not(../Concept/ConceptNameUsed = 1)) then 1 else 0"/></FamilyNameUsed>
    </Family>  
  </xsl:template>      
  <!-- If there is a Family but no Range, use the Family -->
  <xsl:template match="Family[not(../Range)]">    
        <xsl:if test="not(FamilyName=../MasterBrand/BrandName or FamilyName=../Partner/PartnerBrand/BrandName)">
   <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  </xsl:if>
  </xsl:template>     
    
  <xsl:template match="Range[RangeName='']"/>  
  <!-- If there is a Range but no Family, make the Range look like a Family -->
  <xsl:template match="Range[RangeName!=''][not(../Family)]">  
    <Family>
      <FamilyCode><xsl:value-of select="RangeCode"/></FamilyCode>
      <FamilyName><xsl:value-of select="RangeName"/></FamilyName>
      <!-- Family from a Range always set to not used -->
      <FamilyNameUsed>0</FamilyNameUsed>
    </Family>
  </xsl:template>         
    
<xsl:template match="Concept">
       <xsl:if test="not(ConceptName=../MasterBrand/BrandName or ConceptName=../Partner/PartnerBrand/BrandName)">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  </xsl:if>
  </xsl:template>  
  

  <xsl:template match="ConceptName">
    <ConceptName>
      <xsl:apply-templates select="@*|node()"/>
    </ConceptName>
    <ConceptLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../ConceptCode"/>&amp;doctype=CLL&amp;alt=1</ConceptLogoURL>
  </xsl:template>
  
  <!--xsl:template match="SupraFeature/SupraFeatureName">
    <SupraFeatureName>
    <xsl:apply-templates select="@*|node()"/>
    </SupraFeatureName>
  <SupraFeatureLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SupraFeatureCode"/>&amp;doctype=SFW&amp;alt=1</SupraFeatureLogoURL>
  </xsl:template-->
  
  <xsl:template match="SystemLogoRank">
    <SystemLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </SystemLogoRank>
    <SystemLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SystemLogoCode"/>&amp;doctype=SLW&amp;alt=1</SystemLogoURL>
  </xsl:template>
  
  <xsl:template match="PartnerLogoRank">
    <PartnerLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </PartnerLogoRank>
    <PartnerLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SystemLogoCode"/>&amp;doctype=PLW&amp;alt=1</PartnerLogoURL>
  </xsl:template>
  
  <xsl:template match="FeatureLogoRank">
    <FeatureLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </FeatureLogoRank>
    <FeatureLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../FeatureCode"/>&amp;doctype=FLW&amp;alt=1</FeatureLogoURL>
  </xsl:template>
  
  <xsl:template match="FeatureImageRank">
    <FeatureImageRank>
      <xsl:apply-templates select="@*|node()"/>
    </FeatureImageRank>
    <FeatureImageURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../FeatureCode"/>&amp;doctype=FIP&amp;alt=1</FeatureImageURL>
  </xsl:template>
  
  <xsl:template match="KeyBenefitArea">
    <KeyBenefitArea>
      <xsl:apply-templates select="KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank"/>
      <xsl:apply-templates select="Feature">
        <xsl:sort data-type="number" select="FeatureTopRank"/>
      </xsl:apply-templates>
    </KeyBenefitArea>
  </xsl:template>

  <!-- Do not export suspect values for some elements, as it is likely to be "na", or "-" etc. -->
  <xsl:template match="Feature/FeatureGlossary[string-length(.) &lt; 10]">
    <FeatureGlossary/>
  </xsl:template>
  <xsl:template match="MarketingTextHeader[string-length(.) &lt; 10]">
    <MarketingTextHeader/>
  </xsl:template>

  <xsl:template match="CSChapter">
    <CSChapter>
      <xsl:apply-templates select="CSChapterCode|CSChapterName|CSChapterRank"/>
      <xsl:apply-templates select="CSItem">
        <xsl:sort data-type="number" select="CSItemRank"/>
      </xsl:apply-templates>
    </CSChapter>
  </xsl:template>
  
  <xsl:template match="CSChapter/CSItem">
    <CSItem>
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank|CSItemIsFreeFormat"/>
      <xsl:apply-templates select="CSValue">
        <xsl:sort data-type="number" select="CSValueRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="UnitOfMeasure"/>
    </CSItem>
  </xsl:template>
  
  <xsl:template match="AccessoryByPackedName">
    <AccessoryByPackedName>
      <xsl:apply-templates select="@*|node()"/>
    </AccessoryByPackedName>
    <AccessoryByPackedImageURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../AccessoryByPackedCode"/>&amp;doctype=ABW&amp;alt=1</AccessoryByPackedImageURL>
  </xsl:template>
  
  <xsl:template match="ProductRefs/ProductReference">
    <ProductReferences>
      <xsl:apply-templates select="@*|node()"/>
    </ProductReferences>
  </xsl:template>

  <xsl:template match="AwardAcknowledgement">
    <AwardAcknowledgement>
      <xsl:apply-templates select="@*|node()"/>
    </AwardAcknowledgement>
    <AwardLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../AwardCode"/>&amp;doctype=GAW&amp;alt=1</AwardLogoURL>
  </xsl:template>
  
  <xsl:template name="OptionalHeaderData">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="division"/>
  </xsl:template>
  
  <xsl:template name="OptionalFooterData">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
  </xsl:template>
  
  <xsl:template match="FeatureLogoURL"/>
  
</xsl:stylesheet>
