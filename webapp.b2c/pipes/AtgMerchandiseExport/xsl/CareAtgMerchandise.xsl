<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs" xmlns:ph="http://www.philips.com/catalog/pdl" 
xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="locale"/>

	<xsl:variable name="atgNullValue" select="'__NULL__'"/>
	
	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
                <!--xsl:value-of select="translate($id,'/-. ','___')"/-->
                <xsl:value-of select="$id"/>
    </xsl:function>


	<xsl:function name="my:escapeFreeFormatValue" as="xs:string">
		<xsl:param name="value"/>
		<xsl:value-of select="replace($value, ',', ',,')"/>
	</xsl:function>

	<xsl:function name="my:atgNULL">
		<xsl:param name="value"/>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="not($value) or $value=''"><xsl:value-of select="$atgNullValue"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:function>

	<xsl:template match="/Products">
		<ph:products>
			<xsl:for-each select="Product">
				<ph:product>
					<xsl:if test="$locale='master_global'">
						<xsl:attribute name="id" select="CTN"/>
					</xsl:if>
					<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
					<xsl:variable name="country" select="substring-after($locale,'_')"/>
					<xsl:variable name="language" select="substring-before($locale,'_')"/>
					<xsl:variable name="catalog" select="concat($country  ,'_',@Catalog)"/>
					<xsl:variable name="catalogLocale" select="concat($locale  ,'_',@Catalog)"/>					
					<ph:id>
						<xsl:value-of select="concat($atgCTN,'_',$country)"/>
					</ph:id>
					<ph:catalog>
						<xsl:value-of select="concat('catalog_',$catalog)"/>
					</ph:catalog>
					<ph:country>
						<xsl:value-of select="$country"/>
					</ph:country>						
					<ph:language>
						<xsl:value-of select="$locale"/>
					</ph:language>						
					<ph:catalogType>
						<xsl:value-of select="@Catalog"/>					
					</ph:catalogType>					
					<ph:displayName>
						<xsl:choose>
              <xsl:when test="my:atgNULL(ProductName)"><xsl:value-of select="my:atgNULL(CTN)"/></xsl:when>
  						<xsl:otherwise><xsl:value-of select="my:atgNULL(ProductName)"/></xsl:otherwise>
            </xsl:choose>
					</ph:displayName>						
					<ph:startDate>
						<xsl:value-of select="@StartOfPublication"/>
					</ph:startDate>
					<ph:endDate>
						<!--xsl:value-of select="xs:dateTime(@StartOfPublication) + xdt:yearMonthDuration('P5Y') "/-->
						<xsl:value-of select="@StartOfPublication"/>
					</ph:endDate>
					<ph:parentCategoriesForCatalog>
						<xsl:for-each select="Categorization">
							<ph:subcategory>
								<xsl:value-of select="concat(SubcategoryCode,'_',$catalog)"/>
							</ph:subcategory>
						</xsl:for-each>
					</ph:parentCategoriesForCatalog>					
				</ph:product>
			</xsl:for-each>
		</ph:products>
	</xsl:template>
</xsl:stylesheet>
