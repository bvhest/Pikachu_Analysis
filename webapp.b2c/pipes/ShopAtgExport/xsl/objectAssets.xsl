<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	
    <xsl:param name="doctypesfilepath"/>
    
	<xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
	
	<xsl:function name="my:objectAssetMap">
		<xsl:param name="locale"/>
		<xsl:param name="prdNode"/>
		<xsl:param name="objectName"/>
		<xsl:param name="objectId"/>
		<xsl:variable name="localisation" select="if ( $locale = '') then 'global' else $locale"/>
		<xsl:variable name="result">
			<xsl:for-each-group select="$prdNode/ObjectAssetList/Object[id=$objectId]/Asset[replace(Language,'-','_') = $locale]" group-by="ResourceType">
				<xsl:if test="position() != 1">,</xsl:if>
				<!--CLS=$objectName-$objectId-CLS-->
				<xsl:value-of select="concat(current-grouping-key(),'=',$objectName,'-',$objectId,'-',current-grouping-key(),'-',$localisation )"/>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:function>
	
	<xsl:template name="objectAssetList">
		<xsl:param name="locale"/>	
		<xsl:param name="prd"/>
		<xsl:param name="objectName"/>
		<xsl:param name="objectId"/>
		<xsl:for-each-group select="$prd/ObjectAssetList/Object[id=$objectId]/Asset[replace(Language,'-','_') = $locale]" group-by="ResourceType">
			<xsl:variable name="localisation" select="if ( $locale = '') then 'global' else $locale"/>
			<xsl:for-each select="current-group()">
			<xsl:sort	select="Language" order="ascending"/>
				<xsl:variable name="suffixId">
					<xsl:value-of select="format-number(position(),'000')"/>
				</xsl:variable>
				<add-item item-descriptor="asset" id="{concat($objectName,'-',$objectId,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)}" repository="/philips/store/catalog/ProductContentRepository">
					<set-property name="locale"><xsl:value-of select="if ($locale='') then '__NULL__' else $locale"/></set-property>
					<set-property name="documentType">
						<xsl:value-of select="ResourceType"/>
					</set-property>
					<set-property name="mimeType">
						<xsl:value-of select="Format"/>
					</set-property>
					<set-property name="fileSize">
						<xsl:value-of select="Extent"/>
					</set-property>
					<xsl:choose>
						<xsl:when test="PublicResourceIdentifier !='' ">
							<xsl:variable name="ext" select="tokenize(PublicResourceIdentifier,'\.')[last()]"/>
							<set-property name="externalUrl">
								<xsl:value-of select="PublicResourceIdentifier"/>
							</set-property>						
							<xsl:choose>
								<xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
									<set-property name="internalUrl">
										<xsl:value-of select="concat('/consumerfiles/catalog/',$objectId, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )"/>
									</set-property>
								</xsl:when>
								<xsl:otherwise>
									<set-property name="internalUrl">__NULL__</set-property>
								</xsl:otherwise>
							</xsl:choose>								
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="ext" select="tokenize(InternalResourceIdentifier,'\.')[last()]"/>
							<set-property name="externalUrl">
								<xsl:value-of select="InternalResourceIdentifier"/>
							</set-property>
							<!--/catalog/$objectName/$objectId-PWS-global-001.jpg -->
							<xsl:choose>
								<xsl:when test="$doctypesfile/doctypes/doctype[@ATGAssets='yes'and @code=current-grouping-key()]">
								<set-property name="internalUrl">
										<xsl:value-of select="concat('/consumerfiles/catalog/',$objectId, '-' ,current-grouping-key(),'-',$localisation,'-',$suffixId,'.',$ext  )"/>
									</set-property>
								</xsl:when>
								<xsl:otherwise>
									<set-property name="internalUrl">__NULL__</set-property>
								</xsl:otherwise>
							</xsl:choose>							
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$doctypesfile/doctypes/doctype[@Scene7='yes'and @code=current-grouping-key()]">
							<set-property name="imagingServerId">
								<xsl:value-of select="concat($objectId, '-',current-grouping-key(),'-',$localisation,'-',$suffixId )"/>
							</set-property>
						</xsl:when>
						<xsl:otherwise>
							<set-property name="imagingServerId">__NULL__</set-property>
						</xsl:otherwise>
					</xsl:choose>
				</add-item>
			</xsl:for-each>		
			<!-- id=$objectName-$objectId_DFU-->
			<add-item repository="/philips/store/catalog/ProductContentRepository" item-descriptor="assetList" id="{concat($objectName,'-',$objectId,'-',current-grouping-key(),'-',$localisation )}">
				<set-property name="assets">
					<xsl:for-each select="current-group()">
						<xsl:sort	select="Language" order="ascending"/>
						<xsl:variable name="suffixId">
							<xsl:value-of select="format-number(position(),'000')"/>
						</xsl:variable>
						<xsl:if test="position() != 1">,</xsl:if>
						<!-- "$objectName-$objectId-PWS-global-001,$objectName-$objectId-PWS-global-002</ -->
						<xsl:value-of select="concat($objectName,'-',$objectId,'-',current-grouping-key(),'-',$localisation,'-',$suffixId)"/>
					</xsl:for-each>
				</set-property>
			</add-item>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>
