<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs" xmlns:ph="http://www.philips.com/catalog/pdl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:variable name="atgNullValue" select="'__NULL__'"/>

	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
		<xsl:value-of select="translate($id,'/-. ','___')"/>
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
					<xsl:variable name="catalogLocale" select="concat(@Locale  ,'_',@Catalog)"/>
					<xsl:variable name="catalog" select="concat(@Country  ,'_',@Catalog)"/>
					<xsl:variable name="country" select="@Country"/>
					<xsl:variable name="locale" select="@Locale"/>
					<xsl:variable name="catalog" select="@Catalog"/>
					<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>									
					<ph:id>
						<xsl:value-of select="concat($atgCTN,'_',$country,'_',$catalog)"/>
					</ph:id>
					<ph:catalog>
						<xsl:value-of select="concat('catalog_',@Country,'_',@Catalog)"/>
					</ph:catalog>
					<ph:country>
						<xsl:value-of select="$country"/>
					</ph:country>						
					<ph:language>
						<xsl:value-of select="$locale"/>
					</ph:language>						
					<ph:catalogType>
						<xsl:value-of select="$catalog"/>					
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
						<xsl:value-of select="@EndOfPublication"/>
					</ph:endDate>
					<ph:parentCategoriesForCatalog>
						<xsl:for-each select="Categorization">
							<ph:subcategory>
								<xsl:value-of select="concat(SubcategoryCode,'_',../@Country,'_',CatalogCode)"/>
							</ph:subcategory>
						</xsl:for-each>
					</ph:parentCategoriesForCatalog>
					<xsl:for-each select="NavigationGroup">
						<ph:NavigationGroup>
							<ph:NavigationGroupCode><xsl:value-of select="NavigationGroupCode"/></ph:NavigationGroupCode>
							<ph:NavigationGroupName><xsl:value-of select="NavigationGroupName"/></ph:NavigationGroupName>
							<ph:NavigationGroupRank><xsl:value-of select="NavigationGroupRank"/></ph:NavigationGroupRank>
							<xsl:for-each select="NavigationAttribute">							
								<ph:NavigationAttribute>						
									<ph:NavigationAttributeCode><xsl:value-of select="NavigationAttributeCode"/></ph:NavigationAttributeCode>
									<ph:NavigationAttributeName><xsl:value-of select="NavigationAttributeName"/></ph:NavigationAttributeName>
									<ph:NavigationAttributeRank><xsl:value-of select="NavigationAttributeRank"/></ph:NavigationAttributeRank>
									<xsl:for-each select="NavigationValue">	
										<ph:NavigationValue>															
											<ph:NavigationValueCode><xsl:value-of select="NavigationValueCode"/></ph:NavigationValueCode>
											<ph:NavigationValueName><xsl:value-of select="NavigationValueName"/></ph:NavigationValueName>
											<ph:NavigationValueRank><xsl:value-of select="NavigationValueRank"/></ph:NavigationValueRank>
										</ph:NavigationValue>															
									</xsl:for-each>																
								</ph:NavigationAttribute>																							
							</xsl:for-each>		
						</ph:NavigationGroup>														
					</xsl:for-each>							
				</ph:product>
			</xsl:for-each>
		</ph:products>
	</xsl:template>
</xsl:stylesheet>
