<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="sql xsl cinclude" extension-element-prefixes="cmc2-f">
	<!--  -->
		<xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
	<!-- -->
	<xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
	<!--  -->
	<xsl:template match="/root">
		<infeed xsi:schemaLocation="http://feed.alatest.com http://feed.alatest.com/infeed.xsd">
			<sources>
				<source>
					<source_name>www.consumer.philips.com</source_name>
					<language>en-US</language>
					<products>
						<xsl:apply-templates select="sql:rowset/sql:row/sql:data/Product"/>
					</products>
				</source>
			</sources>
		</infeed>
	</xsl:template>
	<!--  -->
	<xsl:template match="Product">
	
    <xsl:variable name="divisionName">
      <xsl:if test="exists(ProductDivision/ProductDivisionName)">
          <xsl:value-of select="ProductDivision/ProductDivisionName"/>
      </xsl:if>
    </xsl:variable> 
    <xsl:variable name="country">
	    <xsl:choose>
	      <xsl:when test="exists(@Locale)"><xsl:value-of select="substring-after(@Locale,'_')"/></xsl:when>
	      <xsl:otherwise>NONE</xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
    
		<product>
			<name>
				<xsl:value-of select="ProductName"/>
			</name>
			<manufacturer>
				<xsl:value-of select="NamingString/BrandString"/>
			</manufacturer>
			<category>
				<xsl:value-of select="../../sql:rowset[@name='cat']/sql:row/sql:subcategorycode"/>
			</category>
			<url>
				<xsl:value-of select="AssetList/Asset[ResourceType='PSS' and Language='en_US']/PublicResourceIdentifier"/>
			</url>
			<picurl>
				<xsl:value-of select="concat($imagepath,replace(CTN,'/','_'),'-GAL-global')"/>
			</picurl>
			<product_ids>
				<product_id>
					<id_kind>CTN</id_kind>
					<id_value>
						<xsl:value-of select="CTN"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>Alphanumeric</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/Alphanumeric"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>Code12NC</id_kind>
					<id_value>
						<xsl:value-of select="Code12NC"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>GTIN</id_kind>
					<id_value>
						<xsl:value-of select="GTIN"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>DescriptorName</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>VersionString</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/VersionString"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>DescBrndFeatStr</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/DescriptorBrandedFeatureString"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>Concept</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/Concept/ConceptName"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>Family</id_kind>
					<id_value>
						<xsl:value-of select="NamingString/Family/FamilyName"/>
					</id_value>
				</product_id>
				<product_id>
					<id_kind>ProductGroup</id_kind>
					<id_value><xsl:value-of select="cmc2-f:productGrouping(CTN,$divisionName,$country)"/></id_value>
				</product_id>
			</product_ids>
		</product>
	</xsl:template>
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>