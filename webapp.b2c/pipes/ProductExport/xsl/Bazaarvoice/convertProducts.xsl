<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.bazaarvoice.com/xs/PRR/ProductFeed/5.6" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2" extension-element-prefixes="sql cmc2-f asset-f ">
	<xsl:param name="doctypesfilepath"/>
	<xsl:param name="channel"/>
	<xsl:param name="type"/>
	<xsl:param name="asset-syndication"/>
	<xsl:param name="broker-level"/>
	<xsl:param name="system"/>
	<xsl:param name="exportdate"/>
	<xsl:param name="full"/>
	
	<xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
	<xsl:import href="../../../../pipes/common/xsl/xUCDM-external-assets.xsl"/>
	
	<xsl:variable name="domains" select="document('../../../../cmc2/xml/countryDomains.xml')/domains"/>
	<xsl:variable name="source">Philips</xsl:variable>
	
	<xsl:variable name="rundate" select="concat(substring($exportdate,1,4)
                                             ,'-'
                                             ,substring($exportdate,5,2)
                                             ,'-'
                                             ,substring($exportdate,7,2)
                                             ,'T'
                                             ,substring($exportdate,10,2)
                                             ,':'
                                             ,substring($exportdate,12,2)
                                             ,':00')"/>
	<xsl:template match="/root">
		<xsl:variable name="locale">
      <xsl:choose>
        <xsl:when test="exists(sql:rowset[@name='Product']/sql:row[1]/sql:master_locale)">
          <xsl:value-of select="sql:rowset[@name='Product']/sql:row[1]/sql:master_locale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="sql:rowset[@name='Product']/sql:row[1]/sql:locale"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
		<xsl:element name="Feed">
			<xsl:attribute name="extractDate" select="$rundate"/>
			<xsl:attribute name="incremental" select="if ($full='yes') then 'false' else 'true' "/>
			<xsl:attribute name="name" select="concat('PhilipsBrand-',upper-case($locale))"/>
			<xsl:apply-templates select="sql:rowset"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sql:rowset[@name='Product']">
		<xsl:element name="Products">
			<xsl:apply-templates select="sql:row" mode="product"/>
		</xsl:element>
	</xsl:template>
  
	<xsl:template match="sql:rowset[@name='Cat-tree']">
		<xsl:element name="Categories">
      <!-- Each row is a group, cat, subcat ordered by group, cat, subcat -->
      <!-- Export all distinct groups -->
			<xsl:for-each-group select="sql:row" group-adjacent="sql:groupcode">
        <xsl:variable name="cur-group-code" select="current-grouping-key()"/>
  			<xsl:element name="Category">
  				<xsl:element name="ExternalId">
  					<xsl:value-of select="current-grouping-key()"/>
  				</xsl:element>
  				<xsl:element name="Name">
  					<xsl:value-of select="sql:groupname"/>
  				</xsl:element>
  				<xsl:element name="CategoryPageUrl">
            <xsl:text>http://www.philips.com</xsl:text>
          </xsl:element>
  			</xsl:element>
        
        <!-- Within each group export the distinct categories -->
        <xsl:for-each-group select="current-group()" group-adjacent="sql:categorycode">
          <xsl:variable name="cur-cat-code" select="current-grouping-key()"/>
          <xsl:element name="Category">
            <xsl:element name="ExternalId">
              <xsl:value-of select="current-grouping-key()"/>
            </xsl:element>
            <xsl:element name="ParentExternalId">
              <xsl:value-of select="$cur-group-code"/>
            </xsl:element>
            <xsl:element name="Name">
              <xsl:value-of select="sql:categoryname"/>
            </xsl:element>
            <xsl:element name="CategoryPageUrl">
              <xsl:text>http://www.philips.com</xsl:text>
            </xsl:element>
          </xsl:element>
          
          <!-- Within each category export the subcategories -->
          <xsl:for-each select="current-group()">
            <xsl:element name="Category">
              <xsl:element name="ExternalId">
                <xsl:value-of select="sql:subcategorycode"/>
              </xsl:element>
              <xsl:element name="ParentExternalId">
                <xsl:value-of select="$cur-cat-code"/>
              </xsl:element>
              <xsl:element name="Name">
                <xsl:value-of select="sql:subcategoryname"/>
              </xsl:element>
              <xsl:element name="CategoryPageUrl">
                <xsl:text>http://www.philips.com</xsl:text>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:for-each-group>
      </xsl:for-each-group>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sql:row" mode="product">
		<xsl:apply-templates select="sql:data/Product" mode="product"/>
	</xsl:template>
	
	<!-- Product element -->
	<xsl:template match="Product" mode="product">
		<xsl:variable name="Row" select="../.."/>
		<!-- cannot handle product assigned to multiple subcategories so pick one -->
		<xsl:variable name="Cat-Row" select="../../sql:rowset[@name='cat']/sql:row[1]"/>
		<xsl:variable name="Product" select="."/>		
		<xsl:variable name="ctn">
			<xsl:if test="exists($Product/CTN)">
	        <xsl:value-of select="$Product/CTN"/>
	    </xsl:if>
		</xsl:variable>	
		<xsl:variable name="divisionName">
      <xsl:if test="exists($Product/ProductDivision/ProductDivisionName)">
          <xsl:value-of select="$Product/ProductDivision/ProductDivisionName"/>
      </xsl:if>
		</xsl:variable>				
		<xsl:variable name="locale">
      <xsl:choose>
        <xsl:when test="exists($Row/sql:master_locale)">
          <xsl:value-of select="$Row/sql:master_locale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$Row/sql:locale"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<xsl:variable name="id" select="cmc2-f:escape-scene7-id($Row/sql:id)"/>
		<xsl:variable name="catalogtype" select="$Row/sql:categorization_catalogtype"/>
		<xsl:element name="Product">
			<xsl:attribute name="removed">
        <xsl:choose>
          <xsl:when test="$Row/sql:deleted='1'">
            <xsl:text>true</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>false</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
			<xsl:element name="ExternalId">
				<xsl:value-of select="$id"/>
			</xsl:element>
			<xsl:element name="Name">
				<xsl:value-of select="cmc2-f:formatFullProductName($Product/NamingString)"/>
			</xsl:element>
			<xsl:element name="Description">
				<xsl:value-of select="if ($Product/MarketingTextHeader !='') then $Product/MarketingTextHeader else $Product/CTN"/>
			</xsl:element>
			<xsl:element name="Brand">
				<xsl:element name="Name">
					<xsl:value-of select="$Product/NamingString/MasterBrand/BrandName"/>
				</xsl:element>
			</xsl:element>
			<xsl:variable name="conditioned_CTNs" select="'SCF332/21,SCF334/22,SCF334/23,SCF334/25,SCF334/26,SCD292/22,SCF332/31,SCF332/32,SCF332/33,SCF332/61,SCF334/31,SCF341/32,SCD292/31,SCD223/10,SCD223/20'"/>
			<!-- For the conditioned_CTNs ctns, blocking Attributes elements-->
			<xsl:if test="not(contains($conditioned_CTNs, $Product/CTN))">
				<xsl:element name="Attributes">
					<xsl:variable name="grouping"  select="cmc2-f:productGrouping($ctn,$divisionName,substring-after($Row/sql:locale,'_'))"/>
					<xsl:element name="Attribute">
						<xsl:attribute name="id" select="'BV_FE_FAMILY'"/>
						<xsl:element name="Value">
							<xsl:value-of select="$grouping"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="Attribute">
						<xsl:attribute name="id" select="'BV_FE_EXPAND'"/>
						<xsl:element name="Value">
							<xsl:value-of select="concat('BV_FE_FAMILY:',$grouping)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			
			<xsl:element name="CategoryExternalId">
				<xsl:value-of select="$Cat-Row/sql:subcategorycode"/>
			</xsl:element>
			<xsl:element name="CategoryName">
				<xsl:value-of select="$Cat-Row/sql:subcategoryname"/>
			</xsl:element>
			<xsl:element name="CategoryPath">
				<xsl:element name="CategoryName">
					<xsl:value-of select="$Cat-Row/sql:groupcode"/>
				</xsl:element>
				<xsl:element name="CategoryName">
					<xsl:value-of select="$Cat-Row/sql:categorycode"/>
				</xsl:element>
				<xsl:element name="CategoryName">
					<xsl:value-of select="$Cat-Row/sql:subcategorycode"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="ProductPageUrl">
				<xsl:value-of select="asset-f:buildProductDetailPageUrl(., $locale, $system, $catalogtype, $domains )"/>
			</xsl:element>
			<xsl:element name="ImageUrl">
				<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, 'IMS', $locale, '' )"/>
			</xsl:element>
			<xsl:element name="ManufacturerPartNumbers">
				<xsl:element name="ManufacturerPartNumber">
					<xsl:value-of select="$Product/CTN"/>
				</xsl:element>
			</xsl:element>

						<xsl:if test="string-length($Product/GTIN)=12">
						<xsl:element name="UPCs"> 
							<xsl:element name="UPC">
								<xsl:value-of select="$Product/GTIN"/> 
							</xsl:element>
						</xsl:element>	
						</xsl:if>

						<xsl:if test="string-length($Product/GTIN)=13">
						<xsl:element name="EANs"> 
							<xsl:element name="EAN">
								<xsl:value-of select="$Product/GTIN"/> 
							</xsl:element>
						</xsl:element>	
						</xsl:if>

		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
