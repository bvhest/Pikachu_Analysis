<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:local="http://www.philips.com/local"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                exclude-result-prefixes="sql xsl cinclude"
                extension-element-prefixes="cmc2-f"
                >
  
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  
  <xsl:import href="base.xsl" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  <xsl:template match="octl[@ct=('PMT_Master','AssetList','GreenData')]"/>

  <!--
     | (BHE, 08/09/2011) 
     | modified for Green2-project to conform to the xUCDM_product_marketing_1_3 schema.
     -->
  <xsl:template match="content/octl[@ct='PMT_Translated']/sql:rowset/sql:row/sql:data/Product" exclude-result-prefixes="cinclude sql dir">
    <Product>
      <xsl:apply-templates select="@*[not(local-name()='Status' or local-name()='Brand' or local-name()='Division')]"/>
      <xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:element name="GTIN">
        <!-- Use the GTIN value from the LCB import, otherwise use the one from PFS -->
        <xsl:variable name="catalogGTIN" select="../../sql:gtin"/>
        <xsl:choose>
          <xsl:when test="$catalogGTIN != ''">
            <xsl:value-of select="$catalogGTIN" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="GTIN" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:apply-templates select="ProductType"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="LifecycleStatus"/> <!-- xUCDM 1.2 -->
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>      
      <ModelYears><xsl:apply-templates select="ModelYears/ModelYear"/></ModelYears>
      <xsl:apply-templates select="ProductDivision"/>
      <xsl:apply-templates select="ProductOwner"/>  
      <xsl:apply-templates select="DTN"/>     
      <xsl:apply-templates select="ProductName"/>
      <xsl:apply-templates select="FullProductName"/> <!-- xUCDM 1.2 -->
      <!-- SEO product name with default value from PMT_Master -->
      <SEOProductName locale="{../../sql:localisation}">
        <xsl:value-of select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/SEOProductName"/>
      </SEOProductName>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="LongDescription"/> <!-- xUCDM 1.2 -->
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
      <xsl:apply-templates select="CSChapter">
        <xsl:sort data-type="number" select="CSChapterRank"/>
      </xsl:apply-templates>      
      <!-- Filters -->
      <xsl:choose>
        <xsl:when test="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/Filters">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/Filters"/>
        </xsl:when>
        <xsl:when test="Filters">
          <xsl:apply-templates select="Filters"/>
        </xsl:when>
        <xsl:otherwise>      
          <Filters>
            <Purpose type="Comparison">
              <Features>
                <xsl:apply-templates select="KeyBenefitArea/Feature" mode="Filters">
                  <xsl:sort data-type="number" select="FeatureTopRank"/>
                </xsl:apply-templates>
              </Features>                
              <CSItems>
                <xsl:apply-templates select="CSChapter/CSItem" mode="Filters">
                  <xsl:sort data-type="number" select="CSItemRank"/>
                </xsl:apply-templates>
              </CSItems>                         
            </Purpose>
            <Purpose type="Detail">
              <Features>
                <xsl:apply-templates select="KeyBenefitArea/Feature" mode="Filters">
                  <xsl:sort data-type="number" select="FeatureTopRank"/>
                </xsl:apply-templates>
              </Features>                
              <CSItems>
                <xsl:apply-templates select="CSChapter/CSItem" mode="Filters">
                  <xsl:sort data-type="number" select="CSItemRank"/>
                </xsl:apply-templates>
              </CSItems>                  
            </Purpose>            
          </Filters>
        </xsl:otherwise>        
      </xsl:choose>
      <FeatureCompareGroups><xsl:apply-templates select="FeatureCompareGroups/FeatureCompareGroup"/></FeatureCompareGroups>            
      <xsl:choose>
        <xsl:when test="Disclaimers">
          <xsl:copy-of select="Disclaimers"/>
        </xsl:when>
        <xsl:otherwise>
          <Disclaimers>
            <xsl:for-each select="Disclaimer">
              <xsl:variable name="dCode" select="DisclaimerCode"/>
              <Disclaimer code="{$dCode}" referenceName="{$dCode}">   
                <DisclaimerText><xsl:value-of select="DisclaimerName"/></DisclaimerText>                          
                <DisclaimElements/>    
              </Disclaimer>
            </xsl:for-each>
          </Disclaimers>
        </xsl:otherwise>
      </xsl:choose>      
      <!-- KeyValuePairs -->
      <xsl:choose>     
        <xsl:when test="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/KeyValuePairs">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/KeyValuePairs"/>
        </xsl:when>
        <xsl:when test="KeyValuePairs">
          <xsl:apply-templates select="KeyValuePairs"/>
        </xsl:when>
        <xsl:otherwise>
          <KeyValuePairs/>
        </xsl:otherwise>
      </xsl:choose>         
      <xsl:apply-templates select="AccessoryByPacked">
        <xsl:sort data-type="number" select="AccessoryByPackedRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="Award">
        <xsl:sort data-type="number" select="AwardRank"/>
      </xsl:apply-templates>  
      <!-- Product References -->
      <xsl:choose>
        <xsl:when test="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/ProductRefs">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/ProductRefs"/>
        </xsl:when>
        <xsl:when test="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/ProductReferences">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/ProductReferences"/>   
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ProductRefs"/>
          <xsl:apply-templates select="ProductReferences"/>
        </xsl:otherwise>
      </xsl:choose>   
      <xsl:apply-templates select="ProductClusters"/> 
      <!-- Rich Text -->
      <RichTexts>
        <xsl:apply-templates select="RichTexts/RichText"/>
      </RichTexts>
      <!-- GreenData -->
      <xsl:apply-templates select="GreenData"/> 
      <!-- Product Assets -->
      <xsl:variable name="locale" select="../../sql:localisation"/>
      <xsl:variable name="productIsLocalized" select="@IsLocalized='true' " />
      <AssetList>
        <xsl:apply-templates select="ancestor::content/octl[@ct='AssetList']/sql:rowset/sql:row[sql:content_type='AssetList']/sql:data/object/Asset"/>
        <xsl:choose>
          <xsl:when test="substring($locale,1,2)='en' or $productIsLocalized">
            <xsl:if test="$l-master-assets-from = 'masterdata'">
            <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/AssetList/Asset[not(Language='en_US' and ResourceType='PSS')]  "/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise> 
            <xsl:if test="$l-master-assets-from = 'masterdata'">
            <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/AssetList/Asset "/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </AssetList>   
      <ObjectAssetList>
        <xsl:if test="$l-master-assets-from = 'masterdata'">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/ObjectAssetList/Object"/>
        </xsl:if>
      </ObjectAssetList>
    </Product>
  </xsl:template>
  
  <xsl:template match="NamingString">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="MasterBrand"/>
      <xsl:apply-templates select="Partner"/>
      <xsl:apply-templates select="BrandString"/>
      <xsl:apply-templates select="BrandString2"/>
      <xsl:apply-templates select="Concept"/>
      <xsl:apply-templates select="Family"/>
      <xsl:choose>
        <xsl:when test="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString/Range">
          <xsl:apply-templates select="ancestor::content/octl[@ct='PMT_Master']/sql:rowset/sql:row[sql:content_type='PMT_Master']/sql:data/Product/NamingString/Range"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="Range"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="Descriptor"/>
      <xsl:apply-templates select="Alphanumeric"/>
      <xsl:apply-templates select="VersionElement1"/>
      <xsl:apply-templates select="VersionElement2"/>
      <xsl:apply-templates select="VersionElement3"/>
      <xsl:apply-templates select="VersionElement4"/>
      <xsl:apply-templates select="VersionString"/>
      <xsl:apply-templates select="BrandedFeatureCode1"/>
      <xsl:apply-templates select="BrandedFeatureCode2"/>
      <xsl:apply-templates select="BrandedFeatureString"/>
      <xsl:apply-templates select="DescriptorBrandedFeatureString"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="attribute::IsMaster">
    <xsl:attribute name="IsMaster" select="'false'"/>
  </xsl:template>
  
  <xsl:template match="ProductDivision">
    <ProductDivision>
      <xsl:choose>
        <xsl:when test="ProductDivisionCode='0200' or ProductDivisionCode='0100'">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <ProductDivisionCode>0200</ProductDivisionCode>
          <ProductDivisionName>Consumer Lifestyle</ProductDivisionName>
          <FormerPDCode><xsl:value-of select="ProductDivisionCode"/></FormerPDCode>
        </xsl:otherwise>          
      </xsl:choose>
    </ProductDivision>
  </xsl:template>
  
  <!--  remove &lt;not applicable&gt;-->
  <xsl:template match="ConceptName[text()='&lt;not applicable&gt;']">
    <ConceptName/>
  </xsl:template>
  <!--  remove &lt;not applicable&gt;-->
  <xsl:template match="SupraFeatureName[text()='&lt;not applicable&gt;']">
    <SupraFeatureName/>
  </xsl:template>
          
  <xsl:template match="Feature" mode="Filters">
      <xsl:variable name="fc" select="FeatureCode[1]"/>
     <xsl:variable name="fic" select="../../FeatureImage[starts-with(FeatureCode,$fc)]/FeatureCode"/>
    <Feature>
       <xsl:choose>
          <xsl:when test="$fic"><xsl:attribute name="code"><xsl:value-of select="$fic"/></xsl:attribute></xsl:when>
          <xsl:otherwise><xsl:attribute name="code"><xsl:value-of select="$fc"/></xsl:attribute></xsl:otherwise>
      <xsl:attribute name="referenceName" select="FeatureReferenceName"/>      
      <xsl:attribute name="rank" select="FeatureTopRank"/>            
      </xsl:choose>
    </Feature>
  </xsl:template>  
    
  <xsl:template match="CSItem" mode="Filters">
    <CSItem>
      <xsl:attribute name="code" select="CSItemCode"/>
      <xsl:attribute name="referenceName" select="concat(ancestor::CSChapter/CSChapterName, ' - ', CSItemName)"/>      
      <xsl:attribute name="rank" select="CSItemRank"/>            
    </CSItem>
  </xsl:template>  
      
  <xsl:template match="KeyBenefitArea">
    <KeyBenefitArea>
      <xsl:apply-templates select="KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank"/>
      <xsl:apply-templates select="Feature">
        <xsl:sort data-type="number" select="FeatureTopRank"/>
      </xsl:apply-templates>
    </KeyBenefitArea>
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
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank|CSItemDescription|CSItemIsFreeFormat"/>
      <xsl:apply-templates select="CSValue">
        <xsl:sort data-type="number" select="CSValueRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="UnitOfMeasure"/>
    </CSItem>
  </xsl:template>
  
  <xsl:template match="BrandName|BrandString">
    <xsl:element name="{node-name(.)}"><xsl:value-of select="replace(.,'PHILIPS','Philips')"/></xsl:element>       
  </xsl:template>
    
  <xsl:template priority="10" match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <xsl:template match="Concept[IsFamily='1']">
      <Family>
        <FamilyCode><xsl:value-of select="ConceptCode"/></FamilyCode>
        <FamilyName><xsl:value-of select="ConceptName"/></FamilyName>
        <xsl:if test="ConceptNameUsed = 0 or ConceptNameUsed = 1">
        <FamilyNameUsed><xsl:value-of select="ConceptNameUsed"/></FamilyNameUsed>
        </xsl:if>
    </Family>
  </xsl:template>
  
  <xsl:template match="Concept[not(IsFamily='1')]">
      <Concept>
        <ConceptCode><xsl:value-of select="ConceptCode"/></ConceptCode>
        <ConceptName><xsl:value-of select="ConceptName"/></ConceptName>
        <xsl:if test="ConceptNameUsed = 0 or ConceptNameUsed = 1">
        <ConceptNameUsed><xsl:value-of select="ConceptNameUsed"/></ConceptNameUsed>
        </xsl:if>
    </Concept>
  </xsl:template>  
  
  <xsl:template match="SubBrand">   
    <xsl:if test="not(../Partner)">
      <Partner>
        <PartnerBrand>
          <BrandCode><xsl:value-of select="BrandCode"/></BrandCode>
          <BrandName><xsl:value-of select="BrandName"/></BrandName>
        </PartnerBrand>
        <PartnerBrandType>MakersMark</PartnerBrandType>
        <PartnerProductName />
        <PartnerProductIdentifier />
      </Partner>   
    </xsl:if>
  </xsl:template>
  
   <xsl:template match="FeatureHighlight/FeatureCode|FeatureLogo/FeatureCode">
       <xsl:variable name="fc" select="."/>
     <xsl:variable name="fic" select="../../FeatureImage[starts-with(FeatureCode,$fc)]/FeatureCode"/>
     <FeatureCode>
       <xsl:choose>
          <xsl:when test="$fic"><xsl:value-of select="$fic"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$fc"/></xsl:otherwise>
      </xsl:choose>
    </FeatureCode>
    <xsl:if test="not(../FeatureReferenceName)">
      <FeatureReferenceName/>
    </xsl:if>
   </xsl:template>
  
   <xsl:template match="Feature/FeatureCode">
      <xsl:variable name="fc" select="."/>
     <xsl:variable name="fic" select="../../../FeatureImage[starts-with(FeatureCode,$fc)]/FeatureCode"/>
     <FeatureCode>
       <xsl:choose>
          <xsl:when test="$fic"><xsl:value-of select="$fic"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$fc"/></xsl:otherwise>
      </xsl:choose>
    </FeatureCode>
    <xsl:if test="not(../FeatureReferenceName)">
      <FeatureReferenceName/>
    </xsl:if>
   </xsl:template>
  <!-- Deprecated -->
  <xsl:template match="BrandLogoURL|ConceptLogoURL|SystemLogoURL|PartnerLogoURL|FeatureLogoURL|AccessoryByPackedImageURL|AwardLogoURL"/>
  
  <!-- Convert any pre Green3 EnerbyLabels to the new format -->
  <xsl:template match="GreenData/EnergyLabel/EnergyClasses">
    <xsl:apply-templates select="EnergyClass"/>
  </xsl:template>
  <xsl:template match="GreenData/EnergyLabel/EnergyClasses/EnergyClass">
    <ApplicableFor>
      <xsl:apply-templates select="@*|node()"/>
    </ApplicableFor>
  </xsl:template>
    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
