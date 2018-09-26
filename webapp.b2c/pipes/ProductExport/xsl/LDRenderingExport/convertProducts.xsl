<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:dir="http://apache.org/cocoon/directory/2.0" 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                xmlns:local="http://www.philips.com/local"
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
                extension-element-prefixes="cmc2-f">

   <!-- Base the transformation on the default xUCDM transformation for B2B 
      | (as the Leaflet rendering is based on the structure of the B2B product export).
      |-->
   <xsl:import href="../xUCDM.1.2.B2B.convertProducts.xsl" />

   <xsl:param name="xmlDir"/>

   <!-- Get the relevant translations for this language -->
   <xsl:variable name="translations">
      <xsl:variable name="locale" select="/Products/sql:rowset/sql:row/sql:data/Product/@Locale"/>
      <xsl:variable name="filePath" select="concat($xmlDir, '/', 'Translation_LogisticData_', $locale[1], '.xml')"/>
      <xsl:if test="doc-available($filePath)">
         <xsl:copy-of select="document($filePath)/Translations/*"/>
      </xsl:if>
   </xsl:variable>

   <xsl:variable name="localesWithDecimalComma">
      <xsl:variable name="filePath" select="concat($xmlDir, '/', 'countriesWithDecimalComma.xml')"/>
      <xsl:if test="doc-available($filePath)">
         <xsl:variable name="document" select="document($filePath)"/>
         <xsl:value-of select="string-join($document/root/country/@locale, ',')"/>
      </xsl:if>
   </xsl:variable>
   <xsl:variable name="decimalCharacter">
      <xsl:variable name="locale" select="/Products/sql:rowset/sql:row/sql:data/Product/@Locale"/>
      <xsl:choose>
         <xsl:when test="matches($localesWithDecimalComma,$locale[1])">
            <xsl:text>,</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>.</xsl:text>
         </xsl:otherwise>
      </xsl:choose>      
   </xsl:variable>
   

   <!-- start matching -->
   <xsl:template match="/">
     <Products>
         <xsl:attribute name="xsi:noNamespaceSchemaLocation">xUCDM_product_marketing_1_2.xsd</xsl:attribute>
         <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
         <xsl:attribute name="DocStatus" select="'approved'"/>
         <xsl:attribute name="DocType" select="'PMT'"/>
         <xsl:attribute name="DocVersion"><xsl:text>xUCDM_product_marketing_1_2.xsd</xsl:text></xsl:attribute> 
         <xsl:apply-templates select="Products/sql:rowset/sql:row/sql:data/Product" /> 
     </Products>
   </xsl:template>
  
  <!--+
      +-->
  <xsl:template match="Product" exclude-result-prefixes="cinclude sql dir">
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
      <xsl:apply-templates select="ProductType"/>
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
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>
      <xsl:apply-templates select="ModelYears"/>
      <xsl:apply-templates select="ProductDivision"/>
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="DTN"/>
      <xsl:apply-templates select="ProductName"/>
      <xsl:if test="normalize-space(FullProductName/text()) != ''">
        <xsl:apply-templates select="FullProductName"/>
      </xsl:if>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <xsl:apply-templates select="KeyBenefitArea"/>
      <xsl:apply-templates select="SystemLogo"/>
      <xsl:apply-templates select="PartnerLogo"/>
      <xsl:apply-templates select="FeatureLogo"/>
      <xsl:apply-templates select="FeatureImage"/>
      <xsl:apply-templates select="FeatureHighlight"/>
      <!-- replaced with combined PFS/Logistic data chapters: 
         | xsl:apply-templates select="CSChapter[CSItem]"/-->
      <xsl:apply-templates select="../../sql:logisticdata">
        <xsl:with-param name="pfsChapters" select="CSChapter[CSItem]"/>
      </xsl:apply-templates>      
      <Filters>
        <xsl:apply-templates select="Filters/Purpose"/>
      </Filters>
      <xsl:call-template name="FilterKeys">
        <xsl:with-param name="ctn" select="CTN"/>
      </xsl:call-template>
      <FeatureCompareGroups>
         <xsl:apply-templates select="FeatureCompareGroups/FeatureCompareGroup"/>
      </FeatureCompareGroups>
      <Disclaimers>
         <xsl:apply-templates select="Disclaimers/Disclaimer"/>
      </Disclaimers>
      <KeyValuePairs>
        <xsl:call-template name="doKeyValuePairs"/>
      </KeyValuePairs>
      <xsl:call-template name="doAccessories">
        <xsl:with-param name="cschapters"><csc><xsl:copy-of select="CSChapter"/></csc></xsl:with-param>
        <xsl:with-param name="abp"><abp><xsl:copy-of select="AccessoryByPacked"/></abp></xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="Award"/>
      <ProductClusters>
        <xsl:call-template name="ProductCluster"/>
      </ProductClusters>
      <ProductRefs>
        <xsl:call-template name="doProductReference"/>
      </ProductRefs>
      <xsl:apply-templates select="SellingUpFeature"/>
      <xsl:apply-templates select="ConsumerSegment"/>
      
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      
      <xsl:variable name="remove-object-keys-dd" select="local:filter-object-keys-dd(RichTexts/RichText[@type='DimensionDiagramTable'], ObjectAssetList)"/>

      <xsl:apply-templates select="RichTexts">
        <xsl:with-param name="remove-object-keys-dd" select="$remove-object-keys-dd"/>
      </xsl:apply-templates>
      
      <xsl:apply-templates select="AssetList"/>
      <xsl:apply-templates select="ObjectAssetList">
        <xsl:with-param name="remove-object-keys-dd" select="$remove-object-keys-dd"/>
      </xsl:apply-templates>
    </Product>
  </xsl:template>

  <!-- Wrap Feature elements inside a Features element  -->
  <xsl:template match="KeyBenefitArea">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank|Feature"/>
    </xsl:copy>
  </xsl:template>

  <!-- Logistic Data -->
  <!-- Merge CSChapters from LogisticsData and PMT -->
  <xsl:template match="sql:logisticdata">
    <xsl:param name="pfsChapters"/>
    <xsl:copy-of select="$pfsChapters[not(CSChapterCode = current()/LogisticData/CSChapter/CSChapterCode)]"/> 
    <xsl:apply-templates select="LogisticData/CSChapter"/>
  </xsl:template>
  
  <!-- Translate the CSChapter contents -->
  <xsl:template match="CSChapterName|CSItemName|UnitOfMeasureName|UnitOfMeasureSymbol">
    <!-- Determine the code with which to find the translation -->
    <xsl:variable name="code">
      <xsl:choose>
        <xsl:when test="name() = 'CSChapterName'">
          <xsl:value-of select="../CSChapterCode"/>
        </xsl:when>
        <xsl:when test="name() = 'CSItemName'">
          <xsl:value-of select="../CSItemCode"/>
        </xsl:when>
        <xsl:when test="name() = ('UnitOfMeasureName', 'UnitOfMeasureSymbol')">
          <xsl:value-of select="../UnitOfMeasureCode"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- Find the translation phrase based on the code -->
    <xsl:variable name="phrase" select="$translations/Phrase[@code = $code]"/>
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="exists($phrase)">
          <!--+
              | Get the phrase content, take a sub-element when UoMs are
              | involved, there are two elements to be translated there
              +-->
          <xsl:choose>
            <xsl:when test="name() = ('CSChapterName', 'CSItemName', 'UnitOfMeasureName')">
               <xsl:value-of select="$phrase/Name"/>
            </xsl:when>
            <xsl:when test="name() = 'UnitOfMeasureSymbol'">
               <xsl:value-of select="$phrase/Symbol"/>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          #### TRANSLATION NOT FOUND ####
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <!-- -->
  <xsl:template match="CSChapter">
    <xsl:if test="CSItem[count(CSValue/CSValueCode) = count(CSValue/CSValueName)]">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>        
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="CSItem">
    <!-- only include csitems that are in product detail block in filters -->
    <xsl:if test="count(CSValue/CSValueCode) = count(CSValue/CSValueName)">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="CSValueName">
    <CSValueName>
      <xsl:choose>
         <xsl:when test="../../UnitOfMeasure[UnitOfMeasureCode=('3000039', '3000049')]">
         <!-- convert cm's/kg's; 
            | - make decimal-sign language dependent,
            | - reduce no. of decimals to two. 
            | -->
            <xsl:value-of select="replace(format-number(number(text()),'#.00'), '\.', $decimalCharacter)"/>
