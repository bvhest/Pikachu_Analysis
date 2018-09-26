<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="fn saxon sql" exclude-result-prefixes="sql">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:import href="xpaths.xsl"/>

  <xsl:param name="productfile"/>

  <xsl:variable name="products" select="document($productfile)"/>

  <xsl:key name="k_product" match="products/sql:rowset/sql:row" use="sql:object_id"/>
  <!-- -->
  <xsl:template match="sql:mv_localized|sql:status_localized|sql:mv_translated|sql:status_translated|sql:status_pmt|sql:mv_enriched|sql:mv_pmt"/>
  <!-- -->
  <xsl:template match="/ancillary">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset">
    <xsl:variable name="rowset" select="."/>
    <ROWSET>
      <xsl:for-each-group select="sql:row" group-by="concat(sql:country,',',sql:customer_id)">
        <Workbook>
          <country><xsl:value-of select="substring-before(current-grouping-key(),',')"/></country>
          <customer_id><xsl:value-of select="substring-after(current-grouping-key(),',')"/></customer_id>
          <xsl:apply-templates select="current-group()[sql:country = substring-before(current-grouping-key(),',')][sql:customer_id = substring-after(current-grouping-key(),',')]"/>
        </Workbook>
      </xsl:for-each-group>
    </ROWSET>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row">
    <ROW>
      <xsl:apply-templates select="@*|node()"/>
    </ROW>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:object_id">
    <Commercial-ID>
      <xsl:apply-templates select="@*|node()"/>
    </Commercial-ID>
    <FYPLink>
      <xsl:value-of select="concat('http://pww.findyourproduct.philips.com/ccrprd/f?p=402:7:::NO::P0_CTN:',.)"/>
    </FYPLink>
      <xsl:variable name="equals">=</xsl:variable>
    <xsl:variable name="atgCTN" select="translate(.,'-/','__')"/>
    <xsl:variable name="atgProductId" select="concat($atgCTN,'_',../sql:country,'_CONSUMER') "/>
    <xsl:variable name="lang" select="substring(../sql:localisation,1,2) "/>
    <xsl:variable name="country" select="substring(../sql:localisation,4,2) "/>
    <xsl:variable name="catalog_type">CONSUMER</xsl:variable>

    <CSLink>
      <xsl:value-of select="concat('http://www.consumer.philips.com/c/catalog/catalog.jsp?country='
                                  ,$country
                                  ,'&amp;language='
                                  ,$lang
                                  ,'&amp;catalogType='
                                  ,$catalog_type
                                  ,'&amp;productid='
                                  ,$atgProductId
                                  )"
      />
    </CSLink>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:localisation">
    <Locale>
      <xsl:apply-templates select="@*|node()"/>
    </Locale>
  </xsl:template>
  <!-- -->
   <xsl:template match="sql:status_enriched">
    <Mrkt-Rel.>
        <xsl:value-of select="if (. = 'Final Published') then 'Y' else 'N' "/>
    </Mrkt-Rel.>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:activity">
    <Active-Inactive>
      <xsl:apply-templates select="@*|node()"/>
    </Active-Inactive>
  </xsl:template>  
  <!-- -->
  <xsl:template match="sql:translation_status">
    <Localized-content>
      <xsl:apply-templates select="@*|node()"/>
    </Localized-content>
  </xsl:template>
    <!-- -->
  <xsl:template match="sql:bg">
    <BG>
      <xsl:apply-templates select="@*|node()"/>
    </BG>
  </xsl:template>
    <!-- -->
  <xsl:template match="sql:bu">
    <BU>
      <xsl:apply-templates select="@*|node()"/>
    </BU>
  </xsl:template>
    <!-- -->
  <xsl:template match="sql:mag">
    <MAG>
      <xsl:apply-templates select="@*|node()"/>
    </MAG>
  </xsl:template>
   <xsl:template match="sql:ag">
    <AG>
      <xsl:apply-templates select="@*|node()"/>
    </AG>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:status_fk">
    <Filterkeys-Status>
      <xsl:apply-templates select="@*|node()"/>
    </Filterkeys-Status>
    <!-- Now to the product enhancement content -->
    <xsl:call-template name="mergeproductdata_usingkeys"> 
     <xsl:with-param name="ctn" select="../sql:object_id/text()"/>
    </xsl:call-template>        
  </xsl:template>
  <!-- -->
   <xsl:template match="sql:sop">
    <SOP>
      <xsl:apply-templates select="@*|node()"/>
    </SOP>
  </xsl:template>
 <xsl:template match="sql:eop">
    <EOP>
      <xsl:apply-templates select="@*|node()"/>
    </EOP>
  </xsl:template>  
  
  <xsl:template match="sql:islocalized">
    <Localized>
       <xsl:value-of select="if (. = '1') then 'Y' else 'N' "/>
    </Localized>
  </xsl:template>  
  
  <xsl:template match="sql:lastmodified">
    <Lastmodified>
      <xsl:apply-templates select="@*|node()"/>
    </Lastmodified>
  </xsl:template>  
  
  <xsl:template name="mergeproductdata_usingkeys">
    <xsl:param name="ctn"/>
    <xsl:for-each select="$products">
      <xsl:variable name="prd" select="key('k_product',$ctn)/sql:data/Product"/>
      <xsl:for-each select="$prd">
         <ProductType>
           <xsl:value-of select="if (ProductType != '') then ProductType else 'Normal' "/>
        </ProductType>  
        <LeafletLink>
          <xsl:value-of select="Asset[ResourceType='PSS']/PublicResourceIdentifier"/>
        </LeafletLink>
        <Range>
          <xsl:value-of select="if (NamingString/Range/RangeCode != '') then concat(NamingString/Range/RangeCode,':',NamingString/Range/RangeName) else 'Not assigned to a range' "/>
        </Range> 
        <ProductEnhancementContent>
          <xsl:for-each select="$ProductEnhancementContent/*/Attribute">
            <xsl:variable name="xpath"><xsl:value-of select="substring-after(@resultantxpath,'Product/')"/></xsl:variable>
            <xsl:variable name="ElementName" select="@name"/>
            <xsl:element name="{$ElementName}">
              <xsl:value-of select="count($prd/saxon:evaluate($xpath))"/>
            </xsl:element>
          </xsl:for-each>
        </ProductEnhancementContent>
        <xsl:for-each select="$Other/Attribute">
          <xsl:variable name="xpath"><xsl:value-of select="substring-after(@resultantxpath,'Product/')"/></xsl:variable>
          <xsl:variable name="ElementName" select="@name"/>
          <xsl:for-each select="$prd">
            <xsl:element name="{$ElementName}">
              <xsl:value-of select="count(saxon:evaluate($xpath))"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
  <!-- -->  
  <xsl:template name="mergeproductdata">
    <xsl:param name="ctn"/>
    <xsl:variable name="prd" select="$products/products/sql:rowset/sql:row[sql:object_id = $ctn]/sql:data/Product"/>
    <xsl:for-each select="$prd">
    <Range>
      <xsl:value-of select="if (Product/NamingString/Range/RangeCode != '') then concat(Product/NamingString/Range/RangeCode,' ',Product/NamingString/Range/RangeName) else 'no range' "/>
    </Range>  
    <ProductEnhancementContent>
      <xsl:for-each select="$ProductEnhancementContent/*/Attribute">
        <xsl:variable name="xpath" select="."/>
        <xsl:variable name="ElementName" select="@name"/>
        <xsl:for-each select="$prd">
          <xsl:element name="{$ElementName}">
            <xsl:value-of select="count(saxon:evaluate($xpath))"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
    </ProductEnhancementContent>
    <xsl:for-each select="$Other/Attribute">
      <xsl:variable name="xpath" select="."/>
      <xsl:variable name="ElementName" select="@name"/>
      <xsl:for-each select="$prd">
        <xsl:element name="{$ElementName}">
          <xsl:value-of select="count(saxon:evaluate($xpath))"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
