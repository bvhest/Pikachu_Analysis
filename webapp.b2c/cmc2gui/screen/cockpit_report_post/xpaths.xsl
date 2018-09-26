<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="ProductEnhancementContent">
		<ProductReference>
			<Attribute name="CTN">Product/CTN</Attribute>
		</ProductReference>
		<ProductName>
			<Attribute name="DescriptorName">Product/NamingString/Descriptor/DescriptorName</Attribute>
			<Attribute name="VersionElementName1">Product/NamingString/VersionElement1/VersionElementName</Attribute>
			<Attribute name="VersionElementName2">Product/NamingString/VersionElement2/VersionElementName</Attribute>
			<Attribute name="VersionElementName3">Product/NamingString/VersionElement3/VersionElementName</Attribute>
			<Attribute name="VersionElementName4">Product/NamingString/VersionElement4/VersionElementName</Attribute>
		</ProductName>
		<MarketingText>
			<Attribute name="WOW">Product/WOW</Attribute>
			<Attribute name="MarketingTextHeader">Product/MarketingTextHeader</Attribute>
		</MarketingText>
		<Assets>
			<Attribute name="IMS">Product/AssetList/Asset[ResourceType=('PWL','TLP','UWL','_FP','FTP','TRP','RTP','D1P','D2P','D3P','D4P','UPL','U1P','U2P','TSL','RCP','PA1')]</Attribute>
		</Assets>
		<Feature>
			<Attribute name="FeatureName">Product/KeyBenefitArea/Feature/FeatureName</Attribute>
			<Attribute name="FeatureGlossary">Product/KeyBenefitArea/Feature/FeatureGlossary</Attribute>
			<Attribute name="FeatureImageLogoDemoMovie">Product/ObjectAssetList/Object/Asset[ResourceType=('FIL','FLP','FML','FDF')]</Attribute>
			<Attribute name="FeatureMovie">Product/ObjectAssetList/Object/Asset[ResourceType=('FML','FDF')]</Attribute>
		</Feature>
		<KeyBenefitArea>
			<Attribute name="KBA">Product/KeyBenefitArea</Attribute>
		</KeyBenefitArea>
		<Specs>
			<Attribute name="CSI">Product/CSChapter/CSItem</Attribute>
		</Specs>
		<RichAssets>
			<Attribute name="RichAssets">Product/AssetList/Asset[ResourceType=('P3D','PRM','PRD','PRV')]</Attribute>
		</RichAssets>
	</xsl:variable>
	<xsl:variable name="Other">
		<Attribute name="Product-Images-70">Product/AssetList/Asset[ResourceType=('_FN','FTN','PWN','RTN','TLN','TRN','UPN','UWN')]</Attribute>
		<Attribute name="Product-Images">Product/AssetList/Asset[ResourceType=('PWL','TLP','UWL','_FP','FTP','TRP','RTP','D1P','D2P','D3P','D4P','UPL','U1P','U2P','TSL','RCP','PA1')]</Attribute>
		<Attribute name="Product-360">Product/AssetList/Asset[ResourceType=('P3D','PRV')]</Attribute>
		<Attribute name="Product-Videos">Product/AssetList/Asset[ResourceType=('P3D','PRM','PRD','PRV')]</Attribute>
	</xsl:variable>
</xsl:stylesheet>
