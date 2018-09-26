<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    exclude-result-prefixes="sql"
    extension-element-prefixes="cmc2-f">

  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  <!--+
      |
      |  Generates xml for xUCDM_product_external_1_3 (see
      |  https://www.emea.sharepoint.philips.com/sites/gs71/Shared%20Documents/Architecture/Business_and_information_architecture/UCDM/xUCDM%20schema%27s/xUCDM%20v1.2/xUCDM_product_external_1_2.xsd)
      |
      |  BHE (28/09/2011): based on xUCDM_product_external_1_2
      +-->

  <xsl:variable name="ignore-award-types" select="('ala_semantic','ala_user','ala_bv_summary')"/>

  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="sql:language"/>  
  <xsl:template match="sql:division"/>
  
  <xsl:template match="Products">
    <Products>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="DocVersion"><xsl:text>xUCDM_product_external_1_3.xsd</xsl:text></xsl:attribute>
      <xsl:call-template name="DocType-attribute"/> 
      <xsl:apply-templates select="node()"/>
    </Products>
  </xsl:template>
  
  <xsl:template name="DocType-attribute">
    <xsl:attribute name="DocType" select="sql:rowset/sql:row[1]/sql:content_type"/>
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
      <!-- BHE (30/9/2009): include empty elements for mandatory items.
      -->
      <MarketingStatus>
        <xsl:choose>
          <xsl:when test="not(MarketingStatus)">
            <xsl:text>Final Published</xsl:text>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="MarketingStatus"/></xsl:otherwise>
        </xsl:choose>      
      </MarketingStatus>
      <xsl:apply-templates select="LifecycleStatus"/>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>
      <ModelYears>
         <xsl:apply-templates select="ModelYear"/>
      </ModelYears>
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
      <xsl:choose>
        <xsl:when test="FullProductName=''">
          <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="FullProductName"/>
        </xsl:otherwise>
      </xsl:choose>
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
      <Filters>
        <xsl:apply-templates select="Filters/Purpose"/>
      </Filters>
      <!-- BHE: mandatory element FeatureCompareGroups 
      -->
      <FeatureCompareGroups>
        <xsl:apply-templates select="FeatureCompareGroups/FeatureCompareGroup"/>
      </FeatureCompareGroups>
      <!-- BHE: mandatory element Disclaimers 
      -->
      <Disclaimers>
        <xsl:apply-templates select="Disclaimers/Disclaimer"/>
      </Disclaimers>
      <!-- BHE: new order KeyValuePairs in tree & element is mandatory -->
      <KeyValuePairs>
        <xsl:call-template name="doKeyValuePairs"/>
      </KeyValuePairs>
      <xsl:call-template name="doAccessories">
        <xsl:with-param name="cschapters"><csc><xsl:copy-of select="CSChapter"/></csc></xsl:with-param>
        <xsl:with-param name="abp"><abp><xsl:copy-of select="AccessoryByPacked"/></abp></xsl:with-param>
      </xsl:call-template>
      <!-- Ignore ala_semantic Awards 
      <xsl:apply-templates select="Award[@AwardType != 'ala_semantic']">
        <xsl:sort data-type="number" select="AwardRank"/>
      </xsl:apply-templates>
      -->
      <!-- Green2 modification 
      -->
      <xsl:call-template name="doAwards">
        <xsl:with-param name="Awards"><xsl:copy-of select="Award[not(@AwardType=$ignore-award-types)]"/></xsl:with-param>
      </xsl:call-template>
      <!-- end Green2 -->
      <ProductClusters>
        <xsl:call-template name="ProductCluster"/>
      </ProductClusters>
      <ProductRefs>
        <xsl:call-template name="doProductReference"/>
      </ProductRefs>
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:apply-templates select="GreenData"/>
    </Product>
  </xsl:template>
  
  <!-- Fix empty rank attribute on Filters -->
  <xsl:template match="Filters/Purpose/Features/Feature[empty(@rank) or @rank='']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[name() != 'rank']"/>
      <xsl:attribute name="rank" select="position()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove empty Award Rating -->
  <xsl:template match="Award/Rating[.='']"/>
  
  <!--+
      | Rename ApplicableFor to EnergyClass.
      +-->
  <xsl:template match="EnergyLabel/ApplicableFor">
    <xsl:element name="EnergyClass">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>
  
  <!--+
      | Block the GreenChapters if there are less than three areas.
      +-->
  <xsl:template match="GreenData/GreenChapter">
    <xsl:if test="count(parent::GreenData/GreenChapter) &gt;= 3">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template match="GreenChapter/@MeetRegulations"/>
  <xsl:template match="GreenChapter/@rank"/>

  <xsl:template match="NamingString/Range"/>
  
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

  <xsl:template name="doProductReference">
    <xsl:apply-templates select="ProductRefs/node()"/> 
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
    <Categorization>
      <GroupCode><xsl:value-of select="$cats/sql:groupcode"/></GroupCode>
      <GroupName><xsl:value-of select="$cats/sql:groupname"/></GroupName>
      <CategoryCode><xsl:value-of select="$cats/sql:categorycode"/></CategoryCode>
      <CategoryName><xsl:value-of select="$cats/sql:categoryname"/></CategoryName>
      <SubcategoryCode><xsl:value-of select="$cats/sql:subcategorycode"/></SubcategoryCode>
      <SubcategoryName><xsl:value-of select="$cats/sql:subcategoryname"/></SubcategoryName>
    </Categorization>
  </xsl:template>

  <xsl:template name="doAssets">
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
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
    <!-- Some PMTs may still have separate KeyValuePair elements without a proper container -->
    <xsl:apply-templates select="KeyValuePairs/KeyValuePair|KeyValuePair"/>
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
      <xsl:apply-templates select="*"/>
      <CSValue>
          <CSValueCode>V_99999999</CSValueCode>
          <CSValueName>DUMMY</CSValueName>
          <CSValueRank>1</CSValueRank>
      </CSValue>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CSChapter[not(CSItem[not(CSValue)])]/CSItem">
    <CSItem>
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank|CSItemDescription|CSItemIsFreeFormat"/>
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
  
  <!-- Ignore empty BulletList -->
  <xsl:template match="BulletList[not(BulletItem)]"/>
  
  <!-- Ignore referenced Features that do not exist -->
  <!--
  <xsl:template match="Filters/Purpose/Features/Feature[empty(key('kba-feature-codes',concat(ancestor::Product/CTN,@code)))]"/>
  -->
  
  <!-- Ignore referenced CSItems that do not exist -->
  <!--
  <xsl:template match="Filters/Purpose/CSItems/CSItem[empty(key('cs-item-codes',concat(ancestor::Product/CTN,@code)))]"/>
  -->
  
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

  <xsl:template match="MarketingStatus">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="chapter">
     <Chapter>
        <xsl:attribute name="code" select="if(@code) then @code else 'unknown'" />
        <xsl:attribute name="referenceName" select="if(@referenceName) then @referenceName else 'unknown'" />
        <xsl:attribute name="rank" select="if(@rank) then @rank else '0'" />
        <xsl:sequence select="Name"/>
     </Chapter>
  </xsl:template>

  <xsl:template name="ProductCluster">
    <xsl:if test="NamingString/Range">
      <ProductCluster>
        <xsl:attribute name="code" select="NamingString/Range/RangeCode" />
        <xsl:attribute name="type" select="'range'" />
        <xsl:attribute name="rank" select="'0'" />
        <Name>
          <xsl:value-of select="NamingString/Range/RangeName" />
        </Name>
      </ProductCluster>
    </xsl:if>
    <!-- Copy existing ProductClusters -->
    <xsl:sequence select="ProductClusters/ProductCluster"/>
  </xsl:template>

  <xsl:template name="doAwards">
    <xsl:param name="Awards" />	
    <xsl:variable name="tempAwards">
	<xsl:variable name='greenAward'>
	  <xsl:choose>
		<xsl:when test="GreenData/PhilipsGreenLogo[@isGreenProduct='true' and @publish='true']">
		  <xsl:value-of select="'true'"/>
		</xsl:when>    
		<xsl:otherwise>
		  <xsl:value-of select="'false'"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>		
       <!-- create rank=1 Award (if a global/global_highlight award is available) -->
       <xsl:if test="$Awards/Award[position()=1]">
		   <xsl:if test="($Awards/Award[position()=1]/AwardCode!='GA_GREEN' and $greenAward eq 'true') or $greenAward eq 'false'">
				<xsl:copy-of select="cmc2-f:doAward($Awards/Award[position()=1], position())" />
		   </xsl:if>
       </xsl:if>
       <!-- if the GreenData-element contains greenProduct info, then create Awards -->
       <xsl:if test="GreenData/EcoFlower[@isEcoFlowerProduct='true' and @publish='true']">
         <Award>
           <xsl:attribute name="AwardType">global</xsl:attribute>
           <AwardCode><xsl:value-of select="GreenData/EcoFlower/Code"/></AwardCode>
           <AwardName><xsl:value-of select="GreenData/EcoFlower/Name"/></AwardName>
           <AwardDescription><xsl:value-of select="GreenData/EcoFlower/ShortDescription"/></AwardDescription>
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
		<xsl:if test="($Awards/Award[position()>1]/AwardCode!='GA_GREEN' and $greenAward eq 'true') or $greenAward eq 'false'">
			<xsl:copy-of select="cmc2-f:doAward(., position()+1)" />
		</xsl:if>
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
  <!-- Block the following elements -->
  <xsl:template match="Range"/>
  <!-- Block the following attributes -->
  <xsl:template match="attribute::localized"/>
  <!-- -->
</xsl:stylesheet>