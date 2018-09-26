<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="doctypesfilepath"/>
	<xsl:param name="localelanguagefilepath"/>

	<!--  -->
	<xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
	<xsl:variable name="localelanguagefile" select="document($localelanguagefilepath)"/>	

	
	<xsl:variable name="atgNullValue" select="'__NULL__'"/>
	
	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
		<xsl:value-of select="translate($id,'/-. ','___')"/>
	</xsl:function>
	
	<xsl:function name="my:atgNULL">
		<xsl:param name="value"/>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="not($value) or $value=''">
					<xsl:value-of select="$atgNullValue"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:function>
	
<xsl:template name="category-ctn">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="category-ctn" id="{concat(Categorization/SubcategoryCode,'*',$atgCTN)}"/>
</xsl:template>	

<xsl:template name="ctn-locale">
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:param name="atgCTN"/>
		<xsl:param name="language"/>
		<!--xsl:variable name="language" select="$localelanguagefile/root/row[locale=$locale]/language"/-->
		<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="ctn-locale" id="{concat($atgCTN,'*',$country,'*',$language)}"/>
</xsl:template>	
	
	
	<xsl:template match="/Products">
		<gsa-template>
			<import-items>
				<xsl:for-each select="Product">
					<xsl:variable name="lastModified" select="@lastModified" as="xsl:dateTime"/>
					<xsl:variable name="lastExportDate" select="@LastExportDate" as="xsl:dateTime"/>
					<xsl:variable name="isDeleted" select="@isDeleted"/>
					<xsl:if test="$lastModified &gt; $lastExportDate">
						<xsl:variable name="catalogLocale" select="concat(@Locale  ,'_',@Catalog)"/>
						<xsl:variable name="catalog" select="concat(@Country  ,'_',@Catalog)"/>
						<xsl:variable name="atgCTN" select="my:normalized-id(CTN)"/>
						<xsl:variable name="locale" select="@Locale"/>
						<xsl:variable name="country" select="@Country"/>
						<xsl:variable name="language" select="substring-before(@Locale,'_')"/>
						<xsl:choose>
							<xsl:when test="$isDeleted ='yes'"/>
							<xsl:otherwise>
								<xsl:call-template name="category-ctn">
									<xsl:with-param name="locale" select="$locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
								</xsl:call-template>
								<xsl:call-template name="ctn-locale">
									<xsl:with-param name="locale" select="$locale"/>
									<xsl:with-param name="country" select="$country"/>
									<xsl:with-param name="atgCTN" select="$atgCTN"/>
									<xsl:with-param name="language" select="$language"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
