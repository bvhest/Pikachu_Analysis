<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:sql="http://apache.org/cocoon/SQL/2.0"
		xmlns:cinclude="http://apache.org/cocoon/include/1.0"
		xmlns:cmc2-f="http://www.philips.com/cmc2-f"
		exclude-result-prefixes="sql xsl cinclude"
		extension-element-prefixes="cmc2-f">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:import href="../../../pipes/common/xsl/xucdm-product-external-v1.2.xsl"/>

	<xsl:include href="cmc2.function.xsl"/>

	<xsl:param name="doctypes-file-path">../../xml/doctype_attributes.xml</xsl:param>

	<xsl:variable name="doctypes" select="document($doctypes-file-path)/doctypes"/>
	<xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>	<!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->

	<xsl:template name="doAssets">
		<!-- This template overrides the template of the same name in xucdm-product-external -->
		<xsl:param name="id"/>
		<xsl:param name="lastModified"/>

		<xsl:variable name="number" select="'001'"/>
	
		<Assets>
			<!-- Product assets: include only assets of type jpeg, pdf, flv and 360 assets -->
			<xsl:for-each select="AssetList/Asset[matches(InternalResourceIdentifier,'\.(pdf|jpg|tif|flv)$','i') or ResourceType=('P3D','PRV')]">
				<xsl:variable name="description" select="$doctypes/doctype[@code=current()/ResourceType]/@description"/>
				<xsl:copy-of select="cmc2-f:doAssetExtended($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','',Publisher, $doctypes)"/>
			</xsl:for-each>
			
			<!-- Virtual assets -->
			<xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Single product shot','','','','IMS',substring($lastModified,1,10),concat($imagepath,replace($id,'/','_'),'-IMS-global'),'')"/>
			<xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Product gallery image set','','','','GAL',substring($lastModified,1,10),concat($imagepath,replace($id,'/','_'),'-GAL-global'),'')"/>
			
			<!-- Object assets -->
			<xsl:for-each select="ObjectAssetList/Object/Asset[ResourceType!='GAL'][matches(InternalResourceIdentifier,'\.(pdf|jpg|tif|flv)$','i') or ResourceType='AWU']">
				<xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language"/>
				<xsl:variable name="escid" select="replace(../id,'/','_')"/>
				<xsl:variable name="description" select="$doctypes/doctype[@code=current()/ResourceType]/@description"/>
				<xsl:copy-of select="cmc2-f:doAssetExtended($escid,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','','', $doctypes)"/>
			</xsl:for-each>
		</Assets>
	</xsl:template>
	<!--	-->
</xsl:stylesheet>