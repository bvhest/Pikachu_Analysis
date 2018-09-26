<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="dir"/>
	
	<!-- MDM Products-->	
	 <!--Product>
		  <CTN>100WT10P/27</CTN>  							OK
		  <Alphanumeric>100WT10P</Alphanumeric> 				OK
		  <MarketingStatus>Registered with SAP</MarketingStatus> 	OK
		  <MasterBrandCode>PHI</MasterBrandCode> 				OK
		  <MasterBrandName>Philips</MasterBrandName> 			OK
		  <PartnerBrandCode /> 								OK
		  <PartnerBrandName /> 								OK
		  <FullNamingString>Philips 100WT10P</FullNamingString>	?? (not in Excel)
		  <ProductName /> 									OK
		  <ConceptCode /> 									OK 
		  <ConceptName /> 									OK
		  <FamilyCode /> 									OK
		  <FamilyName /> 									OK
		 <ConsumerSegmentCode /> 							OK
		<ConsumerSegmentName /> 							OK
		<MIPClassificationCode /> 							??
		<MIPClassificationName /> 							?? 
	  </Product-->
	<xsl:template match="entries">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/','xSPOT_Data_020.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
			</source:source>
			<source:fragment>
				<ProductsMsg version="2.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}" docSource="ProCoon">
					<xsl:apply-templates select="entry"/>
				</ProductsMsg>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="entry[@valid='true']">
			<xsl:apply-templates select="content/Product[@product='true']"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product[@product='true' and CTN]">
		<Product>
      <ObjectType>CTV</ObjectType>
			<ObjectKey><xsl:value-of select="CTN"/></ObjectKey>
      <CTV_ID><xsl:value-of select="CTN"/></CTV_ID>
      <xsl:copy-of select="SubCategoryCode"/>
			<xsl:copy-of select="Alphanumeric"/>
			<xsl:copy-of select="BrandString"/>
			<xsl:copy-of select="BrandString2"/>
			<xsl:copy-of select="DescriptorCode"/>
			<xsl:copy-of select="DescriptorReferenceName"/>
			<xsl:copy-of select="FullNamingString"/>
			<xsl:copy-of select="ProductName"/>
			<xsl:copy-of select="ConceptCode"/>
			<xsl:copy-of select="ConceptReferenceName"/>
			<xsl:copy-of select="FamilyCode"/>
			<xsl:copy-of select="FamilyReferenceName"/>
			<xsl:copy-of select="ConsumerSegmentCode"/>
			<xsl:copy-of select="ConsumerSegmentReferenceName"/>
			<xsl:copy-of select="MIPClassificationCode"/>
			<xsl:copy-of select="MIPClassificationReferenceName"/>
		</Product>
	</xsl:template>	
	
	<xsl:template match="entry[@valid='false']|Product"/><!-- erase everything else -->
</xsl:stylesheet>