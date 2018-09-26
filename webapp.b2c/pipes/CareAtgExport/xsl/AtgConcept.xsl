<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="doctypesfilepath"/>
	 <xsl:include href="objectAssets.xsl"/>
	
	<xsl:template match="/">
		<gsa-template>
			<import-items>
					<!-- Concept -->
					<xsl:for-each-group select="/Products/Product/NamingString/Concept" group-by="ConceptCode">
						<xsl:for-each select="current-group()">
							<xsl:sort select="../../@masterLastModified" order="descending"/>
							<xsl:variable name="lastModified" select="../../@lastModified" as="xsl:dateTime"/>
							<xsl:variable name="lastExportDate" select="../../@LastExportDate" as="xsl:dateTime"/>
							<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
								<xsl:variable name="locale" select="../../@Locale"/>
								<xsl:variable name="global" select="''"/>
								<xsl:variable name="itemCode" select="concat(ConceptCode,'_',$locale)"/>
								<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="concept-translation" id="{$itemCode}">
									<set-property name="name">
										<xsl:value-of select="ConceptName"/>
									</set-property>
								</add-item>
								<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="concept" id="{ConceptCode}">
									<set-property name="masterName">
										<xsl:value-of select="ConceptName"/>
									</set-property>
									<set-property name="translations" add="true">
										<xsl:value-of select="concat($locale,'=',$itemCode)"/>
									</set-property>
									<set-property name="assetMap"> 
										<xsl:value-of select="my:objectAssetMap($global,../..,'concept',ConceptCode)"/>
									</set-property>
								</add-item>
								<xsl:call-template name="objectAssetList">
								<xsl:with-param name="locale" select="$global"/>
								<xsl:with-param name="prd" select="../.."/>
									<xsl:with-param name="objectName" select="'concept'"/>
									<xsl:with-param name="objectId" select="ConceptCode"/>
								 </xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
				<!-- -->
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
