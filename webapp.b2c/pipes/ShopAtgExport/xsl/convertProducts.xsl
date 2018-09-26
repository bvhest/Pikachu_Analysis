<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
    exclude-result-prefixes="sql"
    extension-element-prefixes="cmc2-f">
  
  <xsl:import href="../../common/xsl/xucdm-internal.xsl"/>
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="doctypesfilepath"/>
  
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>  
  <xsl:variable name="included-award-types" select="('global','global_highlight','ala_award')"/>
  
  <xsl:template match="sql:id|sql:locale|sql:language|sql:sop|sql:eop|sql:catalog|sql:groupcode|sql:groupname|sql:asset_data|sql:lastexportdate|sql:masterlocaleenabled" />
  <xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <xsl:template match="sql:rowset[@name='product-accessories']"/>
  <xsl:template match="sql:rowset[@name='compatibleMotherProducts']"/>

  
  <!-- sql:masterdata contains the PMT_Localised content -->
  <xsl:template match="sql:masterdata[empty(Product)]"/>
  <xsl:template match="sql:masterdata[Product]">
    <MasterProduct>
      <xsl:attribute name="Locale" select="concat('en_', substring-after(../sql:locale,'_'))" />
      <xsl:attribute name="CTN" select="../sql:data/Product/CTN" />
      <xsl:apply-templates select="Product"/>
    </MasterProduct>
  </xsl:template>

  <xsl:template match="sql:masterdata/Product">
    <xsl:variable name="master-product">
      <xsl:next-match />
    </xsl:variable>
    <xsl:copy-of select="$master-product/Product/@*[name()!='Locale']|$master-product/Product/*" />
  </xsl:template>
  
  <xsl:template match="Product">
    <Product>
      <xsl:apply-templates select="@*[not(local-name() = 'lastModified' or local-name() = 'masterLastModified' or local-name() = 'Brand' or local-name() = 'Division')]"/>   
      <!-- Ensure lastModified and masterLastModified have a 'T' in them -->
      <xsl:attribute name="lastModified" select="concat(substring(@lastModified,1,10),'T',substring(@lastModified,12,8))"/>
      <xsl:attribute name="Brand" select="NamingString/MasterBrand/BrandCode"/>
      <xsl:if test="ProductDivision/FormerPDCode">
        <xsl:attribute name="Division" select="if(ProductDivision/FormerPDCode='0300')then 'DAP' else 'CE'"/>
      </xsl:if>
      <xsl:if test="@masterLastModified">
        <xsl:attribute name="masterLastModified" select="concat(substring(@masterLastModified,1,10),'T',substring(@masterLastModified,12,8))"/>
      </xsl:if>
      <xsl:call-template name="OptionalHeaderAttributes"/>
      <xsl:apply-templates select="CTN"/>
      <xsl:apply-templates select="DTN"/>
      <xsl:call-template name="OptionalHeaderData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
        <xsl:with-param name="division" select="../../sql:division"/>
      </xsl:call-template>
      <xsl:call-template name="ProductImage">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      <xsl:call-template name="Assets">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
      <xsl:apply-templates select="ProductName"/>
      <xsl:apply-templates select="FullProductName"/>
      <xsl:apply-templates select="SEOProductName"/>
      <xsl:apply-templates select="NamingString"/>
      <xsl:apply-templates select="ShortDescription"/>
      <xsl:apply-templates select="WOW"/>
      <xsl:apply-templates select="SubWOW"/>
      <xsl:apply-templates select="MarketingTextHeader"/>
      <!-- Deprecated in xUCDM 1.1
      <xsl:apply-templates select="MarketingTextBody"/>
      -->
      <MarketingTextBody/>      
      <xsl:apply-templates select="SupraFeature"/>
      <xsl:apply-templates select="ConsumerSegment"/>    
      <xsl:apply-templates select="KeyBenefitArea">
        <xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="SystemLogo">
        <xsl:sort data-type="number" select="SystemLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="PartnerLogo">
        <xsl:sort data-type="number" select="PartnerLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureLogo">
        <xsl:sort data-type="number" select="FeatureLogoRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureImage">
        <xsl:sort data-type="number" select="FeatureImageRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="FeatureHighlight">
        <xsl:sort data-type="number" select="FeatureHighlightRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="CSChapter">
        <xsl:sort data-type="number" select="CSChapterRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="Disclaimers"/>
      <xsl:apply-templates select="AccessoryByPacked">
        <xsl:sort data-type="number" select="AccessoryByPackedRank"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="ReviewStatistics"/>
      <xsl:call-template name="Awards"/>
    
			<ProductRefs>
		      <xsl:apply-templates select="ProductRefs/ProductReference|ProductReferences"/>
			  	<ProductReference>
		        <xsl:variable name="ctn" select="CTN"/>
            <xsl:attribute name ="ProductReferenceType">compatibleMotherProducts</xsl:attribute>
            <xsl:for-each select="/Products/sql:rowset[@name ='compatibleMotherProducts']/sql:row[sql:object_id_tgt=$ctn]/sql:motherproducts_id">            
		            <CTN><xsl:value-of select="."/></CTN>
            </xsl:for-each> 
          </ProductReference>
		    </ProductRefs>
	
      <xsl:apply-templates select="ProductOwner"/>
      <xsl:apply-templates select="MarketingVersion"/>
      <xsl:apply-templates select="MarketingStatus"/>
      <xsl:apply-templates select="GTIN"/>
      <xsl:apply-templates select="Code12NC"/>
      <xsl:apply-templates select="CRDate"/>
      <xsl:apply-templates select="RichTexts"/>
      <xsl:apply-templates select="GreenData"/>
      <xsl:apply-templates select="ModelYears"/>    
      <xsl:apply-templates select="Filters"/>    
      <xsl:call-template name="OptionalFooterData">
        <xsl:with-param name="ctn" select="CTN"/>
        <xsl:with-param name="language" select="../../sql:language"/>
        <xsl:with-param name="locale" select="@Locale"/>
      </xsl:call-template>
    </Product>
  </xsl:template>

  
  <!--  Empty CSValueName -->  
  <xsl:template match="Product[count(CSChapter/CSItem/CSValue/CSValueCode) != count(CSChapter/CSItem/CSValue/CSValueName)]"/>
  <!--  Empty ProductName (bug in PFS) -->  
  <xsl:template match="Product[ProductName='' and (not(NamingString/Descriptor/DescriptorName) or NamingString/Descriptor/DescriptorName = '')]" />
  
  <!-- Prepend Family or Cluster name to ProductName -->
  <xsl:template match="ProductName">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="cmc2-f:product-display-name(..)" />
    </xsl:copy>
  </xsl:template>
    
  <xsl:template name="Assets">
      <xsl:choose>
        <xsl:when test="ancestor::sql:masterdata">
          <!-- For the master content copy asset from the full PMT content -->
          <!-- Disabled: not clear if master assets need to be sent separately
          <AssetList locale="master_global">
            <xsl:apply-templates select="ancestor::sql:masterdata/preceding-sibling::sql:data/Product/AssetList/Asset" mode="master"/>
          </AssetList>
          <ObjectAssetList locale="master_global">
            <xsl:variable name="oal">
              <xsl:apply-templates select="ancestor::sql:masterdata/preceding-sibling::sql:data/Product/ObjectAssetList/Object" mode="master"/>
            </xsl:variable>
            <xsl:copy-of select="$oal/Object[Asset]" />
          </ObjectAssetList>
          -->
        </xsl:when>
        <xsl:otherwise>
          <AssetList>
            <!-- 2010-sep-03: 
               | Implemented in the AtgExport, AtgMerchandise, AtgProducts and AtgRanges.
               | Quick Fix because Atg can't deal with the Iso 'he_IL' locale (Java bug): replace 'he_IL' with 'iw_IL'. 
               -->
            <xsl:attribute name="locale" select="if (../../sql:locale='he_IL') then 'iw_IL' else ../../sql:locale"/>
            <xsl:apply-templates select="AssetList/Asset" />
          </AssetList>
          <ObjectAssetList>
            <xsl:attribute name="locale" select="if (../../sql:locale='he_IL') then 'iw_IL' else ../../sql:locale"/>
            <!-- We don't want Objects if all Assets were filtered out -->
            <xsl:variable name="oal">
              <xsl:apply-templates select="ObjectAssetList/Object" />
            </xsl:variable>
            <xsl:copy-of select="$oal/Object[Asset]" />
          </ObjectAssetList>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
    
  <xsl:template match="Asset[ResourceType='URL' or Format='']" priority="1" mode="#all"/>
  <xsl:template match="Asset[Language!='' and Language!='en_US']" priority="1" mode="master"/>
  
  <xsl:template match="Asset" mode="#all">
    <xsl:if test="ResourceType=$doctypesfile/doctypes/doctype[@ATG='yes']/@code 
              and (PublicResourceIdentifier != '' 
                   or ( (not(PublicResourceIdentifier) or PublicResourceIdentifier = '') 
                    and (starts-with(Format,'image') or starts-with(Format,'movie') or starts-with(Format,'video') or ResourceType='P3D' ) 
                   ) 
                  ) ">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()" />
      </xsl:copy>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="NavigationAttribute">
    <NavigationAttribute>
      <xsl:apply-templates select="NavigationAttributeCode|NavigationAttributeName|NavigationAttributeRank"/>
      <xsl:apply-templates select="NavigationValue">
        <xsl:sort data-type="number" select="NavigationValueRank"/>
      </xsl:apply-templates>
    </NavigationAttribute>
  </xsl:template>  
  
  <!-- Ignore Award types that are not to be included -->  
  <xsl:template match="Award[not(@AwardType=$included-award-types)]"/>
  <!-- RichTexts not used -->  
  <xsl:template match="RichTexts"/>

  <!-- Fix Israel locale for Java -->
  <xsl:template match="Language">
    <Language><xsl:value-of select="if (text()='he_IL') then 'iw_IL' else text()"/></Language>
  </xsl:template>
  <xsl:template match="@Locale[.='he_IL']">
    <xsl:attribute name="Locale">
      <xsl:value-of select="'iw_IL'" /> 
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@locale[.='he_IL']">
    <xsl:attribute name="locale">
      <xsl:value-of select="'iw_IL'" /> 
    </xsl:attribute>
  </xsl:template>
  
  <!-- Remove Accessories that are not available for the current country -->
  <xsl:template match="ProductRefs/ProductReference[@ProductReferenceType='Accessory']/CTN">
    <xsl:if test="exists(ancestor::Products/sql:rowset[@name='product-accessories']/sql:row/sql:accessory_id[.=current()])">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template name="OptionalHeaderAttributes">
    <xsl:attribute name="DivisionCode" select="../../sql:division"/>
    <xsl:attribute name="MasterDescriptorBrandedFeatureString" select="../../sql:master_data/Product/NamingString/DescriptorBrandedFeatureString"/>
  </xsl:template>
  <xsl:template name="OptionalHeaderData"/>
  <xsl:template name="OptionalFooterData">
    <xsl:for-each select="NavigationGroup">
      <NavigationGroup>
        <xsl:apply-templates select="NavigationGroupCode|NavigationGroupName|NavigationGroupRank"/>
        <xsl:apply-templates select="NavigationAttribute">
          <xsl:sort data-type="number" select="NavigationAttribributeRank"/>
        </xsl:apply-templates>      
      </NavigationGroup>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
