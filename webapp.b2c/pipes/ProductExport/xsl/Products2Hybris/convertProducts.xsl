<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
            >  

  <!--  base the transformation on the default xUCDM transformation -->
  <xsl:import href="../xUCDM.CQ.convertProducts.xsl" />
  
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/> 

  <xsl:template match="Products">
    <Products>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:attribute name="DocType" select="sql:rowset/sql:row[1]/sql:content_type"/>
      <xsl:attribute name="DocVersion"><xsl:text>xUCDM_product_external_CQ5_1_1_25</xsl:text></xsl:attribute> 
      <xsl:apply-templates select="node()"/>
    </Products>
  </xsl:template>
  
  <xsl:template match="sql:rowset[@name='Refs']"/>
  
  <xsl:template match="Product">
    <Product>
      <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]"/>
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
      <xsl:if test="@masterLastModified">
        <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))"/>
      </xsl:if>
      <xsl:choose>
                <xsl:when test="@Locale != ''">
                </xsl:when>
                <xsl:otherwise>
                <xsl:attribute name="Locale">en_QQ</xsl:attribute>
				<xsl:attribute name="Country">QQ</xsl:attribute>
				</xsl:otherwise>
      </xsl:choose>
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
      
      <xsl:call-template name="doReviewStatistics"/>
      
      <xsl:call-template name="doAccessories">
        <xsl:with-param name="cschapters"><csc><xsl:copy-of select="CSChapter"/></csc></xsl:with-param>
        <xsl:with-param name="abp"><abp><xsl:copy-of select="AccessoryByPacked"/></abp></xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="doAwards">
        <xsl:with-param name="Awards"><xsl:copy-of select="Award[not(@AwardType=('ala_semantic','ala_user','ala_bv_summary','GA_GREEN','GA_ECOFLOWER'))]"/></xsl:with-param>
      </xsl:call-template>
   
      <ProductClusters>
        <xsl:call-template name="ProductCluster"/>
      </ProductClusters>
      
      <ProductRefs>
          <xsl:apply-templates select="ProductRefs/ProductReference|ProductReferences"/>
          
          <xsl:variable name="ctn" select="CTN"/>          
         <!--  <xsl:if test="/Products/sql:rowset[@name ='compatibleMotherProducts']/sql:row[sql:object_id_tgt=$ctn]/sql:motherproducts_id">          
	          <ProductReference>
	            <xsl:attribute name ="ProductReferenceType">Performer</xsl:attribute>
	            <xsl:for-each select="/Products/sql:rowset[@name ='compatibleMotherProducts']/sql:row[sql:object_id_tgt=$ctn]/sql:motherproducts_id">            
	                <CTN><xsl:value-of select="."/></CTN>
	            </xsl:for-each> 
	          </ProductReference>
          </xsl:if> -->
          
          <xsl:variable name="containsCTN" select="/Products/sql:rowset[@name='product']/sql:row/sql:rowset[@name ='Refs']/sql:row/sql:data/Product[CTN = $ctn]/ProductRefs/ProductReference[@ProductReferenceType='Contains']/CTN"/>
	        <xsl:if test="$containsCTN !=''">
	         <ProductReference>
	           <xsl:attribute name ="ProductReferenceType">Contains</xsl:attribute>
	           <xsl:for-each select="$containsCTN">            
	               <CTN><xsl:value-of select="."/></CTN>
	           </xsl:for-each> 
	         </ProductReference>
          </xsl:if>
        </ProductRefs>
        
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:if test="GreenData">
        <GreenData>
           <GreenAwards>           
             <xsl:if test="GreenData/PhilipsGreenLogo[@isGreenProduct='true']">
                <GreenAward code="GA_GREEN" name="PhilipsGreenLogo"/>
             </xsl:if>
             <xsl:if test="GreenData/EcoFlower[@isEcoFlowerProduct='true']">
                <GreenAward code="GA_ECOFLOWER" name="EcoFlower"/>
             </xsl:if>
             <xsl:if test="GreenData/TheBlueAngel[@isBlueAngelProduct='true']">
                <GreenAward code="GA_BLUEANGEL" name="TheBlueAngel"/>
             </xsl:if>
           </GreenAwards>
           <xsl:apply-templates select="GreenData/EnergyLabel"/>
           <xsl:apply-templates select="GreenData/GreenChapter"/>
        </GreenData>
       </xsl:if>
         
    </Product>
  </xsl:template>
  <!-- 
     | Country specific modifications because Java 6 (Atg) cannot handle the iso-value for the Israel locale.
     -->
  <xsl:template match="@Locale[.='he_IL']">
     <xsl:attribute name='Locale'><xsl:value-of select="'he_IL'" /></xsl:attribute>
  </xsl:template>
  <!-- -->
  <xsl:template match="@locale[.='he_IL']">
     <xsl:attribute name='locale'><xsl:value-of select="'he_IL'" /></xsl:attribute>
  </xsl:template>
  
  <!-- modify the GreenData-element (even more than in xUCDM.1.3.convertProducts.xsl" ) -->
  <xsl:template match="PhilipsGreenLogo/FocalAreas"/>
  <!-- -->
  <xsl:template match="Code[parent::PhilipsGreenLogo|parent::EcoFlower]"/>
  <xsl:template match="Name[parent::PhilipsGreenLogo|parent::EcoFlower]"/>
  <xsl:template match="Text[parent::PhilipsGreenLogo|parent::EcoFlower]"/>
  <xsl:template match="ShortDescription[parent::PhilipsGreenLogo|parent::EcoFlower]"/>
  <xsl:template match="LongDescription[parent::PhilipsGreenLogo|parent::EcoFlower]"/>
  <xsl:template match="EnergyClasses[parent::EnergyLabel[@publish='true']]">
      <xsl:apply-templates select="EnergyClass"/>
  </xsl:template>
  
  <xsl:template name="doReviewStatistics">
    <xsl:if test="ReviewStatistics">
        <xsl:apply-templates select="ReviewStatistics"/>
    </xsl:if>   
  </xsl:template>
  
</xsl:stylesheet>
