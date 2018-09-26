<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="contentType"/>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<!-- -->
	<!--
OBJECT_ID, 
DOCTYPE, 
LOCALE, 
ASSET_RESOURCE_REF, 
PRODUCT_ASSET, 
DELETED, 
MD5, 
LANG, 
LICENSE, 
ACCESS_RIGHTS, 
MODIFIED, 
PUBLISHER, 
INTERNALRESOURCEIDENTIFIER, 
SECURERESOURCEIDENTIFIER, 
PUBLICRESOURCEIDENTIFIER, 
CREATOR, 
FORMAT, 
EXT, 
SHORT_DESCRIPTION,
LASTMODIFIED
-->
	<xsl:template match="Asset">
 <!-- if (PublicResourceIdentifier = null) then '' else PublicResourceIdentifier -->
    <xsl:value-of select="string-join((../id
                                      ,ResourceType
                                      ,../../../@l
                                      ,substring-after(substring-after(InternalResourceIdentifier,'mprdata/'),'/' )
                                      ,if ($contentType = 'ObjectAssetList') then '0' else '1'
                                      ,if (License = 'Obsolete') then '1' else '0'
                                      ,if (Md5) then Md5 else ''
                                      ,Language
                                      ,License
                                      ,AccessRights
                                      ,Modified
                                      ,Publisher
                                      ,InternalResourceIdentifier
                                      ,if (SecureResourceIdentifier) then SecureResourceIdentifier else ''
                                      ,if (PublicResourceIdentifier) then PublicResourceIdentifier else ''
                                      ,if (Creator) then Creator else ''
                                      ,Format
                                      ,Extent
                                      ,''
                                      ,../../../../@ts),'|')"/><xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