<!--
            <xsl:value-of select="format-number(number(text()),'#.##')"/>
-->    
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>      
    </CSValueName>
  </xsl:template>
  <!-- END Logistic Data -->

  
  <xsl:template match="ObjectAssetList">
    <xsl:param name="remove-object-keys-dd"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Object[not(id=$remove-object-keys-dd)]"/>
    </xsl:copy>
  </xsl:template>  

  <xsl:variable name="conditional-processed-images">LAS,LCD,LGU,LCC,LPC</xsl:variable>
  <xsl:template match="ObjectAssetList/Object">
    <xsl:copy copy-namespaces="no">
		<id><xsl:value-of select="id"/></id>
		<xsl:apply-templates select="Asset[not(contains($conditional-processed-images,ResourceType))]"/>
		<xsl:choose>
			<xsl:when test="Asset[ResourceType='LAS']">
				<xsl:apply-templates select="Asset[ResourceType='LAS']"/>
			</xsl:when>
			<xsl:when test="Asset[ResourceType='LCC']">
				<xsl:apply-templates select="Asset[ResourceType='LCC']"/>
			</xsl:when>
			<xsl:when test="Asset[ResourceType='LCD']">
				<xsl:apply-templates select="Asset[ResourceType='LCD']"/>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="Asset[ResourceType='LGU']">
				<xsl:apply-templates select="Asset[ResourceType='LGU']"/>
			</xsl:when>
			<xsl:when test="Asset[ResourceType='LPC']">
				<xsl:apply-templates select="Asset[ResourceType='LPC']"/>
			</xsl:when>
		</xsl:choose>
	</xsl:copy>
  </xsl:template>

   <xsl:template name="FilterKeys">
    <xsl:param name="ctn"/>
     <FilterKeys>
       <xsl:for-each select="ancestor::sql:rowset[@name='product']/sql:row[sql:id=$ctn]/sql:fkeys/Product/NavigationGroup/NavigationAttribute/NavigationValue">
          <Key> <!-- alternative: copy the whole NavigationGroup-element for all the Filter Keys -->
             <xsl:attribute name="navigationValueCode" select="NavigationValueCode" />
             <xsl:value-of select="NavigationValueName" />
          </Key>
       </xsl:for-each>
     </FilterKeys>
   </xsl:template>

</xsl:stylesheet>
