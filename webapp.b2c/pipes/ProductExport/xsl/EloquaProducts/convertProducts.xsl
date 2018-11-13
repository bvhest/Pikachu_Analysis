<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                extension-element-prefixes="asset-f"
            >  
            
  <xsl:import href="../xUCDM.1.4.convertProducts.xsl" />
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl"/>
  <xsl:variable name="domains" select="document('../../../../cmc2/xml/countryDomains.xml')/domains"/>
  
  <xsl:template match="Products">    
    <Products>
      <xsl:apply-templates select="node()"/>
    </Products>      
  </xsl:template>
    
  <xsl:template match="sql:rowset[@name='product']/sql:row/sql:data/Product">
    <Product>    
        
	    <xsl:attribute name="Country" select="@Country"/>
	    <xsl:attribute name="IsAccessory" select="@IsAccessory"/>
	    <xsl:attribute name="IsMaster" select="@IsMaster"/>
	    <xsl:attribute name="Locale" select="@Locale"/>
	    <xsl:attribute name="lastModified" select="@lastModified"/>
	    <xsl:attribute name="masterLastModified" select="@masterLastModified"/>
    
      <xsl:apply-templates select="CTN"/>
			<xsl:apply-templates select="DTN"/>			

      <xsl:call-template name="docatalogdataEloqua">
        <xsl:with-param name="sop" select="ancestor::sql:row/sql:sop"/>
        <xsl:with-param name="eop" select="ancestor::sql:row/sql:eop"/>
        <xsl:with-param name="sos" select="ancestor::sql:row/sql:sos"/>
        <xsl:with-param name="eos" select="ancestor::sql:row/sql:eos"/>
        <xsl:with-param name="lgp" select="ancestor::sql:row/sql:local_going_price"/>
        <xsl:with-param name="rank" select="ancestor::sql:row/sql:priority"/>
        <xsl:with-param name="deleted" select="ancestor::sql:row/sql:deleted"/>
        <xsl:with-param name="deleteafterdate" select="ancestor::sql:row/sql:deleteafterdate"/>
      </xsl:call-template>

      <xsl:call-template name="docategorizationEloqua">
        <xsl:with-param name="cats" select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row"/>
      </xsl:call-template>

      <xsl:call-template name="doAssetsEloqua">
        <xsl:with-param name="id" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
        <xsl:with-param name="catalogtype" select="../../sql:catalogtype"/>
      </xsl:call-template>

	  <xsl:apply-templates select="ProductName"/>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      
      <xsl:variable name="bv-review-statistics" select="ReviewStatistics/ReviewStatistics[@source='110117']"/>
      <ReviewStatistics>
        <AverageOverallRating>
          <xsl:value-of select="$bv-review-statistics/AverageOverallRating"/>
        </AverageOverallRating>
        <TotalReviewCount>
          <xsl:value-of select="if (($bv-review-statistics/TotalReviewCount) and ($bv-review-statistics/TotalReviewCount != ''))  then $bv-review-statistics/TotalReviewCount  else '0' "/>
        </TotalReviewCount>
      </ReviewStatistics>      
    </Product>    
  </xsl:template>
  
  <xsl:template name="docatalogdataEloqua">
    <xsl:param name="sop"/>
    <xsl:param name="eop"/>
    <xsl:param name="sos"/>
    <xsl:param name="eos"/>  
    <xsl:param name="lgp">'0.00'</xsl:param>    
    <xsl:param name="rank">0</xsl:param>
    <xsl:param name="deleted"/>
    <xsl:param name="deleteafterdate"/>
    <Catalog>
      <StartOfPublication><xsl:value-of select="$sop"/></StartOfPublication>
      <EndOfPublication><xsl:value-of select="$eop"/></EndOfPublication>
      <StartOfSales><xsl:value-of select="$sos"/></StartOfSales>
      <EndOfSales><xsl:value-of select="$eos"/></EndOfSales>
      <LocalGoingPrice><xsl:value-of select="$lgp"/></LocalGoingPrice>
      <Deleted><xsl:value-of select="if($deleted = '1') then 'true' else 'false'"/></Deleted>
      <DeleteAfterDate><xsl:value-of select="$deleteafterdate"/></DeleteAfterDate>
      <ProductRank><xsl:value-of select="$rank"/></ProductRank>
    </Catalog>
  </xsl:template>
  
  <xsl:template name="doAssetsEloqua">
    <xsl:param name="id"/>
    <xsl:param name="language"/>
    <xsl:param name="locale"/>
    <xsl:param name="lastModified"/>
    <xsl:param name="catalogtype"/>
    <xsl:variable name="escid" select="replace($id,'/','_')"/>
    <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/> 
    <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
    
    <Assets>
      <Asset code="{$escid}" type="RTP" locale="{$locale}" number="001" description="Product picture front-top-left with reflection 2196x1795" extension="jpg"><xsl:value-of select="concat($imagepath,$escid,'-RTP-',$locale,'-001')"/></Asset>      
      <Asset code="{$escid}" type="IMS" locale="{$locale}" number="" description="Single product shot" extension=""><xsl:value-of select="concat($imagepath,$escid,'-IMS-',$locale)"/></Asset>
      <xsl:sequence select="asset-f:createVirtualAsset($id,'URL',$locale, asset-f:buildProductDetailPageUrl(., $locale,'PikachuB2C', $catalogtype, $domains), $lastModified, 'Product URL', '', '')"/>
    </Assets>    
  </xsl:template>
  
  <xsl:template name="docategorizationEloqua">
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
     
</xsl:stylesheet>