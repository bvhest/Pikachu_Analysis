<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ph="http://www.philips.com/catalog/search"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">

  <xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="exportdate"/>
  
  <!-- The CSItems in the CSChapter contain CTNs as values which fit an accessory -->
  <xsl:variable name="FITS_PRODUCTS_CHAPTER_CODE" select="'4003141'" />
  
  <xsl:template match="/Products">
    <ph:products>
      <xsl:attribute name="docTimestamp">
        <xsl:analyze-string select="$exportdate" regex="(\d{{4}})[-/]?(\d{{2}})[-/]?(\d{{2}})[T ]?(\d{{2}})[:]?(\d{{2}})[:]?(\d{{2}})">
          <xsl:matching-substring>
            <xsl:value-of select="concat(regex-group(1),'-',regex-group(2),'-',regex-group(3),'T',regex-group(4),':',regex-group(5),':',regex-group(6))" />
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="$exportdate"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:attribute>
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </ph:products>
  </xsl:template>
  
  <!-- 
    A row with one product.
    The catalogtypes column may have more than one catalog type as a comma separated list.
    For each catalog type a ph:product is created in the output.
  -->
  <xsl:template match="sql:row">
    <xsl:variable name="ctx" select="."/>
    
    <xsl:for-each select="tokenize(sql:catalogtypes, ',')">
      <xsl:apply-templates select="$ctx/sql:data/Product">
        <xsl:with-param name="catalog-type" select="."/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="Product">
    <xsl:param name="catalog-type"/>

    <xsl:variable name="locale" select="ancestor::sql:row/sql:localisation"/>
    <xsl:variable name="atg-id" select="translate(CTN,'/-. ','___')"/>
    <xsl:variable name="atg-suffix" select="concat(substring($locale,4), '_', $catalog-type)"/>
    
    <ph:product>
      <ph:id>
        <xsl:value-of select="concat($atg-id, '_', $atg-suffix)" />
      </ph:id>
      <ph:catalog>
        <xsl:value-of select="concat('catalog', '_', $atg-suffix)" />
      </ph:catalog>
      <ph:country>
        <xsl:value-of select="substring($locale,4)" />
      </ph:country>
      <ph:language>
        <xsl:value-of select="$locale" />
      </ph:language>
      <ph:catalogType>
        <xsl:value-of select="$catalog-type" />
      </ph:catalogType>
      <ph:displayName>
        <xsl:value-of select="cmc2-f:product-display-name(.)" />
      </ph:displayName>
      <ph:seoName>
        <!-- master_data is present in case master locale data is exported -->
        <xsl:value-of select="if (SEOProductName != '') then 
                                SEOProductName
                              else if (ancestor::sql:row/sql:master_data/Product/SEOProductName != '') then
                                ancestor::sql:row/sql:master_data/Product/SEOProductName
                              else
                                '-'" />
      </ph:seoName>
      <ph:CTN>
        <xsl:value-of select="CTN" />
      </ph:CTN>
      <ph:MarketingTextHeader>
        <xsl:value-of select="MarketingTextHeader" />
      </ph:MarketingTextHeader>
      <ph:keywords><xsl:value-of select="string-join(
                                            distinct-values((
                                                ancestor::sql:row/sql:rowset[@name='performers']/sql:row/sql:ctn
                                              , CSChapter[CSChapterCode=$FITS_PRODUCTS_CHAPTER_CODE]/CSItem/CSValue/CSValueName
                                              )), ',')"/></ph:keywords>
      <!-- 
        Source code 110117 indicates BazaarVoice native review stats.
      -->
      <ph:overallUserRating>
        <xsl:value-of select="if (ReviewStatistics/ReviewStatistics[@source='110117']/AverageOverallRating) then
                                ReviewStatistics/ReviewStatistics[@source='110117'][1]/AverageOverallRating
                              else
                                0" />
      </ph:overallUserRating>
      <ph:numberOfUserReviews>
        <xsl:value-of select="if (ReviewStatistics/ReviewStatistics[@source='110117']/TotalReviewCount) then
                                ReviewStatistics/ReviewStatistics[@source='110117'][1]/TotalReviewCount
                              else
                                0" />
      </ph:numberOfUserReviews>
    </ph:product>
  </xsl:template>
</xsl:stylesheet>