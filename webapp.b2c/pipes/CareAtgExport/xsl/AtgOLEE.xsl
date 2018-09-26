<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="doctypesfilepath"/>
	<xsl:param name="localelanguagefilepath"/>	
	<xsl:include href="objectAssets.xsl"/>
	<xsl:variable name="localelanguagefile" select="document($localelanguagefilepath)"/>	

	<xsl:template match="/">
		<gsa-template>
			<import-items>
				<!-- Concept -->
				<xsl:for-each-group select="/Products/Product/RichTexts/RichText/Item" group-by="@code">
					<xsl:for-each select="current-group()">
						<xsl:sort select="../../../@masterLastModified" order="descending"/>
						<xsl:variable name="lastModified" select="../../../@lastModified" as="xsl:dateTime"/>
						<xsl:variable name="lastExportDate" select="../../../@LastExportDate" as="xsl:dateTime"/>
						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
							<xsl:variable name="locale" select="../../../@Locale"/>
							<xsl:variable name="country" select="../../../@Country"/>
							<xsl:variable name="language" select="$localelanguagefile/root/row[locale=$locale]/language"/>		
							<xsl:variable name="global" select="''"/>
							<xsl:variable name="itemId" select="current-grouping-key() "/>
							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="olee-item-translation" id="{concat($itemId,'_',$locale)}">
								<set-property name="Head">
									<xsl:value-of select="Head"/>
								</set-property>
								<set-property name="Body">
									<xsl:value-of select="Body"/>
								</set-property>
							</add-item>
<!--
								<set-property name="assetMap">
									<xsl:value-of select="my:objectAssetMap($locale,../../..,'symptomtransl',$itemId)"/>
								</set-property>
							</add-item>
							<xsl:call-template name="objectAssetList">
								<xsl:with-param name="locale" select="$locale"/>
								<xsl:with-param name="prd" select="../../.."/>
								<xsl:with-param name="objectName" select="'symptomtransl'"/>
								<xsl:with-param name="objectId" select="$itemId"/>
							</xsl:call-template>
-->
							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="olee-item" id="{$itemId}">
								<set-property name="translations" add="true">
									<xsl:value-of select="concat($language,'=',$itemId,'_',$language)"/>
								</set-property>
							</add-item>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each-group>
				<!-- -->
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
