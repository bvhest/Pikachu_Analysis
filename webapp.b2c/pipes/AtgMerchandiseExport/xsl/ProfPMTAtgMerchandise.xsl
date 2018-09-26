<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs" xmlns:ph="http://www.philips.com/catalog/pdl" 
xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="locale"/>
	<xsl:param name="ts"/>

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
		<ph:products docTimeStamp="{concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2))}" docStatus="approved"  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:ph="http://www.philips.com/catalog/pdl" >
			<xsl:for-each select="Product">
				<ph:product>
						<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
						<xsl:variable name="country" select="if ($locale='master_global') then '00' else substring-after($locale,'_')"/>
						<xsl:variable name="language" select="if ($locale='master_global') then 'en' else substring-before($locale,'_')"/>
						<xsl:variable name="v_locale" select="if ($locale='master_global') then 'en_00' else $locale"/>
						<xsl:variable name="catalog" select="concat($country  ,'_',@Catalog)"/>
						<xsl:variable name="catalogLocale" select="concat($locale  ,'_',@Catalog)"/>
					<ph:id>
						<xsl:value-of select="concat($atgCTN,'_',$catalog)"/>
					</ph:id>
					<ph:catalog>
						<xsl:value-of select="concat('catalog_',$catalog)"/>
					</ph:catalog>
					<ph:country>
						<xsl:value-of select="$country"/>
					</ph:country>						
					<ph:language>
						<xsl:value-of select="$v_locale"/>
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
						<xsl:value-of select="@EndOfPublication"/>
					</ph:endDate>
					<ph:parentCategoriesForCatalog>
						<xsl:for-each select="Categorization[not(SubcategoryCode=preceding-sibling::Categorization/SubcategoryCode)]">
							<ph:subcategory>
								<xsl:value-of select="concat(SubcategoryCode,'_',$catalog)"/>
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
											<xsl:if test="DisplayValue and not(DisplayValue='') ">
											  <ph:DisplayValue><xsl:value-of select="DisplayValue"/></ph:DisplayValue>
											</xsl:if>
											<xsl:if test="FilterValue and not(FilterValue='') ">
											  <ph:FilterValue><xsl:value-of select="FilterValue"/></ph:FilterValue>
											</xsl:if>
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
