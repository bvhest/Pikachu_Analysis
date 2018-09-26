<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:my="http://www.philips.com/pika" 
                extension-element-prefixes="my xs"
                >
  <xsl:strip-space elements="*"/>
  <!--  -->
  <xsl:param name="doctypesfilepath"/>
  <!--  -->
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="atgNullValue" select="'__NULL__'"/>
  <!--
     | FUNCTIONS     
     |-->
  <xsl:function name="my:normalized-id" as="xs:string">
    <xsl:param name="id" />
    <xsl:value-of select="translate($id,'/-. ','___')" />
  </xsl:function>

  <xsl:function name="my:escapeFreeFormatValue" as="xs:string">
    <xsl:param name="value" />
    <xsl:value-of select="replace($value, ',', ',,')" />
  </xsl:function>

  <xsl:function name="my:atgNULL">
    <xsl:param name="value" />
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="not($value) or $value=''">
          <xsl:value-of select="$atgNullValue" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:keyBenefitAreaList">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/KeyBenefitArea">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat($atgCTN,'_',KeyBenefitAreaCode,'_',$catalog)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:commSpecChapterList">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/CSChapter">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat($atgCTN,'_',CSChapterCode,'_',$catalog)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>
  
  <xsl:function name="my:navigationGroupList">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/NavigationGroup">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat($atgCTN,'_',NavigationGroupCode,'_',$catalog)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>
  
  <xsl:function name="my:featureList">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/KeyBenefitArea/Feature">
        <xsl:sort select="FeatureTopRank" data-type="number" order="ascending" />
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="FeatureCode" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>
  
  <xsl:function name="my:freeFormatCommSpecValues">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/CSChapter/CSItem[CSItemIsFreeFormat = 1]/CSValue">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="CSValueCode" />
        <xsl:text>=</xsl:text>
        <xsl:value-of select="my:escapeFreeFormatValue(CSValueName)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:systemLogos">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/SystemLogo">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat(SystemLogoRank,'=',SystemLogoCode)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:featureLogos">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/FeatureLogo">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="concat(FeatureLogoRank,'=',FeatureCode)" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:featureImageList">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/FeatureImage">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="FeatureCode" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:partnerLogoList">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/PartnerLogo">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="PartnerLogoCode" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:assetMapForProductTranslation">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:param name="locale" />
    <xsl:variable name="result">
      <xsl:for-each-group select="$prdNode/AssetList/Asset[ResourceType='PRM']" group-by="ResourceType">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <!--PWS=product-SGP9200_00_US_CONSUMER-PWS-->
        <xsl:value-of select="concat(current-grouping-key(),'=product-',$atgCTN,'_',$catalog,'-',current-grouping-key(),'-',$locale)" />
      </xsl:for-each-group>
      <!-- Virtual assets -->
      <xsl:variable name="v_comma" select="if($prdNode/AssetList/Asset[ResourceType='PRM']) then ',' else ''" />
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:assetMap">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:variable name="temp">
      <xsl:for-each-group select="$prdNode/AssetList/Asset[not(ResourceType=('GAL','IMS','PRM'))]" group-by="ResourceType">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <!--PWS=product-SGP9200_00_US_CONSUMER-PWS-->
        <xsl:value-of select="concat(current-grouping-key(),'=product-',$atgCTN,'_',$catalog,'-',current-grouping-key())" />
      </xsl:for-each-group>
    </xsl:variable>
	<xsl:variable name="result">
		<xsl:variable name="v_comma" select="if($prdNode/AssetList/Asset) then ',' else ''" />
		<xsl:if test="$temp != ''">
		<!-- Virtual assets -->
		  <xsl:value-of select="concat($temp,$v_comma,'IMS=product-',$atgCTN,'_',$catalog,'-IMS')" />
		  <xsl:value-of select="concat(',GAL=product-',$atgCTN,'_',$catalog,'-GAL')" />
		<xsl:if test="$prdNode/AssetList/Asset[ResourceType='P3D']">
			<xsl:value-of select="concat(',P3D=product-',$atgCTN,'_',$catalog,'-P3D')" />
		</xsl:if>
		</xsl:if>
		<xsl:if test="$temp = ''">
		<!-- Virtual assets -->
		  <xsl:value-of select="concat('IMS=product-',$atgCTN,'_',$catalog,'-IMS')" />
		  <xsl:value-of select="concat(',GAL=product-',$atgCTN,'_',$catalog,'-GAL')" />
		<xsl:if test="$prdNode/AssetList/Asset[ResourceType='P3D']">
			<xsl:value-of select="concat(',P3D=product-',$atgCTN,'_',$catalog,'-P3D')" />
		</xsl:if>
		</xsl:if>
	 </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>  
  <!--  -->
  <xsl:function name="my:productRefsListMap">
    <xsl:param name="prdNode"/>
    <xsl:param name="catalog"/>
    <xsl:param name="atgCTN"/>
    <xsl:variable name="result">
      <xsl:for-each-group select="$prdNode/ProductReferences" group-by="@ProductReferenceType">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:variable name="refKey" select="upper-case(substring(current-grouping-key(),1,3)) " />
        <xsl:variable name="refItem" select="concat($atgCTN,'_',$catalog,'-',$refKey) " />
        <!-- ACC=SGP9200_00_US_CONSUMER-ACC-->
        <xsl:value-of select="concat($refKey,'=',$refItem)" />
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:disclaimerList">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each
        select="$prdNode/Disclaimer[DisclaimerName!=''][not(DisclaimerCode=preceding-sibling::Disclaimer/DisclaimerCode) ]">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="DisclaimerCode" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:accessoryByPackedList">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:for-each select="$prdNode/AccessoryByPacked">
        <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="AccessoryByPackedCode" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:accessories">
    <xsl:param name="prdNode" />
    <xsl:param name="catalog" />
    <xsl:variable name="result">
      <xsl:when test="$prdNode/ProductReferences[@ProductReferenceType='Accessory']/CTN">
        <!-- new situation -->
        <xsl:for-each select="$prdNode/ProductReferences[@ProductReferenceType='Accessory']/CTN">
          <xsl:sort order="ascending" select="number(@rank)" />
          <xsl:if test="position() != 1">
          <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="concat(my:normalized-id(.),'_',$catalog)" />
        </xsl:for-each>
      </xsl:when>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>

  <xsl:function name="my:greenProduct">
    <xsl:param name="prdNode" />
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="$prdNode/GreenData/PhilipsGreenLogo[@isGreenProduct='true' and @publish='true'] or $prdNode/Award[AwardCode='GA_GREEN']"> 
          <xsl:value-of select="'1'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$result" />
  </xsl:function>
  <xsl:function name="my:ecoFlower">
    <xsl:param name="prdNode"/>
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="$prdNode/GreenData/EcoFlower[@isEcoFlowerProduct='true' and @publish='true']"> 
          <xsl:value-of select="'1'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$result"/>
  </xsl:function>
  <!--
     | TEMPLATES     
     |-->
  <xsl:template name="key-benefit-area-list">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:for-each select="KeyBenefitArea">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="key-benefit-area-list"
                id="{concat($atgCTN,'_',KeyBenefitAreaCode,'_',$catalog)}">
        <set-property name="keyBenefitArea">
          <xsl:value-of select="KeyBenefitAreaCode" />
        </set-property>
        <set-property name="features">
          <xsl:for-each select="Feature">
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="FeatureCode" />
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="comm-spec-item-list">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:for-each select="CSChapter/CSItem">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-item-list"
                id="{concat($atgCTN,'_',CSItemCode,'_',$catalog)}">
        <set-property name="commSpecItem">
          <xsl:value-of select="CSItemCode" />
        </set-property>
        <set-property name="values">
          <xsl:for-each select="CSValue">
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="CSValueCode" />
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="comm-spec-chapter-list">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:for-each select="CSChapter">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter-list"
                id="{concat($atgCTN,'_',CSChapterCode,'_',$catalog)}">
        <set-property name="commSpecChapter">
          <xsl:value-of select="CSChapterCode" />
        </set-property>
        <set-property name="items">
          <xsl:for-each select="CSItem">
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="concat($atgCTN,'_',CSItemCode,'_',$catalog)" />
            <!--xsl:value-of select="CSItemCode"/-->
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="navigation-group-list">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:for-each select="NavigationGroup">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-chapter-list"
                id="{concat($atgCTN,'_',NavigationGroupCode,'_',$catalog)}">
        <set-property name="commSpecChapter">
          <xsl:value-of select="NavigationGroupCode" />
        </set-property>
        <set-property name="items">
          <xsl:for-each select="NavigationAttribute">
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="concat($atgCTN,'_',NavigationAttributeCode,'_',$catalog)" />
            <!--xsl:value-of select="NavigationAttributeCode"/-->
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="navigation-attribute-list">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:for-each select="NavigationGroup/NavigationAttribute">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="comm-spec-item-list"
                id="{concat($atgCTN,'_',NavigationAttributeCode,'_',$catalog)}">
        <set-property name="commSpecItem">
          <xsl:value-of select="NavigationAttributeCode" />
        </set-property>
        <set-property name="values">
          <xsl:for-each select="NavigationValue">
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <!--xsl:value-of select="concat($atgCTN,'_',NavigationValueCode,'_',$catalog)"/-->
            <xsl:value-of select="NavigationValueCode" />
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="virtualAssets">
    <xsl:param name="docType" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:param name="locale" />
    
    <xsl:variable name="localisation">
          <xsl:value-of select="replace($locale,'-','_')" />
    </xsl:variable>
          
    <xsl:choose>
      <xsl:when test="AssetList/Asset/ResourceType = $docType ">
        <xsl:for-each select="AssetList/Asset[ResourceType=$docType]">
          
          <xsl:variable name="suffixId">
            <xsl:value-of select="format-number(position(),'000')" />
          </xsl:variable>
          <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="asset"
                    id="{concat('product-',$atgCTN,'_',$catalog,'-',$docType,'-',$localisation,'-',$suffixId)}">
            <set-property name="locale">
              <xsl:choose>
                <xsl:when test="Language='' ">
                  <xsl:value-of select="$atgNullValue" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace(Language,'-','_')" />
                </xsl:otherwise>
              </xsl:choose>
            </set-property>
            <set-property name="documentType">
              <xsl:value-of select="$docType" />
            </set-property>
            <set-property name="mimeType">
              <xsl:value-of select="Format" />
            </set-property>
            <set-property name="fileSize">
              <xsl:value-of select="if(number(Extent)) then Extent else '0'" />
            </set-property>
            <set-property name="externalUrl">http://</set-property>
            <set-property name="internalUrl">http://</set-property>
            <set-property name="imagingServerId">
              <xsl:value-of select="concat($atgCTN, '-',$docType,'-',$localisation)" />
            </set-property>
          </add-item>
        </xsl:for-each>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList"
                  id="{concat('product-',$atgCTN,'_',$catalog,'-',$docType)}">
          <xsl:for-each select="AssetList/Asset[ResourceType=$docType]">
            <xsl:variable name="localisation">
              <xsl:choose>
                <xsl:when test="Language = '' ">
                  <xsl:text>global</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace(Language,'-','_')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="suffixId">
              <xsl:value-of select="format-number(position(),'000')" />
            </xsl:variable>
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <set-property name="assets">
              <xsl:value-of select="concat('product-',$atgCTN,'_',$catalog,'-',$docType,'-',$localisation,'-',$suffixId) " />
            </set-property>
          </xsl:for-each>
        </add-item>
      </xsl:when>
      <xsl:otherwise>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="asset" 
                  id="{concat('product-',$atgCTN,'_',$catalog,'-',$docType,'-',$localisation,'-001')}">
          <set-property name="locale">
            <xsl:value-of select="$atgNullValue" />
          </set-property>
          <set-property name="documentType">
            <xsl:value-of select="$docType" />
          </set-property>
          <set-property name="mimeType">image/jpeg</set-property>
          <set-property name="fileSize">0</set-property>
          <set-property name="externalUrl">http://</set-property>
          <set-property name="internalUrl">http://</set-property>
          <set-property name="imagingServerId">
            <xsl:value-of select="concat($atgCTN, '-',$docType,'-',$localisation)" />
          </set-property>
        </add-item>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList"
                  id="{concat('product-',$atgCTN,'_',$catalog,'-',$docType)}">
          <set-property name="assets">
            <xsl:value-of select="concat('product-',$atgCTN,'_',$catalog,'-',$docType,'-',$localisation,'-001') " />
          </set-property>
        </add-item>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="assetList">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:param name="locale" />
    <xsl:for-each-group select="AssetList/Asset[not(ResourceType=('P3D','GAL','IMS'))] " group-by="ResourceType">
      <xsl:for-each select="current-group()">
        <xsl:variable name="localisation">
          <xsl:choose>
            <xsl:when test="Language = '' ">
              <xsl:text>global</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="replace(Language,'-','_')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="suffixId">
          <xsl:value-of select="format-number(position(),'000')" />
        </xsl:variable>
        <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="asset"
                  id="{concat('product-',$atgCTN,'_',$catalog,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)}">
          <xsl:variable name="localisation">
            <xsl:choose>
              <xsl:when test="Language = '' ">
                <xsl:text>global</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="replace(Language,'-','_')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <set-property name="locale">
            <xsl:choose>
              <xsl:when test="Language='' ">
                <xsl:value-of select="$atgNullValue" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="replace(Language,'-','_')" />
              </xsl:otherwise>
            </xsl:choose>
          </set-property>
          <set-property name="documentType">
            <xsl:value-of select="ResourceType" />
          </set-property>
          <set-property name="mimeType">
            <xsl:value-of select="Format" />
          </set-property>
          <set-property name="fileSize">
            <xsl:value-of select="if(number(Extent)) then Extent else '0'" />
          </set-property>
          <xsl:choose>
            <xsl:when test="PublicResourceIdentifier !='' ">
              <xsl:variable name="ext" select="tokenize(PublicResourceIdentifier,'\.')[last()]" />
              <set-property name="externalUrl">
                <xsl:value-of select="PublicResourceIdentifier" />
              </set-property>
              <xsl:choose>
                <!--/catalog/SGP9200_00-PWS-global-001.jpg -->
                <xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
                  <set-property name="internalUrl">
                    <xsl:value-of select="concat('/consumerfiles/catalog/',$atgCTN, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )" />
                  </set-property>
                </xsl:when>
                <xsl:otherwise>
                  <set-property name="internalUrl">__NULL__</set-property>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="ext" select="tokenize(InternalResourceIdentifier,'\.')[last()]" />
              <set-property name="externalUrl">
                <xsl:value-of select="InternalResourceIdentifier" />
              </set-property>
              <xsl:choose>
                <!--/catalog/SGP9200_00-PWS-global-001.jpg -->
                <xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
                  <set-property name="internalUrl">
                    <xsl:value-of select="concat('/consumerfiles/catalog/',$atgCTN, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )" />
                  </set-property>
                </xsl:when>
                <xsl:otherwise>
                  <set-property name="internalUrl">__NULL__</set-property>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$doctypesfile/doctypes/doctype[@Scene7='yes' and @code=current-grouping-key()]">
              <set-property name="imagingServerId">
                <xsl:value-of select="concat($atgCTN, '-',current-grouping-key(),'-',$localisation,'-',$suffixId )" />
              </set-property>
            </xsl:when>
            <xsl:otherwise>
              <set-property name="imagingServerId">__NULL__</set-property>
            </xsl:otherwise>
          </xsl:choose>
        </add-item>
      </xsl:for-each>
      <!-- id=product-SGP9200_00_US_CONSUMER-DFU-->
      <xsl:variable name="assetId"
        select="if(current-grouping-key()='PRM') then concat('product-',$atgCTN,'_',$catalog,'-',current-grouping-key(),'-',$locale) 
                                                                            else concat('product-',$atgCTN,'_',$catalog,'-',current-grouping-key())" />
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList" id="{$assetId}">
        <set-property name="assets">
          <xsl:for-each select="current-group()">
            <xsl:variable name="localisation">
              <xsl:choose>
                <xsl:when test="Language = '' ">
                  <xsl:text>global</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace(Language,'-','_')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="suffixId">
              <xsl:value-of select="format-number(position(),'000')" />
            </xsl:variable>
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <!-- "product-SGP9200_00_US_CONSUMER-PWS-global-001,product-SGP9200_00_US_CONSUMER-PWS-global-002</ -->
            <xsl:value-of select="concat('product-',$atgCTN,'_',$catalog,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)" />
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each-group>
    <!-- Virtual assets -->
    <xsl:call-template name="virtualAssets">
      <xsl:with-param name="docType" select="'IMS'" />
      <xsl:with-param name="catalog" select="$catalog" />
      <xsl:with-param name="atgCTN" select="$atgCTN" />
      <xsl:with-param name="locale" select="$locale" />
    </xsl:call-template>
    <xsl:call-template name="virtualAssets">
      <xsl:with-param name="docType" select="'GAL'" />
      <xsl:with-param name="catalog" select="$catalog" />
      <xsl:with-param name="atgCTN" select="$atgCTN" />
      <xsl:with-param name="locale" select="$locale" />
    </xsl:call-template>
    <xsl:if test="AssetList/Asset[ResourceType='P3D']">
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="asset" 
                id="{concat('product-',$atgCTN,'_',$catalog,'-P3D-global-001')}">
        <set-property name="locale">
          <xsl:value-of select="$atgNullValue" />
        </set-property>
        <set-property name="documentType">P3D</set-property>
        <set-property name="mimeType">image/jpeg</set-property>
        <set-property name="fileSize">0</set-property>
        <set-property name="externalUrl">http://</set-property>
        <set-property name="internalUrl">http://</set-property>
        <set-property name="imagingServerId">
          <xsl:value-of select="concat($atgCTN, '-P3D-global')" />
        </set-property>
      </add-item>
      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="assetList"
                id="{concat('product-',$atgCTN,'_',$catalog,'-','P3D')}">
        <set-property name="assets">
          <xsl:value-of select="concat('product-',$atgCTN,'_',$catalog,'-P3D-global-001') " />
        </set-property>
      </add-item>
    </xsl:if>
  </xsl:template>

  <xsl:template name="productRefsList">
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:param name="locale" />
    <xsl:for-each-group select="ProductReferences" group-by="@ProductReferenceType">
      <xsl:variable name="refKey" select="upper-case(substring(current-grouping-key(),1,3)) " />
      <xsl:variable name="refItem" select="concat($atgCTN,'_',$catalog,'-',$refKey) " />
      <!-- ACC=SGP9200_00_US_CONSUMER-ACC-->
      <xsl:for-each select="current-group()/CTN">
        <xsl:variable name="suffixId">
          <xsl:value-of select="format-number(position(),'000')" />
        </xsl:variable>
        <add-item item-descriptor="productReference" id="{concat($refItem,'-',$suffixId)}" repository="/atg/commerce/catalog/ProductCatalog">
          <set-property name="rank">
            <xsl:value-of select="position()" />
          </set-property>
          <set-property name="ctn">
            <xsl:value-of select="." />
          </set-property>
        </add-item>
      </xsl:for-each>

      <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="productReferenceList" id="{$refItem}">
        <set-property name="productReferences">
          <xsl:for-each select="current-group()/CTN">
            <xsl:variable name="suffixId">
              <xsl:value-of select="format-number(position(),'000')" />
            </xsl:variable>
            <xsl:if test="position() != 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="concat($refItem,'-',$suffixId)" />
          </xsl:for-each>
        </set-property>
      </add-item>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template name="product-translation">
    <xsl:param name="catalogLocale" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <xsl:param name="locale" />
    <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product-translation"
              id="{concat($atgCTN,'_',$catalogLocale)}">
      <set-property name="subWowDescription">
        <xsl:value-of select="my:atgNULL(SubWOW)" />
      </set-property>
      <set-property name="shortDescription">
        <xsl:choose>
          <xsl:when test="ShortDescription">
            <xsl:value-of select="my:atgNULL(ShortDescription)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="my:atgNULL(WOW)" />
          </xsl:otherwise>
        </xsl:choose>
      </set-property>
      <set-property name="wowDescription">
        <xsl:value-of select="my:atgNULL(WOW)" />
      </set-property>
      <set-property name="marketingHeader">
        <xsl:value-of select="my:atgNULL(MarketingTextHeader)" />
      </set-property>
      <set-property name="descriptorTranslation">
        <xsl:value-of select="my:atgNULL(NamingString/Descriptor/DescriptorName)" />
      </set-property>
      <set-property name="marketingBody">
        <xsl:value-of select="my:atgNULL(MarketingTextBody)" />
      </set-property>
      <set-property name="brandedFeature">
        <xsl:value-of select="my:atgNULL(NamingString/BrandedFeatureString)" />
      </set-property>
      <set-property name="descriptorBrandedFeature">
        <xsl:value-of select="my:atgNULL(NamingString/DescriptorBrandedFeatureString)" />
      </set-property>
      <set-property name="shoppingDescription">
        <!-- Hard-coding property to null, not part of xUCDM -->
        <xsl:value-of select="$atgNullValue" />
      </set-property>
      <set-property name="displayName">
        <xsl:choose>
          <xsl:when test="my:atgNULL(ProductName) = '__NULL__'">
            <xsl:value-of select="my:atgNULL(NamingString/Descriptor/DescriptorName)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="ProductName" />
          </xsl:otherwise>
        </xsl:choose>
        <!--xsl:value-of select="my:atgNULL(ProductName)"/-->
      </set-property>
      <set-property name="freeFormatCommSpecValues">
        <xsl:value-of select="my:freeFormatCommSpecValues(.)" />
      </set-property>
      <set-property name="versionString">
        <xsl:value-of select="my:atgNULL(NamingString/VersionString)" />
      </set-property>
      <set-property name="brandString">
        <xsl:value-of select="my:atgNULL(NamingString/BrandString)" />
      </set-property>
      <set-property name="brandString2">
        <xsl:value-of select="my:atgNULL(NamingString/BrandString2)" />
      </set-property>
      <set-property name="seoName">
        <xsl:value-of select="my:atgNULL(lower-case(SEOProductName))" />
      </set-property>      
      <set-property name="assetMap">
        <xsl:value-of select="my:assetMapForProductTranslation(.,$catalog,$atgCTN,$locale)" />
      </set-property>
    </add-item>
  </xsl:template>
  <xsl:template name="full-product">
    <xsl:param name="catalogLocale" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product"
              id="{concat($atgCTN,'_',$catalog)}">
      <set-property name="supraFeature">
        <xsl:value-of select="my:atgNULL(SupraFeature/SupraFeatureCode)" />
      </set-property>
      <!-- modified for Green2 -->
      <set-property name="green">
        <xsl:value-of select="my:greenProduct(.)" />
      </set-property>
      <!-- added for Green2 -->
      <set-property name="isEcoFlower">
        <xsl:value-of select="my:ecoFlower(.)"/>
      </set-property>
      <set-property name="energyClassLabel">
        <xsl:value-of select="GreenData/EnergyLabel/EnergyClasses/EnergyClass/Value"/>
      </set-property>
      <set-property name="energyClassRank">
        <xsl:value-of select="GreenData/EnergyLabel/EnergyClasses/EnergyClass/@rank"/>
      </set-property>
      <!-- end Green2 modifications -->
      <set-property name="translations" add="true">
        <xsl:value-of select="concat($catalogLocale,'=',$atgCTN,'_',$catalogLocale)" />
      </set-property>
      <set-property name="basicTypeCode">
        <!-- Hard-coding to null. Property not in xUCDM -->
        <xsl:value-of select="$atgNullValue" />
      </set-property>
      <set-property name="startDate">
        <xsl:value-of select="@StartOfPublication" />
      </set-property>
      <set-property name="startMarketingPubDate">
        <xsl:value-of select="@StartOfMarketingPublication" />
      </set-property>
      <set-property name="deleteAfterDate">
        <xsl:value-of select="my:atgNULL(@DeleteAfterDate)" />
      </set-property>
      <set-property name="availability">
        <!-- Hard-coding to null. Property not in xUCDM -->
        <xsl:value-of select="$atgNullValue" />
      </set-property>
      <set-property name="versionElem4">
        <xsl:value-of select="my:atgNULL(NamingString/VersionElement4/VersionElementCode)" />
      </set-property>
      <set-property name="versionElem3">
        <xsl:value-of select="my:atgNULL(NamingString/VersionElement3/VersionElementCode)" />
      </set-property>
      <set-property name="versionElem2">
        <xsl:value-of select="my:atgNULL(NamingString/VersionElement2/VersionElementCode)" />
      </set-property>
      <set-property name="descriptor">
        <xsl:value-of select="my:atgNULL(NamingString/Descriptor/DescriptorCode)" />
      </set-property>
      <set-property name="versionElem1">
        <xsl:value-of select="my:atgNULL(NamingString/VersionElement1/VersionElementCode)" />
      </set-property>
      <set-property name="featureImageList">
        <xsl:value-of select="my:featureImageList(.)" />
      </set-property>
      <set-property name="isAvailableOnline">
        <xsl:value-of select="my:atgNULL(@BuyOnline)" />
      </set-property>
      <set-property name="keyBenefitAreaList">
        <xsl:value-of select="my:keyBenefitAreaList(.,$catalog,$atgCTN)" />
      </set-property>
      <set-property name="onlinePrice"><!-- DEPRECATED -->
        <xsl:value-of select="my:atgNULL('')" />
      </set-property>
      <set-property name="systemLogos">
        <xsl:value-of select="my:systemLogos(.)" />
      </set-property>
      <set-property name="alphanumeric">
        <xsl:value-of select="my:atgNULL(NamingString/Alphanumeric)" />
      </set-property>
      <set-property name="priority">
        <xsl:value-of select="my:atgNULL(@Priority)" />
      </set-property>
      <set-property name="dtn">
        <xsl:value-of select="DTN" />
      </set-property>
      <set-property name="endDate">
        <xsl:value-of select="@EndOfPublication" />
      </set-property>
      <set-property name="source">
        <xsl:value-of select="'TRIGO'" />
      </set-property>
      <set-property name="subBrand">
        <!--
        <xsl:value-of select="my:atgNULL(NamingString/SubBrand/BrandCode)"/>
        <xsl:value-of select="my:atgNULL(NamingString/Partner[1]/PartnerBrand/BrandCode)"/>        
      -->
        <xsl:value-of select="'__NULL__'" />
      </set-property>
      <set-property name="masterBrand">
        <xsl:value-of select="my:atgNULL(NamingString/MasterBrand/BrandCode)" />
      </set-property>
      <set-property name="commSpecChapterList">
        <xsl:value-of select="my:commSpecChapterList(.,$catalog,$atgCTN)" />
      </set-property>
      <set-property name="navigationAttributeList">
        <xsl:value-of select="my:navigationGroupList(.,$catalog,$atgCTN)" />
      </set-property>
      <set-property name="partnerLogoList">
        <xsl:value-of select="my:partnerLogoList(.)" />
      </set-property>
      <set-property name="ctn">
        <xsl:value-of select="CTN" />
      </set-property>
      <set-property name="divisionId">
        <xsl:value-of select="@DivisionCode" />
      </set-property>
      <set-property name="catalog">
        <xsl:value-of select="concat('catalog_',$catalog)" />
      </set-property>
      <set-property name="featureLogos">
        <xsl:value-of select="my:featureLogos(.)" />
      </set-property>
      <xsl:variable name="one" as="xsl:byte">1</xsl:variable>
      <xsl:choose>
        <xsl:when test="NamingString/Concept/ConceptNameUsed = $one">
          <set-property name="concept">
            <xsl:value-of select="my:atgNULL(NamingString/Concept/ConceptCode)" />
          </set-property>
          <set-property name="conceptNameUsed">true</set-property>
        </xsl:when>
        <xsl:otherwise>
          <set-property name="concept">
            <xsl:value-of select="$atgNullValue" />
          </set-property>
          <set-property name="conceptNameUsed">false</set-property>
        </xsl:otherwise>
      </xsl:choose>
      <!-- family name and code set up in xucdm -->
      <xsl:choose>
        <xsl:when test="NamingString/Family/FamilyNameUsed = $one">
          <set-property name="family">
            <xsl:value-of select="my:atgNULL(NamingString/Family/FamilyCode)" />
          </set-property>
          <set-property name="familyNameUsed">true</set-property>
        </xsl:when>
        <xsl:otherwise>
          <set-property name="family">
            <xsl:value-of select="$atgNullValue" />
          </set-property>
          <set-property name="familyNameUsed">false</set-property>
        </xsl:otherwise>
      </xsl:choose>
      <set-property name="partnerBrand">
        <xsl:value-of select="my:atgNULL(NamingString/Partner[1]/PartnerBrand/BrandCode)" />
      </set-property>
      <set-property name="partnerBrandType">
        <xsl:value-of select="my:atgNULL(NamingString/Partner[1]/PartnerBrandType)" />
      </set-property>
      <set-property name="partnerProductName">
        <xsl:value-of select="my:atgNULL(NamingString/Partner[1]/PartnerProductName)" />
      </set-property>
      <set-property name="partnerProductIdentifier">
        <xsl:value-of select="my:atgNULL(NamingString/Partner[1]/PartnerProductIdentifier)" />
      </set-property>
      <set-property name="featureList">
        <xsl:value-of select="my:featureList(.)" />
      </set-property>
      <set-property name="shippingCategory">
        <!-- Hard-coding to NULL. Property not in xUCDM -->
        <xsl:value-of select="$atgNullValue" />
      </set-property>
      <set-property name="deleted">
        <xsl:value-of select="@Deleted" />
      </set-property>
      <set-property name="suggestedRetailPrice">
        <xsl:value-of select="my:atgNULL(@LocalGoingPrice)" />
      </set-property>
      <set-property name="isAccessory">
        <xsl:choose>
          <xsl:when test="@IsAccessory='1'">
            <xsl:text>true</xsl:text>
          </xsl:when>
          <xsl:when test="@IsAccessory='0'">
            <xsl:text>false</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@IsAccessory" />
          </xsl:otherwise>
        </xsl:choose>
      </set-property>
      <set-property name="descriptorBrandedFeatureDefault">
        <xsl:value-of select="my:atgNULL(@MasterDescriptorBrandedFeatureString)" />
      </set-property>
      <set-property name="disclaimerList">
        <xsl:value-of select="my:disclaimerList(.)" />
      </set-property>
      <set-property name="accessoryByPackedList">
        <xsl:value-of select="my:accessoryByPackedList(.)" />
      </set-property>
      <!-- 2009-05-25 disabled pending resolution of data integrity issue -->
      <!--
      <set-property name="accessories">
        <xsl:value-of select="my:accessories(.,$catalog)"/>
      </set-property>
      -->
      <set-property name="assetMap">
        <xsl:value-of select="my:assetMap(.,$catalog,$atgCTN)" />
      </set-property>
      <set-property name="productRefsListMap">
       <xsl:value-of select="my:productRefsListMap(.,$catalog,$atgCTN)"/>
      </set-property>
    </add-item>
  </xsl:template>
  
  <xsl:template match="node()" mode="escape">
    <xsl:value-of select="concat('&lt;',local-name())" />
    <xsl:apply-templates select="@*" mode="escape" />
    <xsl:value-of select="concat('&gt;',text())" />
    <xsl:apply-templates select="child::node()[local-name() != '']" mode="escape" />
    <xsl:value-of select="concat('&lt;/',local-name(),'&gt;')" />
  </xsl:template>
  
  <xsl:template match="@*" mode="escape">
    <xsl:value-of select="concat(' ',local-name(),'=&quot;',.,'&quot;')" />
    <xsl:apply-templates select="@*|node()" mode="escape" />
  </xsl:template>
  
  <xsl:template name="deleted-product">
    <xsl:param name="catalogLocale" />
    <xsl:param name="catalog" />
    <xsl:param name="atgCTN" />
    <add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="product"
      id="{concat($atgCTN,'_',$catalog)}">
      <set-property name="startDate">
        <xsl:value-of select="@StartOfPublication" />
      </set-property>
      <set-property name="deleteAfterDate">
        <xsl:value-of select="my:atgNULL(@DeleteAfterDate)" />
      </set-property>
      <set-property name="deleted">
        <xsl:value-of select="@Deleted" />
      </set-property>
      <set-property name="endDate">
        <xsl:value-of select="@EndOfPublication" />
      </set-property>
    </add-item>    
  </xsl:template>
  
  <xsl:template match="/Products">
    <gsa-template>
      <import-items>
        <xsl:for-each select="Product">
          <xsl:variable name="lastModified" select="@lastModified" as="xsl:dateTime" />
          <xsl:variable name="lastExportDate" select="@LastExportDate" as="xsl:dateTime" />
          <xsl:variable name="isDeleted" select="@isDeleted" />
          <xsl:if test="$lastModified &gt; $lastExportDate">
            <xsl:variable name="catalogLocale" select="concat(@Locale  ,'_',@Catalog)" />
            <xsl:variable name="catalog" select="concat(@Country  ,'_',@Catalog)" />
            <xsl:variable name="atgCTN" select="my:normalized-id(CTN)" />
            <xsl:choose>
              <xsl:when test="$isDeleted ='yes'">
                <xsl:call-template name="deleted-product">
                  <xsl:with-param name="catalogLocale" select="$catalogLocale" />
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="key-benefit-area-list">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
                <xsl:call-template name="comm-spec-item-list">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
                <xsl:call-template name="comm-spec-chapter-list">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
                <xsl:call-template name="navigation-attribute-list">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
                <xsl:call-template name="navigation-group-list">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
                <xsl:call-template name="product-translation">
                  <xsl:with-param name="catalogLocale" select="$catalogLocale" />
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                  <xsl:with-param name="locale" select="@Locale" />
                </xsl:call-template>
                <xsl:call-template name="assetList">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                  <xsl:with-param name="locale" select="@Locale" />
                </xsl:call-template>
                <xsl:call-template name="productRefsList">
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                  <xsl:with-param name="locale" select="@Locale" />
                </xsl:call-template>
                <xsl:call-template name="full-product">
                  <xsl:with-param name="catalogLocale" select="$catalogLocale" />
                  <xsl:with-param name="catalog" select="$catalog" />
                  <xsl:with-param name="atgCTN" select="$atgCTN" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </import-items>
    </gsa-template>
  </xsl:template>
</xsl:stylesheet>
