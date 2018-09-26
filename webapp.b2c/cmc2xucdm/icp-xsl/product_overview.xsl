<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="product_generic.xsl"/>
	
	<xsl:template name="headers-product-overview">
		<xsl:comment>Product overview headers</xsl:comment>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_overview.css" />
		<script type="text/javascript" src="{$icp-host}js/product/product_overview.js"></script>
		<xsl:comment>[if IE]&gt;
			<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/product/product_overview_ie.css" /&gt;</xsl:text>
		&lt;![endif]</xsl:comment>
	</xsl:template>
	
	<xsl:template match="Products" mode="product-overview">
		<div id="icp_view_overview" class="icp_view">
			<div id="icp_content_overview" class="icp_content">
				<xsl:apply-templates select="Product[position() &lt;= $max-items]" mode="product-overview"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="Product" mode="product-overview">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:variable name="ctn-norm" select="translate(CTN, '/', '_')"/>
		
		<div class="icp_container {{id:'{$ctn}'}}" id="{$ctn-norm}_container_overview" index="{position() - 1}">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="MarketingStatus" mode="product-status"/>

			<div class="icp_prd_ov_section icp_ov_section">
			 <div>
				<div class="icp_prd_ov_mainimage">
					<div style="width:260px; height:260px;" class="icp_main_prd_photo" id="mainPhoto_overview_{translate(CTN,'/','_')}">
						<xsl:call-template name="product-photo">
							<xsl:with-param name="product" select="."/>
							<xsl:with-param name="width" select="'260'"/>
							<xsl:with-param name="height" select="'260'"/>
						</xsl:call-template>
					</div>
					<br/>
				</div>
				<div class="icp_prd_ov_overview">
					<xsl:apply-templates select="." mode="l-prd-ov"/>
				</div>
			 </div>
			</div>
			
			<div class="icp_prd_ov_features icp_prd_ov_section icp_ov_section">
			 <div class="title">Features</div>
			 <div>
				<xsl:apply-templates select="KeyBenefitArea" mode="l-prd-ov">
					<xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
				</xsl:apply-templates>
			 </div>
			</div>
			
			<div class="icp_prd_ov_featureCompareGroups icp_prd_ov_section icp_ov_section">
			 <div class="title">Feature compare groups</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(FeatureCompareGroups) &gt; 0 and count(FeatureCompareGroups/*) &gt; 0">
						<xsl:apply-templates select="FeatureCompareGroups" mode="l-prd-ov"/>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>

			<div class="icp_prd_ov_specifications icp_prd_ov_section icp_ov_section">
			 <div class="title">Specifications</div>
			 <div>
				<xsl:apply-templates select="CSChapter" mode="l-prd-ov">
					<xsl:sort data-type="number" select="CSChapterRank"/>
				</xsl:apply-templates>
			 </div>
			</div>
			
			<div class="icp_prd_ov_richTexts icp_prd_ov_section icp_ov_section">
			 <div class="title">Rich texts</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(RichTexts) &gt; 0 and count(RichTexts/RichText) &gt; 0">
						<xsl:apply-templates select="RichTexts" mode="l-prd-ov"/>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>
			
			<div class="icp_prd_ov_filters icp_prd_ov_section icp_ov_section">
			 <div class="title">Filters</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(Filters/*) &gt; 0">
						<xsl:apply-templates select="Filters" mode="l-prd-ov"/>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>
			
			<div class="icp_prd_ov_accessoryByPacked icp_prd_ov_section icp_ov_section">
			 <div class="title">Accessories included</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(AccessoryByPacked) &gt; 0">
						<ul>
							<xsl:apply-templates select="AccessoryByPacked" mode="l-prd-ov"/>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>
			
			<div class="icp_prd_ov_enrichments icp_prd_ov_section icp_ov_section">
			 <div class="title">Enrichments</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(NavigationGroup) &gt; 0">
						<xsl:apply-templates select="NavigationGroup" mode="l-prd-ov">
							<xsl:sort data-type="number" select="NavigationGroupRank"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>

			<div class="icp_prd_ov_awards icp_prd_ov_section icp_ov_section">
			 <div class="title">Awards</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(Award) &gt; 0">
						<ul>
							<xsl:apply-templates select="Award" mode="l-prd-ov">
                <xsl:sort data-type="number" select="@AwardType"/>
								<xsl:sort data-type="number" select="AwardRank"/>
							</xsl:apply-templates>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>

			<div class="icp_prd_ov_assets icp_prd_ov_section icp_ov_section">
			 <div class="title">Assets</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(Assets/Asset) &gt; 0">
						<xsl:apply-templates select="Assets/Asset[contains($scene7-types, @type)]" mode="l-prd-ov"/>
						<xsl:apply-templates select="Assets/Asset[@extension='pdf']" mode="l-prd-ov"/>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>

			<div class="icp_prd_ov_accessories icp_prd_ov_section icp_ov_section">
			 <div class="title">Accessories</div>
			 <div>
				<xsl:choose>
					<xsl:when test="count(ProductReference[@ProductReferenceType='Accessory']) &gt; 0">
						<ul>
							<xsl:apply-templates select="ProductReference[@ProductReferenceType='Accessory']" mode="l-prd-ov"/>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>
			
			<!-- Performers are not exported by PFS -->
			<!--
			<div class="icp_prd_ov_performers icp_prd_ov_section icp_ov_section">
				<xsl:choose>
					<xsl:when test="count(ProductReference[@ProductReferenceType='Performer']) &gt; 0">
						<ul>
							<xsl:apply-templates select="ProductReference[@ProductReferenceType='Performer']" mode="l-prd-ov"/>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			-->
			
			<div class="icp_prd_ov_disclaimers icp_prd_ov_section icp_ov_section">
			 <div class="title">Disclaimers</div>
			 <div>
				<xsl:choose>
					<xsl:when test="descendant::Disclaimer">
						<xsl:apply-templates select="Disclaimer" mode="prod_107"/>
						<xsl:apply-templates select="Disclaimers" mode="prod_110"/>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>

			<div class="icp_prd_ov_clusters icp_prd_ov_section icp_ov_section">
			 <div class="title">Clusters</div>
			 <div>
				<xsl:choose>
					<xsl:when test="ProductClusters/ProductCluster">
            <xsl:apply-templates select="ProductClusters/ProductCluster" mode="l-prd-ov">
              <xsl:sort select="@rank" data-type="number"/>
            </xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<p>None specified</p>
					</xsl:otherwise>
				</xsl:choose>
			 </div>
			</div>
    </div>

  </xsl:template>
	
	<xsl:template match="Product" mode="l-prd-ov">
		<h2>
				<xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="CTN"/>
				</xsl:call-template>
		</h2>
		
		<dl>
		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="ProductName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/MasterBrand/BrandName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Partner/PartnerBrand/BrandName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Partner/PartnerBrandType"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Partner/PartnerProductName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Partner/PartnerProductIdentifier"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/BrandString"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Concept/ConceptName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Family/FamilyName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Range/RangeName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/Descriptor/DescriptorName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/VersionElement1/VersionElementName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/VersionElement2/VersionElementName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/VersionElement3/VersionElementName"/>
		</xsl:call-template>

    <xsl:call-template name="display-field">
      <xsl:with-param name="node" select="NamingString/VersionElement4/VersionElementName"/>
    </xsl:call-template>
    
		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/VersionString"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/BrandedFeatureString"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="NamingString/DescriptorBrandedFeatureString"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="SupraFeature/SupraFeatureName"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="ShortDescription"/>
		</xsl:call-template>
		
		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="WOW"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="SubWOW"/>
		</xsl:call-template>

		<xsl:call-template name="display-field">
			<xsl:with-param name="node" select="MarketingTextHeader"/>
		</xsl:call-template>
		</dl>
	</xsl:template>
	
	<xsl:template match="KeyBenefitArea" mode="l-prd-ov">
		<p class="icp_prd_ov_header">
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="KeyBenefitAreaName"/>
			</xsl:call-template>
		</p>
		<ul>
			<xsl:apply-templates select="Feature" mode="l-prd-ov">
				<xsl:sort data-type="number" select="FeatureRank"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>

	<xsl:template match="Feature" mode="l-prd-ov">
		<li>
			<p class="icp_prd_ov_header">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="FeatureLongDescription"/>
				</xsl:call-template>
			</p>
			<div class="icp_prd_ov_featureImages">
        <xsl:if test="key('asset-by-code', concat(../../CTN,FeatureCode))">
          <xsl:call-template name="feature-images">
            <xsl:with-param name="feature" select="."/>
            <xsl:with-param name="doc-type" select="'W'"/>
            <xsl:with-param name="width" select="'70'"/>
          </xsl:call-template>
        </xsl:if>
			</div>
			<dl>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureName"/>
			</xsl:call-template>

			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureLongDescription"/>
			</xsl:call-template>

			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureShortDescription"/>
			</xsl:call-template>

			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureGlossary"/>
			</xsl:call-template>
			
			<!--
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureWhy"/>
			</xsl:call-template>

			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureWhat"/>
			</xsl:call-template>

			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="FeatureHow"/>
			</xsl:call-template>
			-->
			</dl>
		</li>
	</xsl:template>

	<xsl:template match="CSChapter" mode="l-prd-ov">
		<p class="icp_prd_ov_header">
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="CSChapterName"/>
			</xsl:call-template>
		</p>
		<dl>
			<xsl:apply-templates select="CSItem" mode="l-prd-ov">
				<xsl:sort data-type="number" select="CSItemRank"/>
			</xsl:apply-templates>
		</dl>
	</xsl:template>

	<xsl:template match="CSItem" mode="l-prd-ov">
		<dt>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="CSItemName"/>
			</xsl:call-template> 
		</dt>
		<dd>
			<xsl:call-template name="display-csitem-values">
				<xsl:with-param name="csitem" select="."/>
				<xsl:with-param name="unit-of-measure-type" select="'both'"/>
			</xsl:call-template>
		</dd>
	</xsl:template>

	<xsl:template match="Filters" mode="l-prd-ov">
		<xsl:apply-templates select="Purpose" mode="l-prd-ov"/>
	</xsl:template>

	<xsl:template match="Purpose" mode="l-prd-ov">
		<p class="icp_prd_ov_header">
			<xsl:choose>
				<xsl:when test="@type = 'Detail'">Detail Product Features and Specifications</xsl:when>
				<xsl:when test="@type = 'Comparison'">Comparison Product Features and Specifications</xsl:when>
				<xsl:when test="@type = 'Discriminators'">Differentiating Features and Specifications</xsl:when>
				<xsl:otherwise>
					<xsl:text>FilterType: </xsl:text>
					<xsl:value-of select="@type"/>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<ul>
			<xsl:for-each select="Features/Feature">
				<xsl:sort data-type="number" select="@rank"/>
				<xsl:variable name="c" select="@code"/>
				<li>
					<xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="../../../../KeyBenefitArea/Feature[FeatureCode=$c]/FeatureLongDescription"/>
					</xsl:call-template>
				</li>
			</xsl:for-each>
		</ul>
		<ul>
		<xsl:for-each select="CSItems/CSItem">
			<xsl:sort data-type="number" select="@rank"/>
			<xsl:variable name="c" select="@code"/>
			<xsl:variable name="item" select="../../../../CSChapter/CSItem[CSItemCode=$c]"/>
			<li>
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="$item/CSItemName"/>
				</xsl:call-template>
				<xsl:text>:&#160;</xsl:text>
				<xsl:call-template name="display-csitem-values">
					<xsl:with-param name="csitem" select="$item"/>
					<xsl:with-param name="unit-of-measure-type" select="'symbol'"/>
				</xsl:call-template>
			</li>
		</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="RichTexts" mode="l-prd-ov">
		<xsl:apply-templates select="RichText" mode="l-prd-ov"/>
	</xsl:template>

	<xsl:template match="RichText" mode="l-prd-ov">
		<p class="icp_prd_ov_header">
			RichText - <xsl:value-of select="@type"/>
		</p>
		<xsl:apply-templates select="Chapter|Item" mode="l-prd-ov-richtext">
			<xsl:sort data-type="number" select="@rank"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="Chapter" mode="l-prd-ov-richtext">
		<p class="prd_ov_richtext_chapter"><xsl:value-of select="@referenceName"/></p>
		<xsl:apply-templates select="Item" mode="l-prd-ov-richtext">
			<xsl:sort data-type="number" select="@rank"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="Item" mode="l-prd-ov-richtext">
		<dl>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="Head"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="Body"/>
			</xsl:call-template>
			<xsl:apply-templates select="BulletList[node()]" mode="l-prd-ov"/>
		</dl>
	</xsl:template>

	<xsl:template match="BulletList" mode="l-prd-ov">
		<dt>BulletList</dt>
		<dd>
			<ul>
				<xsl:apply-templates select="BulletItem" mode="l-prd-ov">
					<xsl:sort data-type="number" select="@rank"/>
				</xsl:apply-templates>
			</ul>
		</dd>
	</xsl:template>
	
	<xsl:template match="BulletItem" mode="l-prd-ov">
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="Text"/>
			</xsl:call-template>
		</li>
	</xsl:template>

	<xsl:template match="NavigationGroup" mode="l-prd-ov">
		<p class="icp_prd_ov_header">
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="NavigationGroupName"/>
			</xsl:call-template>
		</p>
		<xsl:apply-templates select="NavigationAttribute" mode="l-prd-ov">
			<xsl:sort data-type="number" select="NavigationAttributeRank"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="NavigationAttribute" mode="l-prd-ov">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="NavigationAttributeName"/>
		</xsl:call-template>:&#160; 
		<xsl:apply-templates select="NavigationValue" mode="l-prd-ov">
			<xsl:sort data-type="number" select="NavigationValueRank"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="NavigationValue" mode="l-prd-ov">
		<xsl:call-template name="joined-text">
			<xsl:with-param name="nodes" select="NavigationValueName"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="Award" mode="l-prd-ov">
		<li>
			<p class="icp_prd_ov_header">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="AwardName"/>
				</xsl:call-template>
			</p>
			<dl>
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="@AwardType"/>
				</xsl:call-template>

				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardDate"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardPlace"/>
				</xsl:call-template>

				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardDescription"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardAcknowledgement"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardVerdict"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="TestPros"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="TestCons"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AwardText"/>
				</xsl:call-template>
				
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="Title"/>
				</xsl:call-template>
			</dl>
		</li>
	</xsl:template>

	<xsl:template match="Asset" mode="l-prd-ov">
		<div class="asset">
			<xsl:choose>
				<!-- Movie images -->
				<xsl:when test="@type='FDB' or @type='FMB' or @type='PDB' or @type='PMB'">
					<div class="image">
						<xsl:call-template name="display-image">
							<xsl:with-param name="id" select="translate(@code,'_','/')"/>
							<xsl:with-param name="doc-type" select="@type"/>
							<xsl:with-param name="width" select="50"/>
							<xsl:with-param name="height" select="50"/>
							<xsl:with-param name="index" select="@number"/>
						</xsl:call-template>
					</div>
				</xsl:when>
				<!-- Other images -->
				<xsl:when test="@extension='jpg' or @extension='tif' or @type='GAL' or @type='IMS'">
					<div class="image">
						<xsl:call-template name="display-image">
							<xsl:with-param name="id" select="@code"/>
							<xsl:with-param name="doc-type" select="@type"/>
							<xsl:with-param name="width" select="50"/>
							<xsl:with-param name="height" select="50"/>
							<xsl:with-param name="index" select="@number"/>
						</xsl:call-template>
					</div>
				</xsl:when>
				<!-- Documents -->
				<xsl:when test="@extension = 'pdf'">
					<div class="pdf">
						<a target="_blank">
							<xsl:attribute name="href">
								<xsl:call-template name="p4c-asset-url">
									<xsl:with-param name="doc-type" select="@type"/>
									<xsl:with-param name="id" select="translate(@code,'_','/')"/>
									<xsl:with-param name="laco" select="$language-codes[@locale=current()/@locale]/@code"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:text>View PDF</xsl:text>
						</a>
					</div>
				</xsl:when>
			</xsl:choose>
			<p class="icp_prd_ov_header">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="@description"/>
				</xsl:call-template>
			</p>
			<p class="caption">
				<xsl:value-of select="@code"/><br/>
				<xsl:value-of select="concat(@type,', ',@extension)"/><br/>
				<xsl:value-of select="@lastModified"/><br/>
				<xsl:value-of select="@locale"/>
			</p>
		</div>
	</xsl:template>

	<xsl:template match="ProductReference" mode="l-prd-ov">
		<!--
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="CTN"/>
			</xsl:call-template>
			<xsl:text>:&#160;</xsl:text>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="ProductReferenceRank"/>
			</xsl:call-template>
		</li>
		-->
		<div class="asset">
			<p class="icp_prd_ov_header"><xsl:value-of select="CTN"/></p>
			<div class="image">
				<xsl:call-template name="display-image">
					<xsl:with-param name="id" select="CTN"/>
					<xsl:with-param name="doc-type" select="'GAL'"/>
					<xsl:with-param name="width" select="50"/>
					<xsl:with-param name="height" select="50"/>
				</xsl:call-template>
			</div>
		</div>
		<!-- Add an asset entry for each accessory, so the image loader can load it -->
		<script type="text/javascript">
			icp_asset_index.addAsset("<xsl:value-of select="CTN"/>",{code:"<xsl:value-of select="CTN"/>",type:"RTS",locale:"global",number:"001",description:"",extension:"jpg",width:50,height:50,master:"RFT",url:""});
		</script>
	</xsl:template>	

	<xsl:template match="AccessoryByPacked" mode="l-prd-ov">
		<li>
			<p class="icp_prd_ov_header">
					<xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="AccessoryByPackedName"/>
					</xsl:call-template>
			</p>
			<dl>
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AccessoryByPackedName"/>
				</xsl:call-template>
				<xsl:call-template name="display-field">
					<xsl:with-param name="node" select="AccessoryByPackedReference"/>
				</xsl:call-template>
			</dl>
	</li>
	</xsl:template>

	<xsl:template match="FeatureCompareGroups" mode="l-prd-ov">
		<ul>
			<xsl:apply-templates select="FeatureCompareGroup" mode="l-prd-ov"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="FeatureCompareGroup" mode="l-prd-ov">
		<li>
			<p class="icp_prd_ov_header">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="DisplayName"/>
				</xsl:call-template>
			</p>
			<dl>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="Glossary"/>
			</xsl:call-template>
			</dl>
			
			<span class="icp_prd_ov_label">[Features]</span>
			<xsl:for-each select="Features/Feature">
				<ul>
					<li>
						<xsl:variable name="code" select="@code"/>
						<xsl:value-of select="../../../../KeyBenefitArea/Feature[FeatureCode = $code]/FeatureName"/>
					</li>
				</ul>
			</xsl:for-each>
		</li>
	</xsl:template>
	
	<!-- Display for old style (before 1.07) disclaimer -->
	<xsl:template match="Disclaimer" mode="prod_107">
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="DisclaimerName"/>
			</xsl:call-template>
		</li>
	</xsl:template>
		
	<!-- Display for new style (after 1.10) disclaimer -->
	<xsl:template match="Disclaimers" mode="prod_110">
		<ul>
			<xsl:apply-templates select="Disclaimer" mode="prod_110">
				<xsl:sort data-type="number" select="@rank"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	<xsl:template match="Disclaimer" mode="prod_110">
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="DisclaimerText"/>
			</xsl:call-template>
		</li>
	</xsl:template>

	<xsl:template match="ProductCluster" mode="l-prd-ov">
    <p class="icp_prd_ov_header">
      <xsl:value-of select="@type"/>
    </p>
    <dl>
      <xsl:call-template name="display-field">
        <xsl:with-param name="node" select="@code"/>
      </xsl:call-template>
      <xsl:call-template name="display-field">
        <xsl:with-param name="node" select="@rank"/>
      </xsl:call-template>
      <xsl:call-template name="display-field">
        <xsl:with-param name="node" select="Name"/>
      </xsl:call-template>
      <xsl:call-template name="display-field">
        <xsl:with-param name="node" select="@referenceName"/>
      </xsl:call-template>
    </dl>
	</xsl:template>
  
	<!-- catch all: do nothing -->
	<xsl:template match="*|@*" mode="l-prd-ov"/>

</xsl:stylesheet>

