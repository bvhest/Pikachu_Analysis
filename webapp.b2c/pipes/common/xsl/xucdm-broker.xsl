<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    exclude-result-prefixes="sql"
    extension-element-prefixes="cmc2-f">
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  <!--  -->
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="sql:language|sql:deleted|sql:deleteafterdate|sql:division|sql:catalogtype|sql:categorization_catalogtype" />
  <!--  -->
  <xsl:template match="Product">
    <Product>
      <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]"/>   
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
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="division" select="../../sql:division"/>
      </xsl:call-template>
      <xsl:call-template name="ProductImage">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      <xsl:call-template name="Assets">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="id" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>        
      </xsl:call-template>
      <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>      
      <xsl:apply-templates select="ProductName"/>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <MarketingTextBody/>      
      <SupraFeature/>
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
      <xsl:call-template name="doAccessories">      
        <xsl:with-param name="cschapters"><csc><xsl:copy-of select="CSChapter"/></csc></xsl:with-param>
        <xsl:with-param name="abp"><abp><xsl:copy-of select="AccessoryByPacked"/></abp></xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="Award[@AwardType=('global','global_highlight')]">
        <xsl:sort data-type="number" select="AwardRank"/>
      </xsl:apply-templates>
      <xsl:call-template name="doProductReference"/>      
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
    </Product>
  </xsl:template>
  <!--  -->
  <xsl:template match="Feature/FeatureGlossary[string-length(.) &lt; 10]">
    <!-- Do not export the value, as it is likely to be "na", or "-" etc. -->
    <FeatureGlossary/>
  </xsl:template>
  <!--  -->    
  <xsl:template match="MarketingTextHeader[string-length(.) &lt; 10]">
    <!-- Do not export the value, as it is likely to be "na", or "-" etc. -->
    <MarketingTextHeader/>
  </xsl:template>      
  <!--  -->  
  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="StartOfPublication"/>
    <xsl:attribute name="EndOfPublication"/>
  </xsl:template>
  <!--  -->
  <xsl:template name="doProductReference">
    <xsl:apply-templates select="ProductReference|ProductReferences|ProductRefs"/> 
  </xsl:template>
  
  <xsl:template match="ProductRefs">
    <xsl:apply-templates select="ProductReference[@ProductReferenceType=('Accessory','Performer','Variation')]"/>
  </xsl:template>

  <xsl:template match="ProductReferences|ProductRefs/ProductReference">
    <xsl:apply-templates select="CTN" mode="prod-ref">
      <xsl:with-param name="type" select="@ProductReferenceType"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="CTN" mode="prod-ref">
    <xsl:param name="type"/>
    <ProductReference ProductReferenceType="{$type}">
      <xsl:copy-of select="."/>
      <ProductReferenceRank><xsl:value-of select="if(@rank) then @rank else 0"/></ProductReferenceRank>
    </ProductReference>
  </xsl:template>
  <!--  -->
  <xsl:template name="doAccessories">    
    <!-- This template overrides the template of the same name in xucdm-product-external -->  
    <xsl:param name="cschapters"/>
    <xsl:param name="abp"/>
    <xsl:variable name="v_abp">
      <!-- Does the product have Accessory(/ies)ByPacked, or pseudo-Accessory(/ies)ByPacked? -->
      <xsl:choose>
        <xsl:when test="$abp/abp/AccessoryByPacked/AccessoryByPackedCode">
          <xsl:apply-templates select="AccessoryByPacked">
            <xsl:sort data-type="number" select="AccessoryByPackedRank"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = '3000815']">
            <!-- CSChapterName[CSChapterCode = '3000815'] = 'Accessories' -->
            <!-- CSItemName[CSItemCode = '3006778'] = 'Included Accessories' -->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006778']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>              
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="CSValueName"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="CSValueName"/></AccessoryByPackedName>
              </AccessoryByPacked>              
            </xsl:for-each>
            <!-- CSItemName[CSItemCode = '3006780'] = 'Included batteries' -->
            <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006780']/CSValue">
              <!--xsl:value-of select="concat($cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006780']/CSItemName,': ')"/-->              
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006780']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>              
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="concat($cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006780']/CSItemName,': ',CSValueName)"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="concat($cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006780']/CSItemName,': ',CSValueName)"/></AccessoryByPackedName>
              </AccessoryByPacked>                                    
            </xsl:for-each>
            </xsl:if>                                    
            <!-- CSItemName[CSItemCode = '3007773'] = 'Standard Package Includes' -->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3007773']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="CSValueName"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="CSValueName"/></AccessoryByPackedName>
              </AccessoryByPacked>  
            </xsl:for-each>
            <!-- CSItemName[CSItemCode = '3006782'] = 'Optional accessories' -->
            <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006782']/CSValue">
              <!--xsl:value-of select="concat('(', $cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006782']/CSItemName,': ')"/-->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006782']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="concat($cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006782']/CSItemName,': ',CSValueName)"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="concat($cschapters/csc/CSChapter[CSChapterCode = '3000815']/CSItem[CSItemCode='3006782']/CSItemName,': ',CSValueName)"/></AccessoryByPackedName>
              </AccessoryByPacked>                
            </xsl:for-each>
          </xsl:if>
          </xsl:if>
          <!-- * -->
          <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = 'CHA_0000008']">
            <!-- CSChapterName[CSChapterCode = 'CHA_0000008'] = 'Accessories' -->
            <!-- CSItemName[CSItemCode = 'S_0000645'] = 'Accessories' -->
            <!-- CSItemName[CSItemCode = 'S_0000943'] = 'Accessories wet cleaning' -->
            <!-- CSItemName[CSItemCode = 'S_0000944'] = 'Accessories dry cleaning' -->
            <!-- CSItemName[CSItemCode = 'IT4002830'] = 'Included accessories' -->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = 'CHA_0000008']/CSItem[CSItemCode = ('S_0000645','S_0000943','S_0000944','IT4002830')]/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="CSValueName"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="CSValueName"/></AccessoryByPackedName>
              </AccessoryByPacked>                
            </xsl:for-each>
          </xsl:if>
          <!-- * -->
          <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = 'CHA_0000009']/CSItem[CSItemCode='S_0000837']">
            <!-- CSChapterName[CSChapterCode = 'CHA_0000009'] = 'General specifications' -->
            <!-- CSItemName[CSItemCode = 'S_0000837'] = 'Accessories' -->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = 'CHA_0000009']/CSItem[CSItemCode='S_0000837']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="CSValueName"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="CSValueName"/></AccessoryByPackedName>
              </AccessoryByPacked>                      
            </xsl:for-each>
          </xsl:if>
          <!-- * -->
          <xsl:if test="$cschapters/csc/CSChapter[CSChapterCode = 'CH4000563']/CSItem[CSItemCode='IT4003411']">
            <!-- CSChapterName[CSChapterCode = 'CH4000563'] = 'Manual cleaning mode' -->
            <!-- CSItemName[CSItemCode = 'IT4003411'] = 'Accessories' -->
            <xsl:for-each select="$cschapters/csc/CSChapter[CSChapterCode = 'CH4000563']/CSItem[CSItemCode='IT4003411']/CSValue">
              <xsl:sort data-type="number" select="CSValueRank" order="ascending"/>
              <AccessoryByPacked>
                <AccessoryByPackedCode><xsl:value-of select="concat('ABPP_',CSValueCode)"/></AccessoryByPackedCode>
                <AccessoryByPackedReference><xsl:value-of select="CSValueName"/></AccessoryByPackedReference>
                <AccessoryByPackedName><xsl:value-of select="CSValueName"/></AccessoryByPackedName>
              </AccessoryByPacked>                
            </xsl:for-each>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$abp/abp/AccessoryByPacked/AccessoryByPackedCode">
        <xsl:copy-of select="$v_abp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$v_abp/AccessoryByPacked">
          <xsl:copy>
            <xsl:copy-of select="AccessoryByPackedCode"/>
            <xsl:copy-of select="AccessoryByPackedReference"/>
            <xsl:copy-of select="AccessoryByPackedName"/>
            <AccessoryByPackedRank><xsl:value-of select="position()"/></AccessoryByPackedRank>              
          </xsl:copy>              
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:template>      
  <!--  -->  
  <xsl:template name="ProductImage">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <ProductImage>
      <ProductImageFTLURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FTP&amp;alt=1</ProductImageFTLURL>
      <ProductImageEBURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=BPP&amp;alt=1</ProductImageEBURL>
    </ProductImage>
  </xsl:template>
  <!--  -->
  <xsl:template name="Assets">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
    <xsl:variable name="url" select="concat($imagepath,replace($ctn,'/','_'),'-IMS-global')"/>
    <Assets>
      <Asset Type="DFU" Description="UserManual">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=DFU&amp;laco=<xsl:value-of select="replace($locale,'_','')"/>
      </Asset>
      <Asset Type="PSS" Description="Product Specification Sheet (Leaflet)">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=PSS&amp;laco=<xsl:value-of select="replace($locale,'_','')"/>
      </Asset>
      <Asset Type="FAQ" Description="Frequently asked questions">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FAQ&amp;laco=<xsl:value-of select="replace($locale,'_','')"/>
      </Asset>
      <Asset Type="TIP" Description="Tips to users">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TIP&amp;laco=<xsl:value-of select="replace($locale,'_','')"/>
      </Asset>
      <Asset Type="RTP" Description="Product picture front-top-left with reflection 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTP&amp;alt=1</Asset>
      <Asset Type="RTF" Description="Product picture front-top-left with reflection 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTF&amp;alt=1</Asset>
      <Asset Type="TRP" Description="Product picture front-top-right 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRP&amp;alt=1</Asset>
      <Asset Type="TRF" Description="Product picture front-top-right 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRF&amp;alt=1</Asset>
      <Asset Type="RCW" Description="Remote control image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RCW&amp;alt=1</Asset>
      <Asset Type="COW" Description="Connector side image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=COW&amp;alt=1</Asset>
      <Asset Type="IMS" Description="Single product shot"><xsl:value-of select="$url"/></Asset>
      <!--Asset Type="EEF" Description="Electronics Explained Flash">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=EEF&amp;laco=<xsl:value-of select="$language"/></Asset-->
    </Assets>
  </xsl:template>
  <!--  -->
  <xsl:template match="Disclaimers">
    <xsl:for-each select="Disclaimer">
      <Disclaimer>
        <DisclaimerCode><xsl:value-of select="@code"/></DisclaimerCode>
        <DisclaimerName><xsl:value-of select="DisclaimerText"/></DisclaimerName>
      </Disclaimer>
    </xsl:for-each>
  </xsl:template>  
  <!--  -->  
  <xsl:template match="Family">
    <Concept>
      <ConceptCode><xsl:value-of select="FamilyCode"/></ConceptCode>
      <ConceptName><xsl:value-of select="FamilyName"/></ConceptName>
      <ConceptLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="FamilyCode"/>&amp;doctype=CLL&amp;alt=1</ConceptLogoURL>
      <ConceptNameUsed><xsl:value-of select="FamilyNameUsed"/></ConceptNameUsed>
      <IsFamily>1</IsFamily>
    </Concept>  
  </xsl:template>
  <!--  -->    
  <xsl:template match="ConceptName">
    <ConceptName>
      <xsl:apply-templates select="@*|node()"/>
    </ConceptName>
    <ConceptLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../ConceptCode"/>&amp;doctype=CLL&amp;alt=1</ConceptLogoURL>
  </xsl:template>
  <!--  -->
  <!--xsl:template match="SupraFeature/SupraFeatureName">
    <SupraFeatureName>
		<xsl:apply-templates select="@*|node()"/>
    </SupraFeatureName>
	<SupraFeatureLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SupraFeatureCode"/>&amp;doctype=SFW&amp;alt=1</SupraFeatureLogoURL>
  </xsl:template-->
  <!--  -->
  <xsl:template match="SystemLogoRank">
    <SystemLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </SystemLogoRank>
    <SystemLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SystemLogoCode"/>&amp;doctype=SLW&amp;alt=1</SystemLogoURL>
  </xsl:template>
  <!--  -->
  <xsl:template match="PartnerLogoRank">
    <PartnerLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </PartnerLogoRank>
    <PartnerLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../SystemLogoCode"/>&amp;doctype=PLW&amp;alt=1</PartnerLogoURL>
  </xsl:template>
  <!--  -->
  <xsl:template match="FeatureLogoRank">
    <FeatureLogoRank>
      <xsl:apply-templates select="@*|node()"/>
    </FeatureLogoRank>
    <FeatureLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../FeatureCode"/>&amp;doctype=FLW&amp;alt=1</FeatureLogoURL>
  </xsl:template>
  <!--  -->
  <xsl:template match="FeatureImageRank">
    <FeatureImageRank>
      <xsl:apply-templates select="@*|node()"/>
    </FeatureImageRank>
    <FeatureImageURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../FeatureCode"/>&amp;doctype=FIP&amp;alt=1</FeatureImageURL>
  </xsl:template>
  <!--  -->
  <xsl:template match="KeyBenefitArea">
    <KeyBenefitArea>
      <xsl:apply-templates select="KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank"/>
      <xsl:apply-templates select="Feature">
        <xsl:sort data-type="number" select="FeatureTopRank"/>
      </xsl:apply-templates>
    </KeyBenefitArea>
  </xsl:template>
  <!--  -->
  <xsl:template match="Feature">
    <Feature>
      <xsl:apply-templates select="FeatureCode|FeatureName|FeatureShortDescription|FeatureLongDescription|FeatureGlossary|FeatureRank|FeatureTopRank"/>
    </Feature>
  </xsl:template>
  <!--  -->
  <xsl:template match="FeatureHighlight">
    <FeatureHighlight>
      <xsl:apply-templates select="FeatureCode|FeatureHighlightRank"/>
    </FeatureHighlight>
  </xsl:template>  
  <!--  -->
  <xsl:template match="CSChapter">
    <CSChapter>
      <xsl:apply-templates select="CSChapterCode|CSChapterName|CSChapterRank"/>
      <xsl:apply-templates select="CSItem">
        <xsl:sort data-type="number" select="CSItemRank"/>
      </xsl:apply-templates>
    </CSChapter>
  </xsl:template>
  <!--  -->
  <xsl:template match="CSItem">
    <CSItem>
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank"/>
      <xsl:apply-templates select="CSValue">
        <xsl:sort data-type="number" select="CSValueRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="UnitOfMeasure"/>
    </CSItem>
  </xsl:template>
  <!--  -->
  <xsl:template match="AccessoryByPackedName">
    <AccessoryByPackedName>
      <xsl:apply-templates select="@*|node()"/>
    </AccessoryByPackedName>
    <AccessoryByPackedImageURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../AccessoryByPackedCode"/>&amp;doctype=ABW&amp;alt=1</AccessoryByPackedImageURL>
  </xsl:template>
  <!--  -->
  <xsl:template match="AwardAcknowledgement">
    <AwardAcknowledgement>
      <xsl:apply-templates select="@*|node()"/>
    </AwardAcknowledgement>
    <AwardLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../AwardCode"/>&amp;doctype=GAW&amp;alt=1</AwardLogoURL>
  </xsl:template>
  <!--  -->
  <xsl:template name="OptionalHeaderData">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="division"/>
  </xsl:template>
  <!--  -->
  <xsl:template name="OptionalFooterData">
    <xsl:param name="ctn"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="FeatureLogoURL"/>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
