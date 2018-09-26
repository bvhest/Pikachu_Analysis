<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                exclude-result-prefixes="sql"
                extension-element-prefixes="cmc2-f"
                >

  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <!-- variable is not used... -->
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="exclude-award-types" select="('ala_semantic','ala_user','ala_bv_summary')"/>
  
  
  
  <!--+
      |
      |  Generates xml for xUCDM_product_external_1_1 (see
      |  http://pww.emea.sharepoint.philips.com/sites/gs71/Shared%20Documents/Architecture/Business_and_information_architecture/UCDM/xUCDM%20schema%27s/xUCDM%20v1.1/xUCDM_product_external_1_1.xsd)
      |  Also downgrades xUCDM product marketing 1.2+ to 1.1.
      +-->

  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="sql:language"/>
  <xsl:template match="sql:division"/>  
  <xsl:template match="sql:local_going_price"/>
  <xsl:template match="sql:categorization_catalogtype"/>
    
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
      <!-- <xsl:apply-templates select="CTN"/> -->
		<xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
     <ProductType><xsl:value-of select="ancestor::sql:row/sql:product_type"/></ProductType>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>
      <xsl:apply-templates select="ModelYears"/>
      <xsl:apply-templates select="ProductDivision"/>
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="DTN"/>
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
  
  <xsl:template match="NamingString">
    <xsl:copy>
      <xsl:apply-templates select="MasterBrand"/>
      <xsl:apply-templates select="Partner"/>
      <xsl:apply-templates select="BrandString"/>
      <xsl:apply-templates select="BrandString2"/>
      <xsl:apply-templates select="Concept"/>
      <xsl:apply-templates select="Family"/>
      <xsl:call-template name="doRange"/>
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
  
  <xsl:template name="doRange">
    <xsl:apply-templates select="Range"/>
  </xsl:template>
  
  <!--
    old internal format (1.0.7):
    <ProductReference ProductReferenceType="Accessory">
      <CTN>SLV3100/00</CTN>
      <ProductReferenceRank>0</ProductReferenceRank>
    </ProductReference>

    1.1 internal format:
    <ProductReferences ProductReferenceType="Accessory">
      <CTN>30MF200V/17</CTN>
      <CTN>30PF9946/12</CTN>
      <CTN>30PF9946/37</CTN>
    </ProductReferences>

    1.2 internal format:
    <ProductRefs>
      <ProductReference ProductReferenceType="Accessory">
        <CTN>30MF200V/17</CTN>
        <CTN>30PF9946/12</CTN>
        <CTN>30PF9946/37</CTN>
      </ProductReference>
    </ProductRefs>
    
    1.1 external format:
    <ProductReference ProductReferenceType="Accessory">
      <CTN>SLV3100/00</CTN>
      <ProductReferenceRank>0</ProductReferenceRank>
    </ProductReference>
  -->
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
  
  <xsl:template name="docatalogdata">
    <xsl:param name="sop"/>
    <xsl:param name="eop"/>
    <xsl:param name="sos"/>
    <xsl:param name="eos"/>
    <!-- BHE: local going price is most often empty: defaults to 0.00 -->
    <xsl:param name="lgp">'0.00'</xsl:param>
    <!-- BHE: rank can be empty: defaults to 0. -->
    <xsl:param name="rank">0</xsl:param>
    <xsl:param name="deleted"/>
    <xsl:param name="deleteafterdate"/>
    <Catalog>
      <StartOfPublication><xsl:value-of select="$sop"/></StartOfPublication>
      <EndOfPublication><xsl:value-of select="$eop"/></EndOfPublication>
      <StartOfSales><xsl:value-of select="$sos"/></StartOfSales>
      <EndOfSales><xsl:value-of select="$eos"/></EndOfSales>
      <DummyPrice><xsl:value-of select="$lgp"/></DummyPrice>
      <Deleted><xsl:value-of select="if($deleted = '1') then 'true' else 'false'"/></Deleted>
      <DeleteAfterDate><xsl:value-of select="$deleteafterdate"/></DeleteAfterDate>
      <ProductRank><xsl:value-of select="$rank"/></ProductRank>
    </Catalog>
  </xsl:template>
  
  <xsl:template name="docategorization">
    <xsl:param name="cats"/>    
      <xsl:for-each select="$cats">
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
                  <Categorization type="{sql:catalogcode}">						        						        
						        <GroupCode><xsl:value-of select="sql:groupcode"/></GroupCode>
						        <GroupName><xsl:value-of select="sql:groupname"/></GroupName>
						        <CategoryCode><xsl:value-of select="sql:categorycode"/></CategoryCode>
						        <CategoryName><xsl:value-of select="sql:categoryname"/></CategoryName>
						        <SubcategoryCode><xsl:value-of select="sql:subcategorycode"/></SubcategoryCode>
						        <SubcategoryName><xsl:value-of select="sql:subcategoryname"/></SubcategoryName>
						      </Categorization>						      
              </xsl:otherwise>             
          </xsl:choose>
      </xsl:for-each>   
  </xsl:template>
  
  <xsl:template name="doAssets">
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="catalogtype"/>
    <xsl:variable name="escid" select="replace($id,'/','_')"/>
    <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>  <!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
    <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
    <Assets>
      <Asset code="{$escid}" type="DFU" locale="{$locale}" number="001" description="UserManual" extension="pdf"><xsl:value-of select="concat($nonimagepath,$id,'&amp;doctype=DFU&amp;laco=',$language)"/></Asset>
      <Asset code="{$escid}" type="PSS" locale="{$locale}" number="001" description="Product Specification Sheet (Leaflet)" extension="pdf"><xsl:value-of select="concat($nonimagepath,$id,'&amp;doctype=PSS&amp;laco=',$language)"/></Asset>
      <Asset code="{$escid}" type="FAQ" locale="{$locale}" number="001" description="Frequently asked questions" extension="pdf"><xsl:value-of select="concat($nonimagepath,$id,'&amp;doctype=FAQ&amp;laco=',$language)"/></Asset>
      <Asset code="{$escid}" type="TIP" locale="{$locale}" number="001" description="Tips to users" extension="pdf"><xsl:value-of select="concat($nonimagepath,$id,'&amp;doctype=TIP&amp;laco=',$language)"/></Asset>
      <Asset code="{$escid}" type="RTP" locale="{$locale}" number="001" description="Product picture front-top-left with reflection 2196x1795" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-RTP-global-001')"/></Asset>
      <Asset code="{$escid}" type="RTF" locale="{$locale}" number="001" description="Product picture front-top-left with reflection 396x396" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-RTF-global-001')"/></Asset>
      <Asset code="{$escid}" type="TRP" locale="{$locale}" number="001" description="Product picture front-top-right 2196x1795" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-TRP-global-001')"/></Asset>
      <Asset code="{$escid}" type="TRF" locale="{$locale}" number="001" description="Product picture front-top-right 396x396" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-TRF-global-001')"/></Asset>
      <Asset code="{$escid}" type="RCW" locale="{$locale}" number="001" description="Remote control image" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-RCW-global-001')"/></Asset>
      <Asset code="{$escid}" type="COW" locale="{$locale}" number="001" description="Connector side image" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-COW-global-001')"/></Asset>
      <!-- Virtual assets -->
      <Asset code="{$escid}" type="IMS" locale="{$locale}" number="" description="Single product shot" extension=""><xsl:value-of select="concat($imagepath,$escid,'-IMS-',$locale)"/></Asset>
      <Asset code="{$escid}" type="GAL" locale="{$locale}" number="" description="Product gallery image set" extension=""><xsl:value-of select="concat($imagepath,$escid,'-GAL-',$locale)"/></Asset>
    </Assets>
  </xsl:template>
  
  <xsl:template name="doKeyValuePairs">
    <xsl:apply-templates select="KeyValuePairs"/>
  </xsl:template>
  
  <xsl:template name="doFilters">
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
      <xsl:if test="Filters/Purpose[not(@type)]/Features/Feature[@code!=''] or Filters/Purpose[not(@type)]/CSItems/CSItem[@code!='']">
        <Purpose type="Discriminators">
          <xsl:copy-of copy-namespaces="no" select="Purpose[not(@type)]/Features"/>
          <xsl:copy-of copy-namespaces="no" select="Purpose[not(@type)]/CSItems"/>
        </Purpose>
      </xsl:if>
    </Filters>
  </xsl:template>
  
  <xsl:template match="Feature" mode="Filters">
    <Feature>
      <xsl:attribute name="code" select="FeatureCode"/>
      <xsl:attribute name="referenceName" select="FeatureReferenceName"/>
      <xsl:attribute name="rank" select="FeatureTopRank"/>
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
  
  <xsl:template match="CSChapter/CSItem[not(CSValue)]">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="CSItemCode"/>
      <xsl:apply-templates select="CSItemName"/>
      <xsl:apply-templates select="CSItemRank"/>
      <xsl:apply-templates select="CSItemIsFreeFormat"/>
      <CSValue>
          <CSValueCode>V_99999999</CSValueCode>
          <CSValueName>DUMMY</CSValueName>
          <CSValueRank>1</CSValueRank>
      </CSValue>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="CSChapter[not(CSItem[not(CSValue)])]/CSItem">
    <CSItem>
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank|CSItemIsFreeFormat"/>
      <xsl:apply-templates select="CSValue">
        <xsl:sort data-type="number" select="CSValueRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="UnitOfMeasure"/>
    </CSItem>
  </xsl:template>
  
  <xsl:template match="FeatureImage[not(FeatureReferenceName)]">
    <xsl:copy>
      <xsl:apply-templates select="FeatureCode"/>
      <FeatureReferenceName/>
      <xsl:apply-templates select="ProductSpecific"/>
      <xsl:apply-templates select="FeatureImageRank"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Feature/FeatureGlossary[string-length(.) &lt; 10]">
    <!-- Do not export the value, as it is likely to be "na", or "-" etc. -->
    <FeatureGlossary/>
  </xsl:template>
  
  <xsl:template match="MarketingTextHeader[string-length(.) &lt; 10]">
    <!-- Do not export the value, as it is likely to be "na", or "-" etc. -->
    <MarketingTextHeader/>
  </xsl:template>
  
  <xsl:template name="OptionalHeaderAttributes"/>
  
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
  
  <xsl:template name="doAwards">
    <xsl:param name="Awards" />
    <xsl:variable name="tempAwards">
    <!-- create rank=1 Award (if a global/global_highlight award is available) -->
      <xsl:if test="$Awards/Award[position()=1]">
        <xsl:copy-of select="cmc2-f:doAward($Awards/Award[position()=1], position())" />
      </xsl:if>
      <!-- if the GreenData-element contains greenProduct info, then create Awards -->
       <xsl:if test="GreenData/EcoFlower[@isEcoFlowerProduct='true' and @publish='true']">
        <Award>
          <xsl:attribute name="AwardType">global</xsl:attribute>
          <!-- Code taken from EcoFlower/Code -->
          <AwardCode><xsl:value-of select="GreenData/EcoFlower/Code"/></AwardCode>
          <!-- AwardName taken from EcoFlower/Name -->
          <AwardName><xsl:value-of select="GreenData/EcoFlower/Name"/></AwardName>
          <!-- AwardDescription taken from EcoFlower/ShortDescription -->
          <AwardDescription><xsl:value-of select="GreenData/EcoFlower/ShortDescription"/></AwardDescription>
          <!-- AwardText taken from EcoFlower/Text -->  
          <AwardText><xsl:value-of select="GreenData/EcoFlower/Text"/></AwardText>
          <AwardRank>2</AwardRank>
        </Award>
      </xsl:if>
      <xsl:if test="GreenData/PhilipsGreenLogo[@isGreenProduct='true' and @publish='true']">
        <Award>
          <xsl:attribute name="AwardType">global</xsl:attribute>
          <AwardCode><xsl:value-of select="GreenData/PhilipsGreenLogo/Code"/></AwardCode>
          <AwardName><xsl:value-of select="GreenData/PhilipsGreenLogo/Name"/></AwardName>
          <AwardDescription><xsl:value-of select="GreenData/PhilipsGreenLogo/ShortDescription"/></AwardDescription>
          <AwardText><xsl:value-of select="GreenData/PhilipsGreenLogo/Text"/></AwardText>
          <AwardRank>3</AwardRank>
        </Award>
      </xsl:if>
       <xsl:if test="GreenData/BlueAngel[@isBlueAngelProduct='true' and @publish='true']">
         <Award>
           <xsl:attribute name="AwardType">global</xsl:attribute>
           <AwardCode><xsl:value-of select="GreenData/BlueAngel/Code"/></AwardCode>
           <AwardName><xsl:value-of select="GreenData/BlueAngel/Name"/></AwardName>
           <AwardDescription><xsl:value-of select="GreenData/BlueAngel/ShortDescription"/></AwardDescription>
           <AwardText><xsl:value-of select="GreenData/BlueAngel/Text"/></AwardText>
           <AwardRank>4</AwardRank>
         </Award>
       </xsl:if>
      <!-- create rank>=5 Awards (if more global/global_highlight awards are available) -->
      <xsl:for-each select="$Awards/Award[position()>1]">
        <xsl:copy-of select="cmc2-f:doAward(., position()+1)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:apply-templates select="$tempAwards"/>
  </xsl:template>
  
  <!-- Identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Block the following attributes -->
  <xsl:template match="attribute::localized"/>
  <!-- Block the following elements -->
  <xsl:template match="GreenData"/>
  <!-- -->
</xsl:stylesheet>