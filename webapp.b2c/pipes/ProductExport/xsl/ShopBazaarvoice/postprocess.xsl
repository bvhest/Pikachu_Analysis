<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.bazaarvoice.com/xs/PRR/ProductFeed/5.6" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                extension-element-prefixes="cmc2-f asset-f"
                exclude-result-prefixes="sql">

  <xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl" />
  <xsl:import href="../../../common/xsl/xUCDM-external-assets.xsl" />

  <xsl:param name="locale" select="'xx_XX'"/>

  <xsl:variable name="domains" select="document('../../../../cmc2/xml/countryDomains.xml')/domains" />
  <xsl:variable name="source">
    <xsl:text>Philips</xsl:text>
  </xsl:variable>

  <xsl:template match="/root">
    <xsl:element name="Feed">
      <xsl:attribute name="extractDate" select="@exportTimestamp" />
      <xsl:attribute name="incremental" select="if (@isFullExport='yes') then 'false' else 'true' " />
      <xsl:attribute name="name" select="concat('PhilipsBrand-',upper-case($locale))" />
      <xsl:apply-templates select="sql:rowset" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="sql:rowset[@name='product']">
    <xsl:element name="Products">
      <xsl:apply-templates select="sql:row" mode="product" />
    </xsl:element>
  </xsl:template>
  <xsl:template match="sql:rowset[@name='catg-tree']">
    <xsl:element name="Categories">
      <xsl:apply-templates select="sql:row" mode="category" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="sql:row" mode="category">
    <xsl:apply-templates select="sql:data/Categorization" mode="category" />
  </xsl:template>

  <xsl:template match="sql:row" mode="product">
    <xsl:apply-templates select="sql:data/Product" mode="product" />
  </xsl:template>
	
  <xsl:template match="Product" mode="product">
    <xsl:variable name="row" select="../.." />
    <!-- cannot handle product assigned to multiple subcategories so pick one in order of precendence: PUB, EMP, EXP, PAR -->
    <xsl:variable name="prod-categorizations" select="Categorizations" />
    <xsl:variable name="categorization">
      <xsl:choose>
        <xsl:when test="$prod-categorizations/Categorization[@catalogcode='SHOPPUB']">
          <xsl:sequence select="$prod-categorizations/Categorization[@catalogcode='SHOPPUB'][1]" />
        </xsl:when>
        <xsl:when test="$prod-categorizations/Categorization[@catalogcode='SHOPEMP']">
          <xsl:sequence select="$prod-categorizations/Categorization[@catalogcode='SHOPEMP'][1]" />
        </xsl:when>
        <xsl:when test="$prod-categorizations/Categorization[@catalogcode='SHOPEXP']">
          <xsl:sequence select="$prod-categorizations/Categorization[@catalogcode='SHOPEXP'][1]" />
        </xsl:when>
        <xsl:when test="$prod-categorizations/Categorization[@catalogcode='SHOPPAR']">
          <xsl:sequence select="$prod-categorizations/Categorization[@catalogcode='SHOPPAR'][1]" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="product">
      <Product xmlns="">
        <xsl:apply-templates select="@*|node()" mode="product-copy"/>
      </Product>
    </xsl:variable>
        
    <xsl:variable name="locale" select="$row/sql:locale" />
    <xsl:variable name="id" select="cmc2-f:escape-scene7-id($row/sql:object_id)" />
    <xsl:element name="Product">      
	  <xsl:variable name="deleted" select="$row/sql:deleted" />
    <xsl:variable name="ctn">
      <xsl:if test="exists($product/Product/CTN)">
          <xsl:value-of select="$product/Product/CTN"/>
      </xsl:if>
    </xsl:variable>    
    <xsl:variable name="divisionName">
      <xsl:if test="exists($product/Product/ProductDivision/ProductDivisionName)">
          <xsl:value-of select="$product/Product/ProductDivision/ProductDivisionName"/>
      </xsl:if>
    </xsl:variable>
	  <xsl:attribute name="removed">
        <xsl:choose>
          <xsl:when test="$deleted='1'">
            <xsl:text>true</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>false</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:element name="ExternalId">
        <xsl:value-of select="$id" />
      </xsl:element>
      <xsl:element name="Name">
        <xsl:value-of select="cmc2-f:formatFullProductName($product/Product/NamingString)" />
      </xsl:element>
      <xsl:element name="Description">
        <xsl:value-of select="if ($product/Product/MarketingTextHeader !='') then $product/Product/MarketingTextHeader else $product/Product/CTN" />
      </xsl:element>
      <xsl:element name="Brand">
        <xsl:element name="Name">
          <xsl:value-of select="$product/Product/NamingString/MasterBrand/BrandName" />
        </xsl:element>
      </xsl:element>
      <xsl:element name="Attributes">
        <xsl:variable name="grouping" select="cmc2-f:productGrouping($ctn,$divisionName,substring-after($locale,'_'))" />
        <xsl:element name="Attribute">
          <xsl:attribute name="id" select="'BV_FE_FAMILY'" />
          <xsl:element name="Value">
            <xsl:value-of select="$grouping" />
          </xsl:element>
        </xsl:element>
        <xsl:element name="Attribute">
          <xsl:attribute name="id" select="'BV_FE_EXPAND'" />
          <xsl:element name="Value">
            <xsl:value-of select="concat('BV_FE_FAMILY:',$grouping)" />
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="CategoryExternalId">
        <xsl:value-of select="$categorization/Categorization/Subcategory/@code" />
      </xsl:element>
      <xsl:element name="CategoryName">
        <xsl:value-of select="$categorization/Categorization/Subcategory/text()" />
      </xsl:element>
      <xsl:element name="CategoryPath">
        <xsl:element name="CategoryName">
          <xsl:value-of select="$categorization/Categorization/Group/@code" />
        </xsl:element>
        <xsl:element name="CategoryName">
          <xsl:value-of select="$categorization/Categorization/Category/@code" />
        </xsl:element>
        <xsl:element name="CategoryName">
          <xsl:value-of select="$categorization/Categorization/Subcategory/@code" />
        </xsl:element>
      </xsl:element>
      
      <xsl:element name="ProductPageUrl">
        <xsl:value-of select="asset-f:buildShopProductDetailPageUrl($product/Product, $locale, $categorization/Categorization/@catalogcode, $domains)" />
      </xsl:element>
      <xsl:element name="ImageUrl">
        <xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, 'IMS', $locale, '' )" />
      </xsl:element>
      <xsl:element name="ManufacturerPartNumbers">
        <xsl:element name="ManufacturerPartNumber">
          <xsl:value-of select="$product/Product/CTN" />
        </xsl:element>
      </xsl:element>
      
						<xsl:if test="string-length($product/Product/GTIN)=12">
						<xsl:element name="UPCs"> 
							<xsl:element name="UPC">
								<xsl:value-of select="$product/Product/GTIN"/> 
							</xsl:element>
						</xsl:element>	
						</xsl:if>

						<xsl:if test="string-length($product/Product/GTIN)=13">	 		
						<xsl:element name="EANs"> 
							<xsl:element name="EAN">
								<xsl:value-of select="$product/Product/GTIN"/> 
							</xsl:element>
						</xsl:element>	
						</xsl:if>
      
    </xsl:element>
  </xsl:template>
	
  <!-- Category element -->
  <xsl:template match="Categorization" mode="category">
    <xsl:variable name="row" select="../.." />
    <xsl:variable name="Categorization" select="." />
    <xsl:variable name="locale" select="$row/sql:locale" />
    <xsl:variable name="id" select="$row/sql:id" />
    <!-- Groups -->
    <xsl:for-each select="$Categorization/Catalog/FixedCategorization/ProductDivision/BusinessGroup/Group">
      <xsl:element name="Category">
        <xsl:element name="ExternalId">
          <xsl:value-of select="GroupCode" />
        </xsl:element>
        <xsl:element name="Name">
          <xsl:value-of select="GroupName" />
        </xsl:element>
        <xsl:element name="CategoryPageUrl">
          <xsl:text>http://www.philips.com</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <!-- Categories-->
    <xsl:for-each select="$Categorization/Catalog/FixedCategorization/ProductDivision/BusinessGroup/Group/Category">
      <xsl:element name="Category">
        <xsl:element name="ExternalId">
          <xsl:value-of select="CategoryCode" />
        </xsl:element>
        <xsl:element name="ParentExternalId">
          <xsl:value-of select="../GroupCode" />
        </xsl:element>
        <xsl:element name="Name">
          <xsl:value-of select="CategoryName" />
        </xsl:element>
        <xsl:element name="CategoryPageUrl">
          <xsl:text>http://www.philips.com</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <!-- SubCategories-->
    <xsl:for-each select="$Categorization/Catalog/FixedCategorization/ProductDivision/BusinessGroup/Group/Category/L3/L4/L5/L6/SubCategory">
      <xsl:element name="Category">
        <xsl:element name="ExternalId">
          <xsl:value-of select="SubCategoryCode" />
        </xsl:element>
        <xsl:element name="ParentExternalId">
          <xsl:value-of select="../../../../../CategoryCode" />
        </xsl:element>
        <xsl:element name="Name">
          <xsl:value-of select="SubCategoryName" />
        </xsl:element>
        <xsl:element name="CategoryPageUrl">
          <xsl:text>http://www.philips.com</xsl:text>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
    
  <xsl:template match="@*|node()" mode="product-copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current" />
    </xsl:copy>
  </xsl:template>
  
  <!-- Fix the display name -->
  <xsl:template match="ProductName" mode="product-copy">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="cmc2-f:product-display-name(..)" />
    </xsl:copy>
  </xsl:template>

  <!-- Remove intermediate elements -->
  <xsl:template match="Categorizations" mode="product-copy" />
</xsl:stylesheet>