<xsl:stylesheet version="2.0"
			exclude-result-prefixes="cinclude sql"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:param name="o"/>
	<xsl:param name="l"/>
  <xsl:param name="asset-channel">Scene7</xsl:param>
  <xsl:param name="doctypes-file-path">../../xml/doctype_attributes.xml</xsl:param>
 
  <xsl:variable name="doctypes" select="document($doctypesfilepath)"/>
 
	<xsl:key name="localized-assets" match="//AssetList[@locale!='master_global']//Asset" use="concat(../id, ResourceType)"/>
	<xsl:key name="localized-object-assets" match="//ObjectAssetList[@locale!='master_global']//Asset" use="concat(../id, ResourceType)"/>

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template> 
	
	<xsl:template match="Product">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<!-- Merge asset lists that were retrieved from the database -->
			<xsl:if test="AssetList//sql:data/object/Asset"> 
				<AssetList>
					<xsl:apply-templates select="AssetList//sql:data/object/Asset" mode="merge"/>
				</AssetList>
			</xsl:if>
			<xsl:if test="ObjectAssetList//sql:data/object"> 
				<ObjectAssetList>
					<xsl:variable name="localized-asset-objects" select="ObjectAssetList[@locale != 'master_global']//sql:data/object"/>
					<xsl:choose>
						<xsl:when test="$localized-asset-objects">
							<xsl:apply-templates select="$localized-asset-objects" mode="merge"/>
							<!-- Add objects without any localized assets -->
							<xsl:for-each select="ObjectAssetList[@locale = 'master_global']">
								<xsl:variable name="localized-oal" select="../ObjectAssetList[@code=current()/@code and @locale!='master_global']"/>
								<xsl:apply-templates select="descendant::sql:data/object[count($localized-oal/descendant::sql:data) = 0]" mode="merge" />
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ObjectAssetList[@locale = 'master_global']//sql:data/object" mode="merge" />
						</xsl:otherwise>
					</xsl:choose>
				</ObjectAssetList>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
  
	<!--
		Merge asset lists that were retrieved from the database,
		keeping only the assets that are sent to the specified asset channel
		and ignoring master_global assets that also have a localized version.
	-->
	
	<!-- Localized assets are copied -->
	<xsl:template match="Asset[ancestor::AssetList[@locale != 'master_global']]" mode="merge">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- master_global assets are copied only if no localized asset exists -->
	<xsl:template match="Asset[ancestor::AssetList[@locale = 'master_global']]" mode="merge">
		<xsl:if test="not(key('localized-assets', concat(../id, ResourceType)))">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="object[ancestor::ObjectAssetList[@locale != 'master_global']]" mode="merge">
		<Object>
			<xsl:apply-templates select="id"/>
			<xsl:apply-templates select="Asset[Language='' or Language=../../../sql:localisation]"/>
			<!-- Add assets from master_global ObjectAssetList that do not have an equivalent in the localized list -->
			<xsl:apply-templates select="ancestor::ObjectAssetList/../ObjectAssetList[@locale='master_global' and @code=current()/id]/descendant::object/Asset[not(key('localized-object-assets', concat(current()/id,ResourceType)))]"/>
		</Object>
	</xsl:template>
	
	<xsl:template match="object[ancestor::ObjectAssetList[@locale = 'master_global']]" mode="merge">
		<Object>
			<xsl:apply-templates select="@*|node()"/>
		</Object>
	</xsl:template>
	
	<!-- Ignore AssetLists from database when in normal mode -->
	<xsl:template match="AssetList[@locale]|ObjectAssetList[@locale]"/>

</xsl:stylesheet>
