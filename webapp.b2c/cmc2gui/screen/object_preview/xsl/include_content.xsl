<xsl:stylesheet version="2.0"
			exclude-result-prefixes="cinclude sql"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:param name="svcURL"/>
	<xsl:param name="o"/>
	<xsl:param name="l"/>
  
	<xsl:key name="kba-features" match="//KeyBenefitArea/Feature" use="concat(ancestor::Product/CTN, FeatureCode)"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template> 
	
	<!-- For products that do not have their Assets included, include the Assets -->
	<xsl:template match="Product">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:if test="count(AssetList|Assets) = 0">
				<AssetList source="product" code="{CTN}" locale="master_global">
					<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/AssetList/master_global/{$o}"/>
				</AssetList>
				<xsl:if test="$l != 'master_global'">
					<AssetList source="product" code="{CTN}" locale="{$l}">
						<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/AssetList/{$l}/{$o}"/>
					</AssetList>
				</xsl:if>
				<!-- include feature assets -->
				<xsl:variable name="non-kba-features" select="(FeatureHighlight|FeatureLogo|FeatureImage)[not(key('kba-features',concat(current()/CTN,FeatureCode)))]"/>
				<xsl:for-each select="KeyBenefitArea/Feature/FeatureCode|$non-kba-features/FeatureCode">
					<ObjectAssetList source="feature" code="{.}" locale="master_global">
						<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{.}"/>
					</ObjectAssetList>
					<xsl:if test="$l != 'master_global'">
						<ObjectAssetList source="feature" code="{.}" locale="{$l}">
							<i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{.}"/>
						</ObjectAssetList>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
  
</xsl:stylesheet>
