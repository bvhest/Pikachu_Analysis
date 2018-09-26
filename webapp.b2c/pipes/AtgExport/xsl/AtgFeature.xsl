<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>


	<xsl:param name="doctypesfilepath"/>
	<xsl:include href="objectAssets.xsl"/>
	
	
	<xsl:template match="/Products">
		<gsa-template>
			<import-items>
				<xsl:variable name="featurelist">
        <xsl:for-each-group select="/Products/Product" group-by="@Catalog">
          <xsl:variable name="currentcatalog" select="current-grouping-key()"/>
          <catalog name="{$currentcatalog}">
  				<xsl:for-each select="/Products/Product[@Catalog=$currentcatalog]/KeyBenefitArea/Feature|/Products/Product[@Catalog=$currentcatalog]/FeatureLogo">
						<xsl:choose>
							<xsl:when test="string(node-name(.))='Feature' or (string(node-name(.))='FeatureLogo' and count(/Products/Product[@Catalog=$currentcatalog]/KeyBenefitArea/Feature[FeatureCode=current()/FeatureCode])=0)">
								<feature>
									<xsl:attribute name="featuretype" select="string(node-name(.))"/>
									<code><xsl:value-of select="FeatureCode"/></code>
									<Product>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:copy-of select="../../ObjectAssetList"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="../ObjectAssetList"/></xsl:when>
										</xsl:choose>
									</Product>
									<lastModified>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:value-of select="../../@lastModified"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="../@lastModified"/></xsl:when>
										</xsl:choose>
									</lastModified>
									<masterLastModified>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:value-of select="../../@masterLastModified"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="xs:dateTime('1970-01-01T00:00:00')"/></xsl:when>
										</xsl:choose>
									</masterLastModified>
									<lastExportDate>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:value-of select="../../@LastExportDate"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="../@LastExportDate"/></xsl:when>
										</xsl:choose>
									</lastExportDate>
									<locale>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:value-of select="../../@Locale"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="../@Locale"/></xsl:when>
										</xsl:choose>
									</locale>			
									<catalog>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:value-of select="../../@Catalog"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:value-of select="../@Catalog"/></xsl:when>
										</xsl:choose>
									</catalog>										
									<feature-details>
										<xsl:choose>
											<xsl:when test="string(node-name(.))='Feature'"><xsl:copy-of select="node()"/></xsl:when>
											<xsl:when test="string(node-name(.))='FeatureLogo'"><xsl:copy-of select="node()"/></xsl:when>
										</xsl:choose>									
									</feature-details>
								</feature>
							</xsl:when>						
						</xsl:choose>
					</xsl:for-each>
          </catalog>
        </xsl:for-each-group>
				</xsl:variable>
				<!--chunk><xsl:copy-of select="$featurelist"/></chunk-->
        <xsl:for-each select="$featurelist/catalog">
				<xsl:for-each-group select="feature" group-by="code">
					<xsl:for-each select="current-group()">
						<xsl:sort select="masterLastModified" order="descending"/>					
						<xsl:variable name="lastModified" select="lastModified" as="xs:dateTime"/>
						<xsl:variable name="lastExportDate" select="lastExportDate" as="xs:dateTime"/>
						<xsl:if test="position() = 1 and $lastModified &gt; $lastExportDate">
							<xsl:variable name="locale" select="locale"/>
							<xsl:variable name="global" select="''"/>
							<xsl:variable name="catalogLocale" select="concat(locale,'_',catalog)"/>
							<xsl:variable name="featuretype" select="@featuretype"/>							
							<xsl:variable name="itemCode" select="concat(feature-details/FeatureCode,'_',$catalogLocale)"/>
							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="feature-translation" id="{$itemCode}">
								<set-property name="glossary">
									<xsl:value-of select="feature-details/FeatureGlossary"/>
								</set-property>
								<set-property name="displayName">
									<xsl:choose><xsl:when test="$featuretype='Feature'">
													<xsl:value-of select="feature-details/FeatureName"/>
												</xsl:when>
												<xsl:when test="$featuretype='FeatureLogo'">
													<xsl:value-of select="feature-details/FeatureReferenceName"/>
												</xsl:when>
									</xsl:choose>
								</set-property>
								<set-property name="how">
									<xsl:value-of select="feature-details/FeatureHow"/>
								</set-property>
								<set-property name="why">
									<xsl:value-of select="feature-details/FeatureWhy"/>
								</set-property>
								<set-property name="longDescription">
									<xsl:value-of select="feature-details/FeatureLongDescription"/>
								</set-property>
								<set-property name="what">
									<xsl:value-of select="feature-details/FeatureWhat"/>
								</set-property>
								<set-property name="shortDescription">
									<xsl:value-of select="feature-details/FeatureShortDescription"/>
								</set-property>
								
							<set-property name="assetMap">
										<xsl:value-of select="my:objectAssetMap($locale,Product,'featuretransl',feature-details/FeatureCode)"/>
								</set-property>
							</add-item>
							
							<xsl:call-template name="objectAssetList">
								<xsl:with-param name="locale" select="$locale"/>
								<xsl:with-param name="prd" select="Product"/>
								<xsl:with-param name="objectName" select="'featuretransl'"/>
								<xsl:with-param name="objectId" select="feature-details/FeatureCode"/>
							 </xsl:call-template>
							
							
							<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="feature" id="{feature-details/FeatureCode}">
								<set-property name="translations" add="true">
									<xsl:value-of select="concat($catalogLocale,'=',$itemCode)"/>
								</set-property>
							<set-property name="assetMap"> 
										<xsl:value-of select="my:objectAssetMap($global,Product,'feature',feature-details/FeatureCode)"/>
								</set-property>
							</add-item>
							<xsl:call-template name="objectAssetList">
								<xsl:with-param name="locale" select="$global"/>
								<xsl:with-param name="prd" select="Product"/>
								<xsl:with-param name="objectName" select="'feature'"/>
								<xsl:with-param name="objectId" select="feature-details/FeatureCode"/>
							 </xsl:call-template>																		
						</xsl:if>
					</xsl:for-each>
        </xsl:for-each-group>				
        </xsl:for-each>
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
