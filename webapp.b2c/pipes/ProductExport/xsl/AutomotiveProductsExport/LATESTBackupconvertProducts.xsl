<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                extension-element-prefixes="cmc2-f"
                exclude-result-prefixes="sql xsl cinclude data" 
            > 

  <!--  base the transformation on the default xUCDM transformation -->
  <!--  <xsl:import href="../../../common/xsl/xucdm-product-external.xsl"/>
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:include href="../../../../cmc2/xsl/common/cmc2.function.xsl"/> -->
   <xsl:import href="../xUCDM.1.1.convertProducts.xsl" />
   <!-- ETL -->
    
    <xsl:param name="doctypesfilepath"/>
    <xsl:param name="type"/>
    <xsl:param name="channel"/>
    <xsl:param name="asset-syndication"/>
  <xsl:param name="broker-level" select="''"/>
  <xsl:param name="system" select="'PikachuB2C'"/>
  
 <!--  <xsl:variable name="assetschannel">
    <xsl:choose>
     
     
      <xsl:when test="$broker-level != ''">
        <xsl:value-of select="concat('SyndicationL', $broker-level)"/>
      </xsl:when>
     
    </xsl:choose>
  </xsl:variable> -->
   
  <!-- ETL -->
    <xsl:template match="Products">
    <Products>
      <xsl:attribute name="DocTimeStamp" select="substring(string(current-dateTime()),1,19)"/>
      <xsl:attribute name="DocStatus" select="'approved'"/>
      <xsl:apply-templates select="node()"/>
    </Products>
  </xsl:template>
 <xsl:template match="Product">
    <Product>
    <xsl:attribute name="Country" select="@Country"/>
	    <xsl:attribute name="IsAccessory" select="@IsAccessory"/>
	    <xsl:attribute name="IsMaster" select="@IsMaster"/>
	    <xsl:attribute name="Locale" select="@Locale"/>
	    <xsl:attribute name="lastModified" select="@lastModified"/>
	    <xsl:attribute name="masterLastModified" select="@masterLastModified"/>
	    <xsl:attribute name="brandCode" select="NamingString/MasterBrand/BrandCode"/>
	    
	   	
	    <xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="CRDateYW"/>
      <ModelYears>
         <xsl:apply-templates select="ModelYear"/>
      </ModelYears>
      <xsl:apply-templates select="ProductDivision"/>
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="DTN"/>
      <xsl:apply-templates select="ProductType"/>
      
       
       
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
      
      <!-- ETL Assets -->
     <xsl:call-template name="doAssets">
        <xsl:with-param name="id" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
        <xsl:with-param name="catalogtype" select="../../sql:catalogtype"/>
      </xsl:call-template> 
       <!-- ETL Assets -->
   
     
   <xsl:apply-templates select="ProductName"/>
   <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>
   <xsl:apply-templates select="NamingString"/>
    <xsl:apply-templates select="WOW"/>
     <xsl:apply-templates select="SubWOW"/>
     <xsl:apply-templates select="MarketingTextHeader"/>
      <xsl:apply-templates select="KeyBenefitArea">
        <xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
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
  
</xsl:stylesheet>