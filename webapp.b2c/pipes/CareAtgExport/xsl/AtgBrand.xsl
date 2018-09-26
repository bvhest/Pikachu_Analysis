<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="doctypesfilepath"/>
	<xsl:include href="objectAssets.xsl"/>
	<xsl:template match="/">
		<gsa-template>
			<import-items>
				<xsl:for-each-group select="/Products/Product/NamingString/MasterBrand|/Products/Product/NamingString/Partner/PartnerBrand" group-by="BrandCode">
					<xsl:for-each select="current-group()">
						<xsl:sort select="ancestor::Product/@masterLastModified" order="descending"/>
						<xsl:variable name="lastModified" select="ancestor::Product/@lastModified" as="xsl:dateTime"/>
						<xsl:variable name="lastExportDate" select="ancestor::Product/@LastExportDate" as="xsl:dateTime"/>
						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
							<xsl:variable name="itemCode" select="BrandCode"/>
							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="brand" id="{$itemCode}">
								<set-property name="name">
									<xsl:value-of select="BrandName"/>
								</set-property>
								<xsl:choose>
									<xsl:when test="string(node-name(.))='MasterBrand'">
										<set-property name="assetMap">
											<xsl:value-of select="my:objectAssetMap(../..,'brand',BrandCode)"/>
										</set-property>
									</xsl:when>
									<xsl:otherwise>
										<set-property name="assetMap">
											<xsl:value-of select="my:objectAssetMap(../../..,'brand',BrandCode)"/>
										</set-property>
									</xsl:otherwise>
								</xsl:choose>
							</add-item>
							<xsl:choose>
								<xsl:when test="string(node-name(.))='MasterBrand'">
									<xsl:call-template name="objectAssetList">
										<xsl:with-param name="prd" select="../.."/>
										<xsl:with-param name="objectName" select="'brand'"/>
										<xsl:with-param name="objectId" select="BrandCode"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="objectAssetList">
										<xsl:with-param name="prd" select="../../.."/>
										<xsl:with-param name="objectName" select="'brand'"/>
										<xsl:with-param name="objectId" select="BrandCode"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each-group>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
