<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="ProductEnhancementContent">
    <ProductReference>
      <Attribute name="CTN" copy="text()" resultantxpath="Product/CTN">Product/CTN</Attribute>
    </ProductReference>
    <ProductType>
      <Attribute name="ProductType" copy="text()" resultantxpath="Product/ProductType">Product/ProductType</Attribute>
    </ProductType>
        

    <ProductName>
      <Attribute name="DescriptorName" copy="text()" resultantxpath="Product/DescriptorName">Product/NamingString/Descriptor/DescriptorName</Attribute>
      <Attribute name="VersionElementName1" copy="text()" resultantxpath="Product/VersionElementName[1]">Product/NamingString/VersionElement1/VersionElementName</Attribute>
      <Attribute name="VersionElementName2" copy="text()" resultantxpath="Product/VersionElementName[2]">Product/NamingString/VersionElement2/VersionElementName</Attribute>
      <Attribute name="VersionElementName3" copy="text()" resultantxpath="Product/VersionElementName[3]">Product/NamingString/VersionElement3/VersionElementName</Attribute>
      <Attribute name="VersionElementName4" copy="text()" resultantxpath="Product/VersionElementName[4]">Product/NamingString/VersionElement4/VersionElementName</Attribute>
    </ProductName>
    <MarketingText>
      <Attribute name="WOW" copy="text()" resultantxpath="Product/WOW">Product/WOW</Attribute>
      <Attribute name="MarketingTextHeader" copy="text()" resultantxpath="Product/MarketingTextHeader">Product/MarketingTextHeader</Attribute>
    </MarketingText>
    <Assets>
          <Attribute name="StandardProductPhotograph" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('RTP','TLP')]">Product/AssetList/Asset[ResourceType=('RTP','TLP')]</Attribute>
          <Attribute name="FrontProductPhotograph" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('_FP','FTP')]">Product/AssetList/Asset[ResourceType=('_FP','FTP')]</Attribute>
         <Attribute name="MainInUsePhotograph" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('MI1')]">Product/AssetList/Asset[ResourceType=('MI1')]</Attribute>
          <Attribute name="Product-360" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('P3D','PRV')]">Product/AssetList/Asset[ResourceType=('P3D','PRV')]</Attribute>
		<Attribute name="Product-Videos" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('PRM','PRD')]">Product/AssetList/Asset[ResourceType=('PRM','PRD')]</Attribute>
         
      <Attribute name="GAL" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('PWL','TRP','UWL','RCP','DPP','D1P','D2P','D3P','D4P','D5P', 'PA1','TSL','APP','A1P','A2P','A3P','A4P','A5P','UPL','U1P','U2P','U3P','U4P','U5P', 'CO_','COP')]">Product/AssetList/Asset[ResourceType=('PWL','TRP','UWL','RCP','DPP','D1P','D2P','D3P','D4P','D5P', 'PA1','TSL','APP','A1P','A2P','A3P','A4P','A5P','UPL','U1P','U2P','U3P','U4P','U5P','CO_','COP')]</Attribute>
    </Assets>
    <Feature>
      <Attribute name="FeatureName" copy="text()" resultantxpath="Product/FeatureName">Product/KeyBenefitArea/Feature/FeatureName</Attribute>
      <Attribute name="FeatureGlossary" copy="text()" resultantxpath="Product/FeatureGlossary">Product/KeyBenefitArea/Feature/FeatureGlossary</Attribute>
      
     <Attribute name="FeatureLogos" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('FLP')]">Product/ObjectAssetList/Object/Asset[ResourceType=('FLP')]</Attribute>
  
      <Attribute name="FeatureImages" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('FIL')]">Product/ObjectAssetList/Object/Asset[ResourceType=('FIL')]</Attribute>
  
      <Attribute name="FeatureMovies" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('FML','FDF')]">Product/ObjectAssetList/Object/Asset[ResourceType=('FML','FDF')]</Attribute>
      

    </Feature>
    <KeyBenefitArea>
      <Attribute name="KBA" copy="KeyBenefitAreaCode" resultantxpath="Product/KeyBenefitArea/KeyBenefitAreaCode">Product/KeyBenefitArea</Attribute>
    </KeyBenefitArea>
    <Specs>
      <Attribute name="CSI" copy="CSItemCode" resultantxpath="Product/CSItem/CSItemCode">Product/CSChapter/CSItem</Attribute>
    </Specs>
    
  </xsl:variable>
  
  <xsl:variable name="Other">
    <!--Attribute name="Product-Images-70" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('_FN','FTN','PWN','RTN','TLN','TRN','UPN','UWN')]">Product/AssetList/Asset[ResourceType=('_FN','FTN','PWN','RTN','TLN','TRN','UPN','UWN')]</Attribute-->
    
      <Attribute name="Feature-Glossary" copy="text()" resultantxpath="Product/FeatureGlossary">Product/KeyBenefitArea/Feature/FeatureGlossary</Attribute>
          
    <Attribute name="Product-Images" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('PWL','TRP','UWL','RCP','DPP','D1P','D2P','D3P','D4P','D5P', 'PA1','TSL','APP','A1P','A2P','A3P','A4P','A5P','UPL','U1P','U2P','U3P','U4P','U5P','RTP','TLP','_FP','FTP', 'MI1', 'CO_', 'COP') ]">Product/AssetList/Asset[ResourceType=('PWL','TRP','UWL','RCP','DPP','D1P','D2P','D3P','D4P','D5P', 'PA1','TSL','APP','A1P','A2P','A3P','A4P','A5P','UPL','U1P','U2P','U3P','U4P','U5P','RTP','TLP','_FP','FTP', 'MI1', 'CO_','COP' )]</Attribute>
    <Attribute name="Product-360" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('P3D','PRV')]">Product/AssetList/Asset[ResourceType=('P3D','PRV')]</Attribute>
    <Attribute name="Product-Videos" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('PRM','PRD')]">Product/AssetList/Asset[ResourceType=('PRM','PRD')]</Attribute>

      <Attribute name="Feature-Videos" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('FML','FDF')]">Product/ObjectAssetList/Object/Asset[ResourceType=('FML','FDF')]</Attribute>
       <Attribute name="Feature-Images" copy="ResourceType" resultantxpath="Product/Asset[ResourceType=('FIL')]">Product/ObjectAssetList/Object/Asset[ResourceType=('FIL')]</Attribute>       
   
   </xsl:variable>

</xsl:stylesheet>