<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2" extension-element-prefixes="sql cmc2-f asset-f ">
	<xsl:param name="doctypesfilepath"/>
	<xsl:param name="channel"/>
	<xsl:param name="type"/>
	<xsl:param name="asset-syndication"/>
	<xsl:param name="broker-level"/>
	<xsl:param name="system"/>
	<xsl:param name="exportdate"/>
	<xsl:param name="full"/>
	
	<xsl:import href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
	<xsl:import href="../../../../pipes/common/xsl/xUCDM-external-assets.xsl"/>
	<xsl:variable name="doctypesfile" select="document('/doctype_attributes1.xml')"/>
	
	<xsl:variable name="domains" select="document('../../../../cmc2/xml/countryDomains.xml')/domains"/>
	<xsl:variable name="source">Philips</xsl:variable>
	
	<xsl:variable name="rundate" select="concat(substring($exportdate,1,4)
                                             ,'-'
                                             ,substring($exportdate,5,2)
                                             ,'-'
                                             ,substring($exportdate,7,2)
                                             ,'T'
                                             ,substring($exportdate,10,2)
                                             ,':'
                                             ,substring($exportdate,12,2)
                                             ,':00')"/>
	<xsl:template match="/root">
		<xsl:variable name="locale">
      <xsl:choose>
        <xsl:when test="exists(sql:rowset[@name='Product']/sql:row[1]/sql:master_locale)">
          <xsl:value-of select="sql:rowset[@name='Product']/sql:row[1]/sql:master_locale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="sql:rowset[@name='Product']/sql:row[1]/sql:locale"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

	<xsl:element name="Feed">
				<xsl:attribute name="market" select="lower-case(substring ($locale,4,5))"/>
				<xsl:attribute name="language" select="(substring ($locale,1,2))"/>
				<xsl:apply-templates select="sql:rowset"/>
	</xsl:element>
	</xsl:template>
	
	<xsl:template match="sql:rowset[@name='Product']">
			<xsl:apply-templates select="sql:row" mode="product"/>
	</xsl:template>
	
	<xsl:template match="sql:row" mode="product">
		<xsl:apply-templates select="sql:data/Product" mode="product"/>
	</xsl:template>

	<!-- Product element -->
	<xsl:template match="Product" mode="product">
		<xsl:variable name="Row" select="../.."/>
		<xsl:variable name="Product" select="."/>		
		<xsl:variable name="ctn">
			<xsl:if test="exists($Product/CTN)">
	        <xsl:value-of select="$Product/CTN"/>
	    </xsl:if>
		</xsl:variable>	
		<xsl:variable name="divisionName">
      <xsl:if test="exists($Product/ProductDivision/ProductDivisionName)">
          <xsl:value-of select="$Product/ProductDivision/ProductDivisionName"/>
      </xsl:if>
		</xsl:variable>				
		<xsl:variable name="locale">
      <xsl:choose>
        <xsl:when test="exists($Row/sql:master_locale)">
          <xsl:value-of select="$Row/sql:master_locale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$Row/sql:locale"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="energyLabelCode">
      <xsl:choose>
        <xsl:when test="exists($Product/GreenData/EnergyLabel/ApplicableFor/Code)">
          <xsl:value-of select="$Product/GreenData/EnergyLabel/ApplicableFor/Code"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="' '"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	
		<xsl:variable name="id" select="cmc2-f:escape-scene7-id($Row/sql:id)"/>
		<xsl:variable name="catalogtype" select="$Row/sql:categorization_catalogtype"/>

		<xsl:element name="Product">
			
			<xsl:element name="PartNumber">
				<xsl:value-of select="$ctn"/>
			</xsl:element>
			<xsl:element name="ProductDescription">
				<xsl:value-of select="$Product/ProductName"/>
			</xsl:element>
			<xsl:element name="UpcEan">
				<xsl:value-of select="$Product/GTIN"/>
			</xsl:element>
			<xsl:element name="LaunchDate">
				<xsl:value-of select="$Product/CRDate"/>
			</xsl:element>
			<xsl:element name="EndOfLifeDate">
			</xsl:element>
			<xsl:element name="MarketingText">
				<xsl:value-of select="$Product/MarketingTextHeader"/>
			</xsl:element>
			<KeySellingPoints>
				<xsl:element name="Item">
				<xsl:value-of select="if ($Product/NamingString/VersionElement1/VersionElementName !='') then $Product/NamingString/VersionElement1/VersionElementName else '' "/>
				</xsl:element>
				<xsl:element name="Item">
				<xsl:value-of select="if ($Product/NamingString/VersionElement2/VersionElementName !='') then $Product/NamingString/VersionElement2/VersionElementName else '' "/>
				</xsl:element>
				<xsl:element name="Item">
				<xsl:value-of select="if ($Product/NamingString/VersionElement3/VersionElementName !='') then $Product/NamingString/VersionElement3/VersionElementName else '' "/>
				</xsl:element>
				<xsl:element name="Item">
				<xsl:value-of select="if ($Product/NamingString/VersionElement4/VersionElementName !='') then $Product/NamingString/VersionElement4/VersionElementName else '' "/>
				</xsl:element>	
			</KeySellingPoints>
			
			 
			
			<WhatIsInTheBox> 
					 <xsl:for-each select="$Product/CSChapter[./CSChapterCode='CH4008581']/CSItem/CSItemName">
						 	<xsl:element name="Item">
								<xsl:value-of select="."/>
							</xsl:element>	
					 </xsl:for-each> 
			
			</WhatIsInTheBox>
			<!-- Categorization starts-->
			<xsl:for-each select="ancestor::sql:row/sql:rowset[@name='cat']/sql:row">
				<xsl:choose>
				  <xsl:when test="sql:catalogcode = 'CONSUMER'">                 
							<Categorization type="{sql:catalogcode}">						        						        
									<GroupCode><xsl:value-of select="sql:groupcode"/></GroupCode>
									<GroupName><xsl:value-of select="sql:groupname"/></GroupName>
									<CategoryCode><xsl:value-of select="sql:categorycode"/></CategoryCode>
									<CategoryName><xsl:value-of select="sql:categoryname"/></CategoryName>
									<SubcategoryCode><xsl:value-of select="sql:subcategorycode"/></SubcategoryCode>
									<SubcategoryName><xsl:value-of select="sql:subcategoryname"/></SubcategoryName>
								  </Categorization>		   
				  </xsl:when>
				  <xsl:otherwise>                 
					  					      
				  </xsl:otherwise>             
			  </xsl:choose>
			</xsl:for-each>
	  <!-- Categorization ends-->
			<ProductFeatures>
				
				<xsl:for-each select="$Product/ObjectAssetList/Object">
					<xsl:variable name="vid" select="./id" />
					<xsl:for-each select="./Asset">
						<xsl:variable name="resourceType" select="./ResourceType" />
						<xsl:variable name="feature_series" select="'FDB, FIL, FLP, FMB'"/>
						<xsl:variable name="feature_series_vid" select="'FML, FQL'"/>
						<xsl:if test="contains($feature_series, $resourceType)">
							<Item>	
							<xsl:element name="Media">
							<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$resourceType" /></xsl:attribute>
								<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $vid, $resourceType, 'global', '' )"/>
							</xsl:element>
							</xsl:element>
							<Orientation/>
							<xsl:element name="Name">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureName"/>
							</xsl:element>
							<xsl:element name="Code">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureCode"/>
							</xsl:element>
							<xsl:element name="Header">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureLongDescription"/>
							</xsl:element>
							<xsl:element name="Text">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureGlossary"/>
							</xsl:element>
							</Item>
						</xsl:if>
						
						<xsl:if test="contains($feature_series_vid, $resourceType)">
							<xsl:variable name="PublicResourceIdentifier" select="current()/PublicResourceIdentifier" />
							
							<Item>	
							<xsl:if test="$PublicResourceIdentifier != ''">
								<xsl:element name="Media">
								<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$resourceType" /></xsl:attribute>
									<xsl:value-of select="$PublicResourceIdentifier" />
								</xsl:element>
								</xsl:element>
							</xsl:if>
							
							<Orientation/>
							<xsl:element name="Name">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureName"/>
							</xsl:element>
							<xsl:element name="Code">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureCode"/>
							</xsl:element>
							<xsl:element name="Header">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureLongDescription"/>
							</xsl:element>
							<xsl:element name="Text">
								<xsl:value-of select="$Product/KeyBenefitArea/Feature[./FeatureCode=$vid]/FeatureGlossary"/>
							</xsl:element>
							</Item>
						</xsl:if>
						<!--<xsl:if test = "./ResourceType != 'FIL' ">
							<xsl:variable name="resourceType" select="./ResourceType" />
							<xsl:variable name="feature_series" select="'FDB, FIL, FLP, FMB'"/>
							<xsl:if test="contains($feature_series, $resourceType)">
								<xsl:element name="ZZZtest">
									<xsl:element name="Media">
										<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $vid, $resourceType, 'global', '' )"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:if>-->
					
					</xsl:for-each>
					
				</xsl:for-each> 		
			</ProductFeatures>    

			<VisualFeatures>
				<xsl:for-each select="$Product/ObjectAssetList/Object">
					<xsl:for-each select="./Asset">

					<xsl:if test = "./ResourceType = 'FML' ">
					<Group>
					<xsl:variable name="fml_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">FML</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($fml_url_date)) , 'FML', 'global', '' )"/>
					</xsl:element>	
					</xsl:element>
					</Group>
					</xsl:if>
				
					<xsl:if test = "./ResourceType = 'HQ1' ">
					<Group>
					<xsl:variable name="hq1_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">HQ1</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq1_url_date)) , 'HQ1', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'HQ2' ">
					<Group>
					<xsl:variable name="hq2_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">HQ2</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq2_url_date)) , 'HQ2', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'HQ3' ">
					<Group>
					<xsl:variable name="hq3_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">HQ3</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq3_url_date)) , 'HQ3', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'HQ4' ">
					<Group>
					<xsl:variable name="hq4_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">HQ4</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq4_url_date)) , 'HQ4', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'HQ5' ">
					<Group>
					<xsl:variable name="hq5_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">HQ5</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq5_url_date)) , 'HQ5', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PM2' ">
					<Group>
					<xsl:variable name="pm2_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">PM2</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($pm2_url_date)) , 'PM2', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PM3' ">
					<Group>
					<xsl:variable name="pm3_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">PM3</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($pm3_url_date)) , 'PM3', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PM4' ">
					<Group>
					<xsl:variable name="pm4_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">PM4</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($pm4_url_date)) , 'PM4', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PM5' ">
					<Group>
					<xsl:variable name="pm5_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">PM5</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($pm5_url_date)) , 'PM5', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PRD' ">
					<Group>
					<xsl:variable name="prd_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">FRD</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($prd_url_date)) , 'PRD', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>

					<xsl:if test = "./ResourceType = 'PRM' ">
					<Group>
					<xsl:variable name="prm_url_date">
						<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
							<xsl:if test="position() eq last()">
								<xsl:for-each select="tokenize(.,'_')">
									<xsl:if test="position() eq 1">
							       		<xsl:value-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="Item">
					<xsl:element name="Asset">
							<xsl:attribute name="type">PRM</xsl:attribute>
							<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($prm_url_date)) , 'PRM', 'global', '' )"/>
					</xsl:element>
					</xsl:element>
					</Group>
					</xsl:if>


					</xsl:for-each>
				</xsl:for-each>
			
		       </VisualFeatures>

			<Footnotes>
				<xsl:for-each select="$Product/Disclaimers/Disclaimer/DisclaimerText">
						<Item>
						       <xsl:element name="Id">
								<xsl:value-of select="position()"/>
							</xsl:element> 
							<xsl:element name="Text">
								<xsl:value-of select="."/>
							</xsl:element>
						</Item>
				</xsl:for-each>
			</Footnotes>
			
			<LegalCopy>
				<xsl:for-each select="$Product/Disclaimers/Disclaimer/DisclaimerText">
					<xsl:element name="Item">
								<xsl:value-of select="."/>
							</xsl:element>
				
				</xsl:for-each>
			</LegalCopy>
			<xsl:element name="HeroImage">
			<xsl:element name="Asset">
							<xsl:attribute name="type">IMS</xsl:attribute>
				<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, 'IMS', $locale, '' )"/>
			</xsl:element>
			</xsl:element>
			<Images>
				<xsl:for-each select="AssetList/Asset">
					<xsl:variable name="position" select="position()" />
					<xsl:variable name="code"
						select="$doctypesfile/doctypes/images/doctype[@code = current()/ResourceType]/@code" />
					<!--<xsl:if test="$code">
						<xsl:element name="Image">
							<xsl:value-of
								select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, $code, 'global', '' )" />
						</xsl:element>
					</xsl:if>-->
					<xsl:variable name="PDF_series" select="'PRF,EEL,ELR,TEG,TCO'"/>
					<xsl:choose>
					  <xsl:when test="contains($PDF_series, current()/ResourceType)">
					  <xsl:variable name="PublicResourceIdentifier" select="current()/PublicResourceIdentifier" />
						<xsl:if test="$PublicResourceIdentifier != ''">
							<xsl:element name="Image">
							<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="current()/ResourceType" /></xsl:attribute>
								<xsl:value-of
											select="$PublicResourceIdentifier" />
							</xsl:element>
							</xsl:element>
						</xsl:if>
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:variable name="locale_series" select="'KA1,KA2,KA3,KA4,KA5,KA6,KA7,KA8,KA9,FMN,VS1,VS2,VS3,VS4,VS5'"/>
						<xsl:choose>
						  <xsl:when test="contains($locale_series, current()/ResourceType)">
							<xsl:if test="$code">
								<xsl:element name="Image">
								<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$code" /></xsl:attribute>
									<xsl:value-of
										select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, $code, $locale, '' )" />
								</xsl:element>
								</xsl:element>
							</xsl:if>
						  </xsl:when>
						  <xsl:otherwise>
							<xsl:if test="$code">
								<xsl:element name="Image">
								<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$code" /></xsl:attribute>
									<xsl:value-of
										select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, $code, 'global', '' )" />
								</xsl:element>
								</xsl:element>
							</xsl:if>
						  </xsl:otherwise>
						</xsl:choose>
					  </xsl:otherwise>
					</xsl:choose>
					
				</xsl:for-each>

				<!--ObjectAssetList-->
				<xsl:for-each select="$Product/ObjectAssetList/Object/Asset">
					<xsl:variable name="codeObj"
						select="$doctypesfile/doctypes/images/doctype[@code = current()/ResourceType]/@code" />
					<xsl:variable name="PublicResourceIdentifier" select="current()/PublicResourceIdentifier" />
					
					<xsl:choose>
					  <xsl:when test="$codeObj = 'ENR' or $codeObj = 'ENL'">
						<xsl:if test="$energyLabelCode != ''">
							<xsl:element name="Image">
							<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$codeObj" /></xsl:attribute>
							<xsl:value-of
								select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $energyLabelCode, $codeObj, 'global', '' )" />
							</xsl:element>
							</xsl:element>
						</xsl:if>
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:if test="$codeObj != ''">
							<xsl:if test="$PublicResourceIdentifier != ''">
								<xsl:element name="Image">
								<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$codeObj" /></xsl:attribute>
									<xsl:value-of
										select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, $codeObj, 'global', '' )" />
								</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					  </xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:element name="Image">
				<xsl:element name="Asset">
							<xsl:attribute name="type">IMS</xsl:attribute>
					<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, 'IMS', $locale, '' )"/>
				</xsl:element>
				</xsl:element>
				<xsl:element name="Image">
				<xsl:element name="Asset">
							<xsl:attribute name="type">GAL</xsl:attribute>
				
					<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', $id, 'GAL', $locale, '' )"/>
				</xsl:element>
				</xsl:element>
			</Images>
			<xsl:element name="ManufacturerLogo">
			<xsl:element name="Asset">
							<xsl:attribute name="type">BRP</xsl:attribute>
				<xsl:value-of select="asset-f:buildScene7Url('http://images.philips.com/is/image/PhilipsConsumer/', 'PHI', 'BRP', 'global', '' )"/>
				</xsl:element>
			</xsl:element>
			<Videos>
				<xsl:for-each select="AssetList/Asset">
					<xsl:variable name="position" select="position()" />
					<xsl:variable name="code"
						select="$doctypesfile/doctypes/videos/doctype[@code = current()/ResourceType]/@code" />
					<xsl:if test="$code">
						<xsl:element name="Video">
							<Url>
								<xsl:variable name="hq1_url_date">
									<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
										<xsl:if test="position() eq last()">
											<xsl:for-each select="tokenize(.,'_')">
												<xsl:if test="position() eq 1">
													<xsl:value-of select="." />
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:for-each>
								</xsl:variable>
								<xsl:element name="Item">
								<xsl:element name="Asset">
								<xsl:attribute name="type"><xsl:value-of select="$code" /></xsl:attribute>
									<xsl:value-of
										select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq1_url_date)) , $code, 'global', '' )" />
									</xsl:element>
								</xsl:element>
							</Url>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>

				<!--ObjectAssetList-->
				<xsl:for-each select="$Product/ObjectAssetList/Object/Asset">
					<xsl:variable name="codeObj"
						select="$doctypesfile/doctypes/videos/doctype[@code = current()/ResourceType]/@code" />
					<xsl:variable name="PublicResourceIdentifierObj" select="current()/PublicResourceIdentifier" />
					<xsl:if test="$codeObj != ''">
						<xsl:if test="$PublicResourceIdentifierObj != ''">
							<xsl:element name="Video">
								<xsl:element name="Url">
									<xsl:variable name="hq1_url_date">
										<xsl:for-each select="tokenize(./InternalResourceIdentifier,'/')">
											<xsl:if test="position() eq last()">
												<xsl:for-each select="tokenize(.,'_')">
													<xsl:if test="position() eq 1">
														<xsl:value-of select="." />
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<xsl:element name="Item">
									<xsl:element name="Asset">
							<xsl:attribute name="type"><xsl:value-of select="$codeObj" /></xsl:attribute>
										<xsl:value-of
										select="asset-f:buildScene7Url('http://images.philips.com/is/content/PhilipsConsumer/', concat('CCR',upper-case($hq1_url_date)) , $codeObj, 'global', '' )" />
									</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</Videos>
			<xsl:for-each select="$Product/AssetList">
					<xsl:for-each select="./Asset">
						<xsl:if test = "./ResourceType = 'PSS' ">
							<xsl:element name="PdfProductDataSheet">
								<xsl:element name="Asset">
									<xsl:attribute name="type">PSS</xsl:attribute>
									<xsl:value-of select="./PublicResourceIdentifier"/>
								</xsl:element>
							</xsl:element> 
						</xsl:if>
					</xsl:for-each>
			</xsl:for-each>
			
			<xsl:for-each select="$Product/AssetList">
					<xsl:for-each select="./Asset">
						<xsl:if test = "./ResourceType = 'DFU' ">
							<xsl:element name="PdfUserManual">
							<xsl:element name="Asset">
							<xsl:attribute name="type">DFU</xsl:attribute>
								<xsl:value-of select="./PublicResourceIdentifier"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
			 </xsl:for-each>

			<xsl:for-each select="$Product/AssetList">
					<xsl:for-each select="./Asset">
						<xsl:if test = "./ResourceType = 'QSG' ">
							<xsl:element name="PdfQuickStartGuide">
							<xsl:element name="Asset">
							<xsl:attribute name="type">QSG</xsl:attribute>
								<xsl:value-of select="./PublicResourceIdentifier"/>
							</xsl:element>	
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
			 </xsl:for-each>
			
			
			<PdfMsds/>
			<WarrantyCard/>

			<xsl:for-each select="$Product/AssetList">
					<xsl:for-each select="./Asset">
						<xsl:if test = "./ResourceType = 'IMG' ">
							<xsl:element name="InstallationGuide">
							<xsl:element name="Asset">
							<xsl:attribute name="type">IMG</xsl:attribute>
								<xsl:value-of select="./PublicResourceIdentifier"/>
							</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
			 </xsl:for-each>

			<xsl:for-each select="$Product/AssetList">
					<xsl:for-each select="./Asset">
						<xsl:if test = "./ResourceType = 'PBR' ">
							<xsl:element name="ProductBrochures">
							<xsl:element name="Asset">
							<xsl:attribute name="type">PBR</xsl:attribute>
								<xsl:value-of select="./PublicResourceIdentifier"/>
							</xsl:element>	
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
			 </xsl:for-each>

			<xsl:element name="ProductUrl">
			<xsl:element name="Asset">
							<xsl:attribute name="type">ProductUrl</xsl:attribute>
				<xsl:value-of select="asset-f:buildProductDetailPageUrl(., $locale, $system, $catalogtype, $domains )"/>
			</xsl:element>	
			</xsl:element>

		<!-- Not available in pikachu PMT -->

		<AccessoriesPartNumbers>
			<PartNumber/>
		</AccessoriesPartNumbers>

		
		<MainProductsPartNumbers>
				<xsl:for-each select="Product/ProductRefs/ProductReference">
					<xsl:if test = "./@ProductReferenceType = 'Performer' ">   
						<xsl:element name="PartNumber">
								<xsl:value-of select="./CTN"/>
						</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</MainProductsPartNumbers>

		
		<MainProductsModels>
				<xsl:for-each select="Product/ProductRefs/ProductReference">
					<xsl:if test = "./@ProductReferenceType = 'Performer' ">   
						<xsl:element name="Model">
								<xsl:value-of select="./CTN"/>
						</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</MainProductsModels>


			<xsl:for-each select = "$Product/CSChapter">
				<AttributeGroup>
					<xsl:element name="Name">
						<xsl:value-of select="./CSChapterName"/>
					</xsl:element>
					<xsl:element name="Code">
						<xsl:value-of select="./CSChapterCode"/>
					</xsl:element>
					<xsl:for-each select = "./CSItem">
						<xsl:variable name="CSItemName" select="./CSItemName" />
						<xsl:variable name="CSItemCode" select="./CSItemCode" />
						<xsl:for-each select = "./CSValue">
							<Attribute>
								<xsl:element name="Name">
									<xsl:value-of select="$CSItemName"/>
								</xsl:element>
								<xsl:element name="Code">
									<xsl:value-of select="$CSItemCode"/>
								</xsl:element>
								<xsl:element name="Value">
									<xsl:value-of select="./CSValueName"/>
								</xsl:element>
							</Attribute>
						</xsl:for-each>	
					</xsl:for-each>
				</AttributeGroup>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
