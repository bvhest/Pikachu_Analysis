<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:sql="http://apache.org/cocoon/SQL/2.0"
		xmlns:cinclude="http://apache.org/cocoon/include/1.0"
		xmlns:cmc2-f="http://www.philips.com/cmc2-f"
		exclude-result-prefixes="sql xsl cinclude"
		extension-element-prefixes="cmc2-f">

	<!--
			Concert AssetList and ObejctList to one Assets list in xucdm-product-export format.
			Only Assets that are sent to the specified assets-channel are included.
	-->
	
	<xsl:param name="doctypes-file-path">../../../../xml/doctype_attributes.xml</xsl:param>
	<xsl:param name="assets-channel">FSS</xsl:param>

	<xsl:include href="../../../../xsl/common/cmc2.function.xsl"/>

	<xsl:variable name="doctypes" select="document($doctypes-file-path)/doctypes"/>
	<xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>	<!--http://images.philips.com/is/image/PhilipsConsumer/42PFL9900D_10-TLP-global-001-->
	<xsl:variable name="number" select="'001'"/>

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="AssetList">
		<xsl:variable name="id" select="octl[1]/sql:rowset/sql:row/sql:object_id"/>
		<Assets>
			<xsl:for-each select="octl/sql:rowset/sql:row/sql:data/object/Asset[ResourceType=$doctypes/doctype[attribute::*[local-name()=$assets-channel]='yes']/@code]">
				<xsl:sort select="ResourceType"/>
				<xsl:sort select="Language"/>
				<xsl:variable name="description" select="($doctypes/doctype[@code=current()/ResourceType][attribute::*[local-name()=$assets-channel]='yes'])[1]/@description"/>
				<xsl:copy-of select="cmc2-f:doAssetExtended($id,Language,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','',Publisher, $doctypes)"/>
			</xsl:for-each>
			
			<!-- Add virtual assets -->
			<xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Single product shot','','','','IMS','',concat($imagepath,replace($id,'/','_'),'-IMS-global'),'')"/>
			<xsl:copy-of select="cmc2-f:doVirtualAsset($id,'global','Product gallery image set','','','','GAL','',concat($imagepath,replace($id,'/','_'),'-GAL-global'),'')"/>
			
			<!-- Object assets -->
			<xsl:apply-templates select="../ObjectAssetList" mode="asset-list"/>
		</Assets>
	</xsl:template>
	
	<xsl:template match="ObjectAssetList"/>

	<xsl:template match="ObjectAssetList" mode="asset-list">
		<xsl:for-each-group select="octl/sql:rowset/sql:row" group-by="sql:object_id">
			<!-- Ignore Global Award Logo, since it conflicts with GAL virtual image -->
			<xsl:for-each select="current-group()/sql:data/object/Asset[ResourceType!='GAL'][ResourceType=$doctypes/doctype[attribute::*[local-name()=$assets-channel]='yes']/@code]">
				<xsl:sort select="ResourceType"/>
				<xsl:sort select="Language"/>
				<xsl:variable name="assetlanguage" select="if(Language = '') then 'global' else Language"/>
				<xsl:variable name="escid" select="replace(../id,'/','_')"/>
				<xsl:variable name="description" select="($doctypes/doctype[@code=current()/ResourceType][attribute::*[local-name()=$assets-channel]='yes'])[1]/@description"/>
				<xsl:copy-of select="cmc2-f:doAssetExtended($escid,$assetlanguage,$description,InternalResourceIdentifier,PublicResourceIdentifier,ResourceType,Modified,$number,'','','', $doctypes)"/>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>
