<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
    exclude-result-prefixes="sql cinclude">

  <xsl:param name="broker-level">5</xsl:param>
  <xsl:param name="xucdm-version" select="'1.1'"/>
  
  <xsl:variable name="vbroker-level" select="if($broker-level = 'min') then number(-1) else if($broker-level = '') then number(5) else number($broker-level)"/>
  <xsl:variable name="l-xucdm-version" select="if ($xucdm-version != '') then number($xucdm-version) else 1.1"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Code12NC[$vbroker-level &lt; 0]"/>
  <xsl:template match="GTIN[$vbroker-level &lt; 0]"/>
  <xsl:template match="DTN[$vbroker-level &lt; 0]"/>
  <xsl:template match="Catalog[$vbroker-level &lt; 0]"/>
  <xsl:template match="Categorization[$vbroker-level &lt; 0]"/>
  <xsl:template match="Assets[$vbroker-level &lt; 0]"/>
  <xsl:template match="ProductName[$vbroker-level &lt; 0]"/>
  <xsl:template match="FullProductName[$vbroker-level &lt; 0]"/>

  <xsl:template match="NamingString[$vbroker-level &lt; 0]"/>

  <xsl:template match="NamingString/PartnerProductName[$vbroker-level &lt; 2]"/>
  <xsl:template match="NamingString/PartnerProductIdentifier[$vbroker-level &lt; 2]"/>

  <xsl:template match="NamingString/BrandString2[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/Concept[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/Family[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/Range[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/Descriptor[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/Alphanumeric[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/VersionElement1[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/VersionElement2[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/VersionElement3[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/VersionElement4[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/VersionString[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/BrandedFeatureCode1[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/BrandedFeatureCode2[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/BrandedFeatureString[$vbroker-level &lt; 1]"/>
  <xsl:template match="NamingString/DescriptorBrandedFeatureString[$vbroker-level &lt; 1]"/>

  <xsl:template match="WOW[$vbroker-level &lt; 2]"/>
  <xsl:template match="SubWOW[$vbroker-level &lt; 2]"/>
  <xsl:template match="MarketingTextHeader[$vbroker-level &lt; 2]"/>
  
  <xsl:template match="KeyBenefitArea[$vbroker-level &lt; 2]"/>
  <xsl:template match="KeyBenefitArea/Feature[$vbroker-level &lt; 3]"/>
  
  <!-- Also remove Logos/Images/Highlights that do not have an asset -->
  <xsl:template match="SystemLogo[$vbroker-level &lt; 3 or empty(SystemLogoCode = ../Assets/Asset/@code)]"/>
  <xsl:template match="PartnerLogo[$vbroker-level &lt; 3 or empty(PartnerLogoCode = ../Assets/Asset/@code)]"/>
  <xsl:template match="FeatureLogo[$vbroker-level &lt; 3 or empty(FeatureCode = ../Assets/Asset/@code)]"/>
  <xsl:template match="FeatureImage[$vbroker-level &lt; 3 or empty(FeatureCode = ../Assets/Asset/@code)]"/>
  <xsl:template match="FeatureHighlight[$vbroker-level &lt; 3 or empty(FeatureCode = ../Assets/Asset/@code)]"/>

  <xsl:template match="CSChapter[$vbroker-level &lt; 2]"/>
  <xsl:template match="Filters/*[$vbroker-level &lt; 2]"/>
  <xsl:template match="Disclaimers/*[$vbroker-level &lt; 2]"/>
  <xsl:template match="KeyValuePairs/*[$vbroker-level &lt; 2]"/>
  <xsl:template match="AccessoryByPacked[$vbroker-level &lt; 2]"/>

  <xsl:template match="Award[$vbroker-level &lt; 2 or not(@AwardType=('global','global_highlight'))]"/>
  <xsl:template match="ProductRefs[$vbroker-level &lt; 2]"/>
  <xsl:template match="ProductReference[$vbroker-level &lt; 2]"/>
  <xsl:template match="ProductReferences[$vbroker-level &lt; 2]"/>

  <xsl:template match="RichTexts/RichText[$vbroker-level &lt; 5]"/>
</xsl:stylesheet>