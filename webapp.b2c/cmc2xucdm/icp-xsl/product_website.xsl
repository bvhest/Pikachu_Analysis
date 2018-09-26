<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="product_generic.xsl"/>
	
	<xsl:template name="headers-product-website">
		<xsl:comment>Product website headers</xsl:comment>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_website.css" />

		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/global.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/internet.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-crsc}styles/components.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/ce-styles_v1.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/pce_gmm.css" />
		<link rel="stylesheet" type="text/css" href="{$website-resources-assets}css/overrides/overrides_global.css" />

		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_website_print.css" media="print"/>
				<xsl:comment>[if IE]&gt;
					<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/product/product_website_print_ie.css" media="print"/&gt;</xsl:text>
				&lt;![endif]</xsl:comment>
		<script type="text/javascript" src="{$icp-host}js/product/product_website.js"></script>
	</xsl:template>
	
	<xsl:template match="Products" mode="product-website">
		<div id="icp_view_website" class="icp_view">
			<div id="icp_content_website" class="icp_content">
				<xsl:apply-templates select="Product[position() &lt;= $max-items]" mode="l-prd-web"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="Product" mode="l-prd-web">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:variable name="ctn-norm" select="translate(CTN, '/', '_')"/>
		<div class="icp_container {$locale-lc} {{id:'{$ctn}'}}" id="{$ctn-norm}_container_website">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			<div id="ipnContainer">
				<div id="p-body-wrapper">
					<div class="p-clearfix" id="p-body-innerwrapper">
						<div id="p-body-content">
							<div id="grid-1col-noPadding">
								<div class="p-clearfix" id="p-product-summary">
									<table id="p-product-summary-1">
										<tbody><tr>
											<td class="p-definition">
												<h1 class="sIFR-ignore pdetail">
													<span class="name"><xsl:call-template name="display-text">
														<xsl:with-param name="text-node" select="NamingString/Descriptor/DescriptorName"/>
													</xsl:call-template></span><br/>
													<span class="ctn"><xsl:call-template name="display-text">
															<xsl:with-param name="text-node" select="NamingString/VersionString"/>
														</xsl:call-template><span class="dtn"><xsl:value-of select="DTN"/></span>
													</span>
												</h1>
											</td>
										</tr></tbody>
									</table>

									<table id="p-product-summary-2">
										<tbody><tr>
											<td class="p-rrp">
											</td>
											<td class="p-buy">
												<table class="p-button-action" id="buy">
													<tbody><tr><td><div>[Buy]</div></td></tr></tbody>
												</table>
											</td>
										</tr></tbody>
									</table>
								</div>

								<div id="pce_wrap_tab_productdetails">
									<ul class="icp_tab_pce_productdetails" id="tab_pce_productdetails">
										<li class="current icp_tab_overview" id="tab_overview">
											<a href="javascript: void(0)">[Overview]</a>
											<div class="rightImg"/>
										</li>
										<li class="icp_tab_features" id="tab_features">
											<div class="leftImg"/>
											<a href="javascript: void(0)">[Features]</a>
											<div class="rightImg"/>
										</li>
										<li class="icp_tab_specs" id="tab_specs">
											<div class="leftImg"/>
											<a href="javascript: void(0)">[Specifications]</a>
											<div class="rightImg"/>
										</li>
										<li id="support">
											<a href="javascript:void(0)">[Support]</a>
										</li>
									</ul>
								</div>

								<div class="icp_tabscontent" id="tabscontent">
									<div class="clearfix icp_tab_overview_content" id="tab_overview_content">
										<div class="clearfix" id="cmoimg">
											<div style="width:430px; height:430px; padding-left:45px; vertical-align: middle;" class="icp_main_prd_photo" id="mainPhoto_website_{translate(CTN,'/','_')}">
												<xsl:call-template name="product-photo">
													<xsl:with-param name="product" select="."/>
													<xsl:with-param name="width" select="430"/>
													<xsl:with-param name="height" select="430"/>
													<xsl:with-param name="class" select="'imgTrans'"/>
												</xsl:call-template>
											</div>
										</div>

										<div class="clearfix" id="cmodescription">
											<dl>
												<dt/>
												<h2 class="sIFR-ignore pce_pdetail"><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="WOW"/></xsl:call-template></h2>
												<xsl:if test="SubWOW">
													<dd>
														<h3 class="sIFR-ignore pdetail_subtitle"><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="SubWOW"/></xsl:call-template></h3>
													</dd>
												</xsl:if>
												<dd><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="MarketingTextHeader"/></xsl:call-template></dd>
											</dl>
											<div class="p-clearfix" id="p-cmobuttons">
												<xsl:apply-templates select="NamingString/Concept[ConceptNameUsed = 1]">
													<xsl:with-param name="ctn" select="$ctn"/>
												</xsl:apply-templates>
												<xsl:apply-templates select="NamingString/Family[FamilyNameUsed = 1]">
													<xsl:with-param name="ctn" select="$ctn"/>
												</xsl:apply-templates>
											</div>
										</div>
										<table id="p-tab-productconcept">
											<tbody><tr>
												<!-- 360 view -->
												<td class="col1">
													<xsl:variable name="assets360" select="Assets/Asset[@type='P3D' or @type='PRV']"/>
													<xsl:if test="$assets360">
														<xsl:variable name="class">
															<xsl:choose>
																<xsl:when test="$assets360[@type='P3D']">
																	<!-- Scene7 viewer -->
																	<xsl:text>threeSixtyView</xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<!-- Legacy SWF spinner -->
																	<xsl:text>threeSixtyView legacy</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<table class="{$class}">
														<tbody>
															<tr>
																<td class="icon"/>
																<td class="link">360</td>
															</tr>
														</tbody>
														</table>														
													</xsl:if>
												</td>
												<!-- carousel view -->
												<td class="col2">
													<div class="imgGallery icp_carousel" id="carouselViewer_website_{$ctn-norm}">&#160;</div>
												</td>
												<!-- video view -->
												<td class="col3">
													<xsl:variable name="movie-type">
														<xsl:choose>
															<xsl:when test="Assets/Asset[@type='PRM']">PRM</xsl:when>
															<xsl:when test="Assets/Asset[@type='PRD']">PRD</xsl:when>
														</xsl:choose>
													</xsl:variable>
													<xsl:if test="$movie-type != ''">
														<xsl:variable name="movie" select="Assets/Asset[@type=$movie-type]"/>
														<xsl:variable name="lang-code">
															<xsl:call-template name="locale-to-languagecode">
																<xsl:with-param name="locale" select="$movie/@locale"/>
															</xsl:call-template>
														</xsl:variable>
														<table class="movies movieButton {{movieData: {{id: '{$ctn}', objectType: 'product', assetType: '{$movie-type}', locale: '{$movie/@locale}', languageCode: '{$lang-code}'}}}}">
														<tbody>
															<tr>
																<td class="icon"/>
																<td class="link">Video</td>
															</tr>
														</tbody>
														</table>														
													</xsl:if>
												</td>
											</tr></tbody>
										</table>
										<div class="p-clearfix icp_p-features" id="p-features">
											<xsl:variable name="features-with-image"
													select="KeyBenefitArea/Feature[key('asset-by-code',concat($ctn,FeatureCode))]"/>
											<!-- The old way of getting feature images and logos -->
											<!--xsl:variable name="features-with-image-fallback"
													select="KeyBenefitArea/Feature[../../FeatureLogo/FeatureCode=FeatureCode or ../../FeatureImage/FeatureCode=FeatureCode][position() &lt; 5]"/-->
											<xsl:choose>
												<xsl:when test="count($features-with-image) = 0 or count($features-with-image) &gt;= 4">
													<div class="p-feature-item-cols-header p-clearfix">
														<xsl:call-template name="l-prd-web-features-tab-overview">
															<xsl:with-param name="kba-set" select="KeyBenefitArea"/>
															<xsl:with-param name="max">4</xsl:with-param>
															<xsl:with-param name="mode">l-prd-web-features-tab-overview-col-header</xsl:with-param>
															<xsl:with-param name="with-image" select="count($features-with-image) &gt;= 4"/>
															<xsl:with-param name="ctn" select="$ctn"/>
														</xsl:call-template>
													</div>
													<xsl:call-template name="l-prd-web-features-tab-overview">
														<xsl:with-param name="kba-set" select="KeyBenefitArea"/>
														<xsl:with-param name="max">4</xsl:with-param>
														<xsl:with-param name="mode">l-prd-web-features-tab-overview-col-body</xsl:with-param>
														<xsl:with-param name="with-image" select="count($features-with-image) &gt;= 4"/>
														<xsl:with-param name="ctn" select="$ctn"/>
													</xsl:call-template>
													<!--
													<div class="p-feature-item-cols-header p-clearfix">
														<xsl:apply-templates mode="l-prd-web-tab-overview-features-header" select="$features-with-image[position() &lt; 5]"/>
													</div>
													<xsl:apply-templates mode="l-prd-web-tab-overview-features" select="$features-with-image[position() &lt; 5]">
														<xsl:with-param name="ctn" select="$ctn-norm"/>
													</xsl:apply-templates>
													-->
												</xsl:when>
												<xsl:otherwise> <!-- 1, 2 or 3 features with images => "2x2" view -->
													<xsl:call-template name="l-prd-web-features-tab-overview">
														<xsl:with-param name="kba-set" select="KeyBenefitArea"/>
														<xsl:with-param name="max">4</xsl:with-param>
														<xsl:with-param name="mode">l-prd-web-features-tab-overview-table</xsl:with-param>
														<xsl:with-param name="with-image" select="true()"/>
														<xsl:with-param name="ctn" select="$ctn"/>
													</xsl:call-template>
													<!-- Add extra features without image to get the total of four features -->
													<xsl:call-template name="l-prd-web-features-tab-overview">
														<xsl:with-param name="kba-set" select="KeyBenefitArea"/>
														<xsl:with-param name="max" select="4"/>
														<xsl:with-param name="count" select="count($features-with-image)"/>
														<xsl:with-param name="mode">l-prd-web-features-tab-overview-table</xsl:with-param>
														<xsl:with-param name="with-image" select="false()"/>
														<xsl:with-param name="ctn" select="$ctn"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</div>
										
										<xsl:apply-templates select="descendant::Disclaimers[Disclaimer]|(descendant::Disclaimer[DisclaimerName])[1]" mode="l-prd-web-overview"/>
									</div>

									<div class="clearfix icp_tab_features_content icp_hidden" id="tab_features_content">
										<div class="p-spec_print"><a href="javascript:void(0)">[Print this page]</a></div>
										<dl class="pce_features">
											<dt/>
											<h2 class="p-heading">[Features]</h2>
											<dd class="clearfix">
												<xsl:apply-templates mode="l-prd-web-tab-features" select="KeyBenefitArea">
													<xsl:with-param name="ctn" select="$ctn"/>
												</xsl:apply-templates>
											</dd>
										</dl>
									</div>

									<div class="clearfix icp_tab_specs_content icp_hidden" id="tab_specs_content">
										<div class="p-spec_print"><a href="javascript:void(0)">[Print this page]</a></div>
										<dl class="pce_specs">
											<dt/><h2 class="p-heading">[Specifications]</h2>
											<dd class="clearfix">
												<xsl:apply-templates mode="l-prd-web-tab-specs" select="CSChapter"/>
											</dd>
										</dl>

										<!--script type="text/javascript">
										<![CDATA[
										//function changeGalleryImage(newImage) {
										//	$("#mainImage").css("src", "newImage");
										//}
										]]>
										</script-->
									</div>
								</div>
								
								<xsl:comment>
									<div class="p-clearfix" id="p-bottom">
										<div class="downloads2 downloaditemSeparator">
											<div class="downloadtext">
												<div class="header">[Downloads]</div>
												<div class="body">[Download extra information on this product]</div>
											</div>
											<div class="downloadbtn">
												<table cellspacing="0" class="p-button">
												<tbody><tr>
													<td id="btndownload">
														<div class="text">[See all]</div>
													</td>
												</tr>
												</tbody></table>
											</div>
										</div>
										<div class="p-clearfix" id="pce_buyProduct">
											<!--<xsl:call-template name="display-image">
												<xsl:with-param name="id" select="$ctn"/>
												<xsl:with-param name="doc-type" select="'RTS'"/>
												<xsl:with-param name="width" select="'50'"/>
												<xsl:with-param name="height" select="'50'"/>
												<xsl:with-param name="title-text" select="$ctn"/>
												<xsl:with-param name="alt-text" select="$ctn"/>
											</xsl:call-template-->
											<div class="detail"><span>[Buy this product]</span><br/>
												[Visit one of our recommended stores]
											</div>
											<div id="buy2" class="buybtn2">
												<table class="p-button-action"><tbody><tr><td><div>[Buy]</div></td></tr></tbody></table>
											</div>

											<script type="text/javascript">
											$(document).ready(function(){
												$(".buybtn2").show()
											});
											</script>
										</div>
									</div>
								</xsl:comment>

								<div id="popuplyr2" class="popuplayer2"/>
							</div>
						</div>
					</div>
					<div id="p-body-bottomwrapper"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!--
		Overview tab
	-->
	<xsl:template match="Concept">
		<xsl:param name="ctn"/>
		<xsl:variable name="logo" select="key('asset-by-code',concat($ctn,ConceptCode))"/>
		<xsl:if test="$logo">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="ConceptCode"/>
				<xsl:with-param name="doc-type" select="'CLL'"/>
				<xsl:with-param name="width" select="100"/>
				<xsl:with-param name="class" select="'concept_logo'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Family">
		<xsl:param name="ctn"/>
		<xsl:variable name="logo" select="key('asset-by-code',concat($ctn,FamilyCode))"/>
		<xsl:if test="$logo">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="FamilyCode"/>
				<xsl:with-param name="doc-type" select="'CLL'"/>
				<xsl:with-param name="width" select="100"/>
				<xsl:with-param name="class" select="'family_logo'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="KeyBenefitArea/Feature" mode="l-prd-web-features-tab-overview-col-header">
		<div class="p-header"><h2><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="../KeyBenefitAreaName"/></xsl:call-template></h2></div>
	</xsl:template>

	<xsl:template match="KeyBenefitArea/Feature" mode="l-prd-web-features-tab-overview-col-body">
		<xsl:param name="ctn">99999999/00</xsl:param>
		
		<xsl:variable name="id">
			<xsl:call-template name="KBA-Feature-ID">
				<xsl:with-param name="feature" select="."/>
				<xsl:with-param name="ctn" select="translate($ctn,'/','_')"/>
			</xsl:call-template>
		</xsl:variable>
		<div class="p-feature-item-cols">
			<xsl:if test="key('asset-by-code',concat($ctn,FeatureCode))">
				<div class="p-img-wrapper">
					<xsl:call-template name="feature-image">
						<xsl:with-param name="feature" select="."/>
						<xsl:with-param name="width" select="210"/>
						<xsl:with-param name="height" select="120"/>
						<xsl:with-param name="id-prefix" select="'fio'"/>
						<xsl:with-param name="class" select="'p-features-img'"/>
					</xsl:call-template>
				</div>
			</xsl:if>
			<p class="p-content"><xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="FeatureLongDescription"/></xsl:call-template></p>
			<p class="p-view-more"><a href="javascript:void(0)" class="p-feature-link" id="{concat('txt',$id)}">[More information]</a></p>
		</div>
	</xsl:template>
	
	<!-- 2x2 matrix of features. If there is an image it positioned to the right of the feature header/description -->
	<xsl:template match="KeyBenefitArea/Feature" mode="l-prd-web-features-tab-overview-table">
		<xsl:param name="ctn">99999999/00</xsl:param>
		<xsl:param name="pos" select="1"/>
		
		<xsl:variable name="id">
			<xsl:call-template name="KBA-Feature-ID">
				<xsl:with-param name="feature" select="."/>
				<xsl:with-param name="ctn" select="translate($ctn,'/','_')"/>
			</xsl:call-template>
		</xsl:variable>
		<div class="p-feature-item-rows">
			<div class="p-msg-wrapper">
				<p class="p-header"><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="../KeyBenefitAreaName"/></xsl:call-template></p>
				<p class="p-content"><xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="FeatureLongDescription"/></xsl:call-template></p>
				<p class="p-view-more"><a href="javascript:void(0)" class="p-feature-link" id="{concat('txt_',$id)}">[More information]</a></p>
			</div>
			<div class="p-img-wrapper">
        <xsl:if test="key('asset-by-code', concat($ctn, FeatureCode))">
          <xsl:call-template name="feature-image">
            <xsl:with-param name="feature" select="."/>
            <xsl:with-param name="id-prefix" select="'fio'"/>
            <xsl:with-param name="width" select="209"/>
            <xsl:with-param name="height" select="119"/>
            <xsl:with-param name="class" select="'p-features-img'"/>
          </xsl:call-template>
        </xsl:if>
			</div>
		</div>
		<xsl:if test="$pos mod 2 = 0">
			<br clear="both"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Disclaimers|Disclaimer[DisclaimerName]" mode="l-prd-web-overview">
		<div class="disclaimers">
			<ul>
				<xsl:choose>
					<xsl:when test="Disclaimer">
						<!-- xUCDM 1.1 -->
						<xsl:apply-templates select="Disclaimer" mode="l-prd-web-overview-1_1">
							<xsl:sort select="@rank" data-type="number"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="DisclaimerName">
						<!-- xUCDM 1.0.7 -->
						<xsl:apply-templates select=".|following-sibling::Disclaimer" mode="l-prd-web-overview-1_0_7"/>
					</xsl:when>
				</xsl:choose>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="Disclaimer" mode="l-prd-web-overview-1_1">
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="DisclaimerText"/>
			</xsl:call-template>
		</li>
	</xsl:template>
	
	<xsl:template match="Disclaimer" mode="l-prd-web-overview-1_0_7">
		<li>
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="DisclaimerName"/>
			</xsl:call-template>
		</li>
	</xsl:template>
	
	<!--
		Features tab
	-->
	<xsl:template match="KeyBenefitArea" mode="l-prd-web-tab-features">
		<xsl:param name="ctn">99999999/00</xsl:param>
		<xsl:variable name="kba-id">
			<xsl:call-template name="KBA-ID">
				<xsl:with-param name="kba" select="."/>
				<xsl:with-param name="ctn" select="translate($ctn,'/','_')"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="table-class">
			<xsl:choose>
				<xsl:when test="position() = 1">pce_featureTable</xsl:when>
				<xsl:otherwise>hidden</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="a-class">
			<xsl:choose>
				<xsl:when test="position() = 1">open</xsl:when>
				<xsl:otherwise>close</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<table id="{$kba-id}" class="{$table-class}">
			<tbody>
				<tr class="title">
					<td colspan="2"><a onclick="javascript:showSpecFeature(this)" class="featureTable_pce {$a-class}" href="javascript:void(0)"><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="KeyBenefitAreaName"/>
					</xsl:call-template></a></td>
				</tr>
				<xsl:for-each select="Feature">
					<xsl:variable name="desc" select="FeatureLongDescription"/>
					<tr class="featureRow">
						<td class="featureimg">
              <xsl:if test="key('asset-by-code', concat($ctn, FeatureCode))">
                <xsl:call-template name="feature-image">
                  <xsl:with-param name="feature" select="."/>
                  <xsl:with-param name="id-prefix" select="'fif'"/>
                  <xsl:with-param name="width" select="208"/>
                  <xsl:with-param name="height" select="119"/>
                  <xsl:with-param name="enable-movie" select="true()"/>
                </xsl:call-template>
              </xsl:if>
						</td>
						<td class="featureInfo">
							<h3 class="descr"><xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="$desc"/></xsl:call-template></h3>
							<p class="gloss"><xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="FeatureGlossary"/></xsl:call-template></p>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<!--
		Specifications tab
	-->
	<xsl:template match="CSChapter" mode="l-prd-web-tab-specs">
		<xsl:param name="ctn">99999999_00</xsl:param>
		<xsl:variable name="table-class">
			<xsl:choose>
				<xsl:when test="position() = 1">pce_featureTable</xsl:when>
				<xsl:otherwise>hidden</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="a-class">
			<xsl:choose>
				<xsl:when test="position() = 1">open</xsl:when>
				<xsl:otherwise>close</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<table class="{$table-class}">
			<tbody>
				<tr class="title">
					<td colspan="2">
						<a onclick="javascript:showSpecFeature(this)" class="featureTable_pce {$a-class}" href="javascript:void(0)"><xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="CSChapterName"/>
						</xsl:call-template></a>
					</td>
				</tr>
				<xsl:for-each select="CSItem">
					<xsl:variable name="row-class">
						<xsl:choose>
							<xsl:when test="position() mod 2 = 1">lg</xsl:when>
							<xsl:otherwise>dg</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr class="{$row-class}">
						<td class="key"><xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="CSItemName"/>
							</xsl:call-template></td>
						<td class="value"><xsl:call-template name="display-csitem-values">
							<xsl:with-param name="csitem" select="."/>
							<xsl:with-param name="unit-of-measure-type" select="'symbol'"/>
						</xsl:call-template></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
	<!--
		Process KBA Features, taking one feature of every KBA before returning to the first KBA
		to get the next feature. E.g. with the following KBA's
		
		KBA 1
			Feature 1a
			Feature 1b
		KBA 2
			Feature 2a
			Feature 2b
			Feature 2c
		KBA 3
			Feature 3a
		
		The Features are process in the following order: 1a, 2a, 3a, 1b, 2b, 2c.
		
		Parameters:
			kba-set    The KBA's to process.
			pos        Starting position. Usually one should not specify this.
			count      Internal count to check the maximum.
			max        The maximum number of features to process.
			mode       Specifies what to do with each feature.
			with-image empty: process all features
			           true(): process only features that have an asset in the Asset list
								 false(): process only images that do not have an asset in the Asset list.
		
		This is a recursive process.
	-->
	<xsl:template name="l-prd-web-features-tab-overview">
		<xsl:param name="kba-set"/>
		<xsl:param name="pos"><xsl:value-of select="number(1)"/></xsl:param>
		<xsl:param name="count">0</xsl:param>
		<xsl:param name="max">999</xsl:param>
		<xsl:param name="mode">unspecified</xsl:param>
		<xsl:param name="with-image"/>
		<xsl:param name="ctn"/>
		<!--div style="display: none">
			<p>ctn = <xsl:value-of select="$ctn"/></p>
			<p>with-image = <xsl:value-of select="string($with-image)"/></p>
			<p>max = <xsl:value-of select="string($max)"/></p>
			<p>count = <xsl:value-of select="string($count)"/></p>
			<p>pos = <xsl:value-of select="string($pos)"/></p>
			<p>key = <xsl:for-each select="$kba-set/Feature[position() = $pos]"><xsl:value-of select="key('asset-by-code',concat($ctn,FeatureCode))"/>,</xsl:for-each></p>
		</div-->
		<xsl:variable name="features" select="($kba-set/Feature[position() = $pos][string($with-image) = '' or key('asset-by-code',concat($ctn,FeatureCode))=$with-image])[position()+$count &lt;= $max]"/>
		<xsl:for-each select="$features">
			<xsl:choose>
				<xsl:when test="$mode = 'l-prd-web-features-tab-overview-col-header'">
					<xsl:apply-templates select="." mode="l-prd-web-features-tab-overview-col-header">
						<xsl:with-param name="ctn" select="$ctn"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$mode = 'l-prd-web-features-tab-overview-col-body'">
					<xsl:apply-templates select="." mode="l-prd-web-features-tab-overview-col-body">
						<xsl:with-param name="ctn" select="$ctn"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$mode = 'l-prd-web-features-tab-overview-table'">
					<xsl:apply-templates select="." mode="l-prd-web-features-tab-overview-table">
						<xsl:with-param name="ctn" select="$ctn"/>
						<xsl:with-param name="pos" select="position()+$count"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<div style="color: red;">
						<p class="p-header"><xsl:value-of select="../KeyBenefitAreaName"/></p>
						<p>Unknown mode (<xsl:value-of select="$mode"/>) for template <i>l-prd-web-features-tab-overview</i> in product-website.xsl</p>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="count($features)+$count &lt; $max and $kba-set/Feature[position() = $pos+1]">
			<xsl:call-template name="l-prd-web-features-tab-overview">
				<xsl:with-param name="kba-set" select="$kba-set"/>
				<xsl:with-param name="pos" select="$pos+1"/>
				<xsl:with-param name="count" select="$count+count($features)"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="mode" select="$mode"/>
				<xsl:with-param name="with-image" select="$with-image"/>
				<xsl:with-param name="ctn" select="$ctn"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
