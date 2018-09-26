<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:my="http://www.philips.com/pika" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"  
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                exclude-result-prefixes="sql"
                extension-element-prefixes="my cmc2-f">                

  <xsl:import-schema schema-location="xUCDM_rendering_product_1_3.xsd"/>
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>

  <xsl:strip-space elements="*"/>

  <xsl:param name="runtimestamp"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="maxbatchnumber"/>
  <xsl:param name="batchtype"/>
  <xsl:variable name="rundate" select="concat(substring($runtimestamp,1,4)
                                             ,'-'
                                             ,substring($runtimestamp,5,2)
                                             ,'-'
                                             ,substring($runtimestamp,7,2)
                                             ,'T'
                                             ,substring($runtimestamp,9,2)
                                             ,':'
                                             ,substring($runtimestamp,11,2)
                                             ,':00')"/>
  <xsl:template match="/">
    <xsl:result-document validation="strict">
      <xsl:apply-templates select="RenderProducts"/>
    </xsl:result-document>
  </xsl:template>


  <xsl:template match="RenderProducts">
    <RenderProducts DocTimeStamp="{$rundate}"
                    XSDVersion="1.31"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:noNamespaceSchemaLocation="xUCDM_rendering_product_1_3_1.xsd">
      <Batch>
        <BatchDate><xsl:value-of select="$rundate"/></BatchDate>
        <BatchType><xsl:value-of select="if($batchtype='delta') then 'Delta' else 'Full'"/></BatchType>
        <PartNumber><xsl:value-of select="$batchnumber"/></PartNumber>
        <NumberOfPartsInBatch><xsl:value-of select="$maxbatchnumber"/></NumberOfPartsInBatch>
      </Batch>
      <xsl:apply-templates select="sql:rowset[@name='product']/sql:row/sql:data/Product"/>
    </RenderProducts>
  </xsl:template>

  <xsl:template match="Product">
    <xsl:variable name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))" as="xsl:dateTime"/>
    <xsl:variable name="masterLastModified" select="if(@masterLastModified) 
                                                      then concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8)) 
                                                      else concat(substring(../../sql:masterlastmodified,1,10),'T',substring(../../sql:masterlastmodified,12,8))" 
                                            as="xsl:dateTime"/>
    <xsl:variable name="lastExportDate"     select="../../sql:lastexportdate"     as="xsl:dateTime"/>
    <RenderProduct>
      <xsl:attribute name="IsMaster" select="if(@IsMaster='1' or @IsMaster='true') then 'true' else 'false'"/>
      <xsl:attribute name="IsAccessory" select="if(@IsAccessory='1' or @IsAccessory='true') then 'true' else 'false'"/>
      <xsl:attribute name="lastModified" select="$lastModified"/>
      <xsl:attribute name="masterLastModified" select="substring($masterLastModified,1,19)"/>
      <xsl:if test="@IsMaster!='true' and @IsMaster!='1'">
        <xsl:attribute name="Country" select="@Country"/>
        <xsl:attribute name="Locale" select="@Locale"/>
      </xsl:if>
      <CTN><xsl:value-of select="CTN"/></CTN>
      <MarketingVersion><xsl:value-of select="MarketingVersion"/></MarketingVersion>     
       
      <!-- Change request for implementation of Trade Backgrounder project -->
      <!-- <MarketingStatus><xsl:value-of select="MarketingStatus"/></MarketingStatus>-->
      <MarketingStatus><xsl:value-of select="ancestor::sql:row/sql:status"/></MarketingStatus>
      
      <xsl:if test="CRDate!=''">
          <CRDate><xsl:value-of select="CRDate"/></CRDate>
      </xsl:if>
      <xsl:if test="CRDateYW!=''">      
        <CRDateYW><xsl:value-of select="CRDateYW"/></CRDateYW>
      </xsl:if>        
      <ProductDivision>
        <ProductDivisionCode><xsl:value-of select="if(ProductDivision/FormerPDCode) then ProductDivision/FormerPDCode else ProductDivision/ProductDivisionCode"/></ProductDivisionCode>
        <ProductDivisionName><xsl:value-of select="if (ProductDivision/FormerPDCode = '0300') then 'DAP' 
                                              else if (ProductDivision/FormerPDCode = '3400') then 'Consumer Electronics' 
                                              else                                                  ProductDivision/ProductDivisionName"/></ProductDivisionName>
      </ProductDivision>
      <ProductOwner><xsl:value-of select="ProductOwner"/></ProductOwner>
      <xsl:choose>
        <xsl:when test="Code12NC != ''">
          <Code12NC><xsl:value-of select="Code12NC"/></Code12NC>
        </xsl:when>
      </xsl:choose>          
      <GTIN><xsl:value-of select="GTIN"/></GTIN>
            
			<xsl:for-each select="../../sql:rowset[@name='Local_Price']/sql:row">
					<xsl:choose>
							<xsl:when test="sql:local_going_price != '' ">
                <LocalGoingPrice>
                    <Amount><xsl:value-of select="sql:local_going_price" /></Amount>
                    <CurrencyCode><xsl:value-of select="sql:currency_code" /></CurrencyCode>
                </LocalGoingPrice>
              </xsl:when>
					</xsl:choose>          
			</xsl:for-each>
      
      <DTN><xsl:value-of select="DTN"/></DTN>
      <ProductName><xsl:value-of select="ProductName"/></ProductName>
      <NamingString>
        <xsl:apply-templates select="NamingString/MasterBrand"/>
        <xsl:apply-templates select="NamingString/Partner"/>
        <xsl:apply-templates select="NamingString/BrandString"/>
        <xsl:apply-templates select="NamingString/BrandString2"/>
        <xsl:apply-templates select="NamingString/Concept"/>
        <xsl:choose>
          <!-- If there is a Family but no Range, use the Family -->
          <xsl:when test="NamingString/Family and not(NamingString/Range)">
            <Family>          
              <xsl:apply-templates select="NamingString/Family/FamilyCode"/>
              <xsl:apply-templates select="NamingString/Family/FamilyName"/>
              <!-- If ConceptNameUsed != 1, then set FamilyNameUsed = 1 -->              
              <FamilyNameUsed><xsl:value-of select="if(not(NamingString/Concept/ConceptNameUsed = 1)) then 1 else 0"/></FamilyNameUsed>
            </Family>              
          </xsl:when>
          <!-- If there is a Range but no Family, make the Range look like a Family -->
          <xsl:when test="NamingString/Range and not(NamingString/Family)">
            <Family>
              <FamilyCode><xsl:value-of select="NamingString/Range/RangeCode"/></FamilyCode>
              <FamilyName><xsl:value-of select="NamingString/Range/RangeName"/></FamilyName>
              <!-- Family from Range alwasy set to 0 -->
              <FamilyNameUsed><xsl:value-of select="0"/></FamilyNameUsed>
            </Family>
          </xsl:when>
          <!-- If there is a Range and a Family, drop the Range and use the Family -->
          <xsl:when test="NamingString/Range and NamingString/Family">
            <Family>
              <xsl:apply-templates select="NamingString/Family/FamilyCode"/>
              <xsl:apply-templates select="NamingString/Family/FamilyName"/>
              <!-- If ConceptNameUsed != 1, then set FamilyNameUsed = 1 -->
              <FamilyNameUsed><xsl:value-of select="if(not(NamingString/Concept/ConceptNameUsed = 1)) then 1 else 0"/></FamilyNameUsed>
            </Family>
          </xsl:when>          
        </xsl:choose>           
        <xsl:apply-templates select="NamingString/Descriptor"/>
        <xsl:apply-templates select="NamingString/Alphanumeric"/>
        <xsl:apply-templates select="NamingString/VersionElement1"/>
        <xsl:apply-templates select="NamingString/VersionElement2"/>
        <xsl:apply-templates select="NamingString/VersionElement3"/>
        <xsl:apply-templates select="NamingString/VersionElement4"/>
        <xsl:apply-templates select="NamingString/VersionString"/>
        <xsl:apply-templates select="NamingString/BrandedFeatureCode1"/>
        <xsl:apply-templates select="NamingString/BrandedFeatureCode2"/>
        <xsl:apply-templates select="NamingString/BrandedFeatureString"/>
        <xsl:apply-templates select="NamingString/DescriptorBrandedFeatureString"/>
      </NamingString>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <xsl:apply-templates select="SupraFeature"/>
      <xsl:apply-templates select="KeyBenefitArea"/>            
      <xsl:apply-templates select="SystemLogo"/>
      <xsl:apply-templates select="PartnerLogo"/>
      <xsl:apply-templates select="FeatureLogo"/>
      <xsl:apply-templates select="FeatureImage"/>
      <xsl:apply-templates select="FeatureHighlight"/>
      <xsl:apply-templates select="CSChapter"/>
      
      <Disclaimers>
        <xsl:for-each select="Disclaimers/Disclaimer">
          <Disclaimer>
            <xsl:attribute name="Code" select="@code"/>
            <xsl:attribute name="ReferenceName" select="@code"/>            
			      <DisclaimerText><xsl:value-of select="normalize-space(DisclaimerText)"/></DisclaimerText>                          
            <DisclaimElements/>    
          </Disclaimer>
        </xsl:for-each>  
      </Disclaimers>
      <xsl:apply-templates select="AccessoryByPacked"/>
      <!-- Green2 modification 
      <xsl:apply-templates select="Award[@AwardType=('global','global_highlight')]"/>
      -->
      <xsl:call-template name="doAwards">
        <xsl:with-param name="Awards"><xsl:copy-of select="Award[@AwardType=('global','global_highlight')]" copy-namespaces="no"/></xsl:with-param>
      </xsl:call-template>
      <!-- end Green2 -->
      <xsl:call-template name="doProductReference"/>
      <!-- Green2 addition: only add energy class for localised leaflets
         |    (otherwise the energy class makes no sense).
         |-->
      <xsl:if test="@IsMaster!='true' and @IsMaster!='1'">
         <xsl:call-template name="createEnergyClass"/>
      </xsl:if>
      <xsl:if test="string-length(../../sql:eos) &gt; 0">
          <EOSDate><xsl:value-of select="substring(../../sql:eos,1,10)"/></EOSDate>
      </xsl:if>
      <!-- <xsl:for-each select="../../sql:rowset[@name='cat']/sql:row"> -->
       <xsl:for-each select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row">
      
      <xsl:choose>
              <xsl:when test="sql:catalogcode = 'ProductTree'">                 
                  <FinancialCategorization>                   
                    <BusinessGroupCode><xsl:value-of select="sql:bgroupcode"/></BusinessGroupCode>
                    <BusinessGroupName><xsl:value-of select="sql:bgroupname"/></BusinessGroupName>
                    <BusinessUnitCode><xsl:value-of select="sql:groupcode"/></BusinessUnitCode> 
                    <BusinessUnitName><xsl:value-of select="sql:groupname"/></BusinessUnitName>
                    <MainArticleGroupCode><xsl:value-of select="sql:categorycode"/></MainArticleGroupCode>
                    <MainArticleGroupName><xsl:value-of select="sql:categoryname"/></MainArticleGroupName>
                    <ArticleGroupCode><xsl:value-of select="sql:subcategorycode"/></ArticleGroupCode>
                    <ArticleGroupName><xsl:value-of select="sql:subcategoryname"/></ArticleGroupName>                   
                  </FinancialCategorization>                 
              </xsl:when>
              <xsl:otherwise>                 
                  <Categorization>                                       
                    <GroupCode><xsl:value-of select="sql:groupcode"/></GroupCode>
                    <GroupName><xsl:value-of select="sql:groupname"/></GroupName>
                    <CategoryCode><xsl:value-of select="sql:categorycode"/></CategoryCode>
                    <CategoryName><xsl:value-of select="sql:categoryname"/></CategoryName>
                    <SubCategoryCode><xsl:value-of select="sql:subcategorycode"/></SubCategoryCode>
                    <SubCategoryName><xsl:value-of select="sql:subcategoryname"/></SubCategoryName>
                  </Categorization>                
              </xsl:otherwise>             
          </xsl:choose>
	</xsl:for-each>
	  <xsl:if test="empty(../../sql:rowset[@name='cat']/sql:row)">
        <Categorization>
          <GroupCode>NONE</GroupCode>
          <GroupName>NONE</GroupName>
          <CategoryCode>NONE</CategoryCode>
          <CategoryName>NONE</CategoryName>
          <SubCategoryCode>NONE</SubCategoryCode>
          <SubCategoryName>NONE</SubCategoryName>
        </Categorization>
		</xsl:if>
	  <xsl:if test="empty(../../sql:rowset[@name='cat']/sql:row)">
        <Categorization>
          <GroupCode>NONE</GroupCode>
          <GroupName>NONE</GroupName>
          <CategoryCode>NONE</CategoryCode>
          <CategoryName>NONE</CategoryName>
          <SubCategoryCode>NONE</SubCategoryCode>
          <SubCategoryName>NONE</SubCategoryName>
        </Categorization>
		</xsl:if>
    </RenderProduct>
  </xsl:template>
  
  <!-- -->
  <xsl:template name="doProductReference">
    <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType=('Performer','Accessory')]/CTN
                               | ProductReferences[@ProductReferenceType=('Performer','Accessory')]/CTN"/>
  </xsl:template>        
  
  <!-- -->
  <xsl:template match="CTN[parent::ProductReference|parent::ProductReferences]">
    <ProductReference ProductReferenceType="{../@ProductReferenceType}">
      <xsl:copy-of copy-namespaces="no"  select="."/>
      <ProductReferenceRank><xsl:value-of select="if(@rank) then @rank else 0"/></ProductReferenceRank> 
    </ProductReference>
  </xsl:template>
  
  <!-- -->
  <xsl:template match="CSChapter">
    <xsl:if test="CSItem[count(CSValue/CSValueCode) = count(CSValue/CSValueName)]">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>        
    </xsl:if>
  </xsl:template>
  
  <!-- -->
  <xsl:template match="CSItem">
  <!-- only include csitems that are in product detail block in filters -->
    <xsl:if test="count(CSValue/CSValueCode) = count(CSValue/CSValueName)">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove CSValueDisplayName -->
  <xsl:template match="CSValueDisplayName"/>
  
  <!-- 
     | Modifications for Green2: create Awards based on GreenData-element
     -->
  <xsl:template name="doAwards">
    <xsl:param name="Awards" />
    <xsl:variable name="tempAwards">
       <!-- create rank=1 Award (if a global/global_highlight award is available) 
       -->
       <xsl:if test="$Awards/Award[position()=1]">
         <xsl:copy-of select="cmc2-f:doAward($Awards/Award[position()=1], 1)" copy-namespaces="no"/>
       </xsl:if>
       <!-- if the GreenData-element contains greenProduct info, then create Awards 
       -->
       <xsl:if test="GreenData/EcoFlower[@isEcoFlowerProduct='true' and @publish='true']">
         <Award>
           <xsl:attribute name="AwardType">global_highlight</xsl:attribute>
           <AwardCode><xsl:value-of select="GreenData/EcoFlower/Code"/></AwardCode>
           <AwardName><xsl:value-of select="GreenData/EcoFlower/Name"/></AwardName>
           <AwardDescription><xsl:value-of select="GreenData/EcoFlower/LongDescription"/></AwardDescription>
           <AwardText><xsl:value-of select="GreenData/EcoFlower/Text"/></AwardText>
           <AwardRank>2</AwardRank>
         </Award>
       </xsl:if>
       <xsl:if test="GreenData/PhilipsGreenLogo[@isGreenProduct='true' and @publish='true']">
         <Award>
           <xsl:attribute name="AwardType">global_highlight</xsl:attribute>
           <AwardCode><xsl:value-of select="GreenData/PhilipsGreenLogo/Code"/></AwardCode>
           <AwardName><xsl:value-of select="GreenData/PhilipsGreenLogo/Name"/></AwardName>
           <AwardDescription><xsl:value-of select="GreenData/PhilipsGreenLogo/LongDescription"/></AwardDescription>
           <AwardText><xsl:value-of select="GreenData/PhilipsGreenLogo/Text"/></AwardText>
           <AwardRank>3</AwardRank>
         </Award>
       </xsl:if>
       <!-- create BlueAngel Awards 
        -->
       <xsl:if test="GreenData/BlueAngel[@isBlueAngelProduct='true' and @publish='true']">
         <Award>
           <xsl:attribute name="AwardType">global_highlight</xsl:attribute>
           <AwardCode><xsl:value-of select="GreenData/BlueAngel/Code"/></AwardCode>
           <AwardName><xsl:value-of select="GreenData/BlueAngel/Name"/></AwardName>
           <AwardDescription><xsl:value-of select="GreenData/BlueAngel/LongDescription"/></AwardDescription>
           <AwardText><xsl:value-of select="GreenData/BlueAngel/Text"/></AwardText>
           <AwardRank>4</AwardRank>
         </Award>
       </xsl:if>
       <!-- create rank>=5 Awards (if more global/global_highlight awards are available)
        -->
       <xsl:for-each select="$Awards/Award[position()>1]">
         <xsl:copy-of select="cmc2-f:doAward(., position()+1)" copy-namespaces="no"/>
       </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$tempAwards" copy-namespaces="no"/>
  </xsl:template>
  <!-- -->
  <xsl:template name="createEnergyClass">
    <xsl:if test="exists(GreenData/EnergyLabel[@publish='true'])">
      <xsl:choose>
        <xsl:when test="exists(GreenData/EnergyLabel/EnergyClasses/EnergyClass)">
          <EnergyClass>
            <EnergyClassCode><xsl:value-of select="GreenData/EnergyLabel/EnergyClasses/EnergyClass[1]/Code"/></EnergyClassCode>
            <ShortDescription><xsl:value-of select="GreenData/EnergyLabel/ShortDescription"/></ShortDescription>
            <LongDescription><xsl:value-of select="GreenData/EnergyLabel/LongDescription"/></LongDescription>
          </EnergyClass>
        </xsl:when>
        <xsl:when test="exists(GreenData/EnergyLabel/ApplicableFor)">
          <EnergyClass>
            <EnergyClassCode><xsl:value-of select="GreenData/EnergyLabel/ApplicableFor[1]/Code"/></EnergyClassCode>
            <ShortDescription><xsl:value-of select="GreenData/EnergyLabel/ShortDescription"/></ShortDescription>
            <LongDescription><xsl:value-of select="GreenData/EnergyLabel/LongDescription"/></LongDescription>
          </EnergyClass>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!-- block these attributes: -->
  <xsl:template match="attribute::localized"/>
  
  <!-- block these elements -->
  <xsl:template match="CSValueDescription"/>
  <xsl:template match="CSItemDescription"/>
  <xsl:template match="RichText[@type = 'Functionality']"/>
  
  <xsl:template match="IsFamily"/>
  <xsl:template match="GreenData"/>
  <!-- Identity transform -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>