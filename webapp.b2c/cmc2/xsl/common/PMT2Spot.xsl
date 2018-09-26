<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:saxon="http://saxon.sf.net/">
	<xsl:output name="output-def" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="pmd">false</xsl:param>
	<xsl:param name="product">false</xsl:param>
	<xsl:param name="asset">false</xsl:param>
	<xsl:param name="keyvalue">false</xsl:param>
	<xsl:param name="milestone">false</xsl:param>
	<xsl:param name="svcURL"/>
	<!-- -->
	<xsl:template match="node()">
			<xsl:apply-templates select="node()"/>
	</xsl:template>
	<!-- -->
	<!-- copy single level of these, then apply templates on childnodes-->
	<xsl:template match="entries|entry[@valid='true']|content">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<!--deep copy these-->
	<xsl:template match="process|octl-attributes|result|@*|entry[@valid='false']">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- MDM Assets-->	
	<!--Product>
	  <CTN>170C6FS/00</CTN> 		 							OK
		<Assets>
		  <Created/>						 					DateTime when version 1 was created by Procoon
		</Assets>
	</Product-->
	<xsl:template match="Product">
		<Product pmd="{$pmd}" product="{$product}" asset="{$asset}" keyvalue="{$keyvalue}" milestone="{$milestone}">
			<xsl:apply-templates select="node()"/>
			<!--Assets-->			
			<xsl:variable name="l">
				<xsl:choose>
					<xsl:when test="ancestor::entry/@l='none' or ancestor::entry/@l='master_global'">en_Philips</xsl:when>
					<xsl:otherwise><xsl:value-of select="ancestor::entry/@l"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="pre_ct" select="substring-before(ancestor::entry/@ct,'2')"/>
			<xsl:variable name="ts" select="substring(ancestor::entry/octl-attributes/lastmodified_ts,1,10)"/>
			<Asset>
			  <Audience>
				  <Audience><xsl:value-of select="ConsumerSegment/ConsumerSegmentName"/></Audience>
			  </Audience>
			  <Creator>ProCoon</Creator>
			  <!--Created/-->
			  <AccessRights>
				<xsl:choose>
					<xsl:when test="$pre_ct='PMT'">External</xsl:when>
					<xsl:otherwise>Internal</xsl:otherwise>
				</xsl:choose>
			  </AccessRights>
			  <Modified><xsl:value-of select="@lastModified"/></Modified>
			  <Description><xsl:value-of select="ancestor::entry/octl-attributes/Remark"/></Description>
			  <Format>text/xml</Format>
			  <Extent><xsl:value-of select="ceiling(string-length(saxon:serialize(.,'output-def')) div 1000)"/>KB</Extent>
			  <InternalResourceIdentifier><xsl:value-of select="$svcURL"/>/service/common/getspotcontent/<xsl:value-of select="$pre_ct"/>/<xsl:value-of select="ancestor::entry/@l"/>/<xsl:value-of select="CTN"/></InternalResourceIdentifier>
			  <SecureResourceIdentifier/><!-- For PMT secure and Public 'should' be  available, however, as Procoon can not deliver that, we always leave them empty-->
			  <PublicResourceIdentifier/>
			  <Language><xsl:value-of select="$l"/></Language>
			  <Publisher>ProCoon</Publisher> 
			  <License><xsl:value-of select="ancestor::entry/octl-attributes/status"/></License>
			  <RightsHolder>Philips</RightsHolder>
			  <ResourceType><xsl:value-of select="$pre_ct"/></ResourceType>
			</Asset>
			<Publisher>ProCoon</Publisher>
			<xsl:call-template name="FullNamingString"/>
      
      <ObjectDeleted/>
      <Description/>
      <FormerPD>CE</FormerPD>
      <Sector>Consumer Life Style</Sector>
		</Product>
	</xsl:template>
	<!-- -->
	<xsl:template match="Code12NC">
		<!-- xsl:copy-of select='.'/ -->
    <NC><xsl:value-of select="text()"/></NC>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product/CTN">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- MDM PMD -->	
	<xsl:template match="GTIN">
		<xsl:copy-of select='.'/>
	</xsl:template>	 
	<!-- -->
	<xsl:template match="CRDateYW">
		<CRDateYW><xsl:value-of select="concat(substring(text(),1,4),'W',substring(text(),5))"/></CRDateYW>
	</xsl:template>	 
  <!-- -->
  <xsl:template match="Categorization/GroupCode">
    <GroupCode><xsl:copy-of select='text()'/></GroupCode>
  </xsl:template>
  <xsl:template match="Categorization/CategoryCode">
    <xsl:copy-of select='.'/>
  </xsl:template>
  <xsl:template match="Categorization/SubcategoryCode">
    <SubCategoryCode><xsl:copy-of select='text()'/></SubCategoryCode>
  </xsl:template>
	<!--MDM PMT Data-->	
	<xsl:template match="ProductName">
		<xsl:copy-of select='.'/>
	</xsl:template> 
	<!-- -->
  <xsl:template match="MasterBrand/BrandCode">
		<MasterBrandCode><xsl:copy-of select='text()'/></MasterBrandCode>
	</xsl:template>
	<!-- -->
	<xsl:template match="MasterBrand/BrandName">
		<MasterBrandName><xsl:copy-of select='text()'/></MasterBrandName>
	</xsl:template>
	<!-- -->
	<xsl:template match="PartnerBrand/BrandCode">
		<PartnerBrandCode><xsl:copy-of select='text()'/></PartnerBrandCode>
	</xsl:template>
	<!-- -->
	<xsl:template match="PartnerBrand/BrandName">
		<PartnerBrandName><xsl:copy-of select='text()'/></PartnerBrandName>
	</xsl:template>
	<!-- -->
	<xsl:template match="Alphanumeric">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="BrandString">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="BrandString2">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="VersionString">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="BrandedFeatureString">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="MarketingStatus">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="DescriptorCode">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="DescriptorName">
		<DescriptorReferenceName><xsl:copy-of select='text()'/></DescriptorReferenceName>
	</xsl:template>
	<!-- -->
	<xsl:template match="Concept[not(IsFamily) or IsFamily=0]/ConceptCode | Family[not(IsFamily) or IsFamily=0]/ConceptCode">
		<xsl:copy-of select='.'/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Concept[not(IsFamily) or IsFamily=0]/ConceptName | Family[not(IsFamily) or IsFamily=0]/ConceptName">
		<ConceptReferenceName><xsl:copy-of select='text()'/></ConceptReferenceName>
	</xsl:template>
	<!-- -->
	<xsl:template match="Concept[IsFamily=1]/ConceptCode | Family[IsFamily=1]/ConceptCode">
		<FamilyCode><xsl:copy-of select='text()'/></FamilyCode>
	</xsl:template>
	<!-- -->
	<xsl:template match="Concept[IsFamily=1]/ConceptName | Family[IsFamily=1]/ConceptName">
		<FamilyReferenceName><xsl:copy-of select='text()'/></FamilyReferenceName>
	</xsl:template>
	<!-- -->
	<xsl:template match="ConsumerSegmentCode">
		<xsl:copy-of select='.'/>
	</xsl:template>	 
	<!-- -->
	<xsl:template match="ConsumerSegmentName">
		<ConsumerSegmentReferenceName><xsl:copy-of select='text()'/></ConsumerSegmentReferenceName>
	</xsl:template>	 
	<!-- -->
	<xsl:template match="MIP_ClassificationCode"><!--xUCDM 1.08-->
		<xsl:copy-of select='.'/>
	</xsl:template>	 
	 <!-- -->
	<xsl:template match="MIP_ClassificationName"><!--xUCDM 1.08-->
		<MIP_ClassificationReferenceName><xsl:copy-of select='text()'/></MIP_ClassificationReferenceName>
	</xsl:template>	 
	<!-- MDM KeyValue-->	
	<xsl:template match="CSChapter/CSItem">
		<KeyValuePair>
			<Code><xsl:copy-of select="CSItemCode/text()"/></Code>
			<Key><xsl:copy-of select="concat(ancestor::CSChapter/CSChapterName/text(),' ',CSItemName/text())"/></Key>
			<Values><xsl:apply-templates select='CSValue'/></Values>
		</KeyValuePair>
	</xsl:template>
	<!-- -->
	<xsl:template match="CSItem/CSValue">
		<Value><xsl:copy-of select="CSValueName/text()"/></Value>
	</xsl:template>
	<!-- -->
	<xsl:template match="KeyBenefitArea">
		<KeyValuePair>
			<Code><xsl:copy-of select="KeyBenefitAreaCode/text()"/></Code>
			<Key><xsl:copy-of select="KeyBenefitAreaName/text()"/></Key>
			<Values><xsl:apply-templates select='Feature'/></Values>
		</KeyValuePair>
	</xsl:template>
	<!-- -->
	<xsl:template match="Feature">
		<Value><xsl:copy-of select="FeatureName/text()"/></Value>
	</xsl:template>
	<!-- -->
	<xsl:template name="FullNamingString">
    <xsl:variable name="TempFullNaming">
      <xsl:choose>
        <xsl:when test="string-length(NamingString/BrandString) &gt; 0">
          <xsl:value-of select="NamingString/BrandString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Concept/ConceptName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Partner/PartnerProductName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Alphanumeric"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/VersionString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandedFeatureString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandString2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="NamingString/MasterBrand/BrandName"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(NamingString/Concept/ConceptName) &gt; 0 and NamingString/Concept/ConceptName != 'NULL'">
              <xsl:value-of select="NamingString/Concept/ConceptName"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="NamingString/SubBrand/BrandName"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Alphanumeric"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/VersionString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandedFeatureString"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <FullNamingString>
      <xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
    </FullNamingString>
  </xsl:template>
	
</xsl:stylesheet>