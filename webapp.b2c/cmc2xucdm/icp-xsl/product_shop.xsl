<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="product_generic.xsl"/>
  
	<xsl:template name="headers-product-shop">
		<xsl:comment>Product shop headers</xsl:comment>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_shop.css" />
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_shop_print.css" media="print"/>

		<link rel="stylesheet" type="text/css" href="{$website-resources-drhm}css/generic.css" />
		<xsl:comment>[if IE]&gt;
		&lt;style type="text/css"&gt;
		#icp_content_shop #dr_purchaseDetails #dr_productName h1 { font-size: 210%; }
		#icp_content_shop #p-body-innerwrapper {width: 986px;}
		#icp_content_shop #dr_ProductDetails #dr_priceBox {height: 450px; width: 200px}
		&lt;/style&gt;
		&lt;![endif]</xsl:comment>
		<xsl:comment>[if IE 6]&gt;
		&lt;style type="text/css"&gt;
		#icp_content_shop #dr_purchaseDetails { margin-left: -22px; }
		&lt;/style&gt;
		&lt;![endif]</xsl:comment>
		<xsl:comment>[if IE 7]&gt;
		&lt;style type="text/css"&gt;
		#icp_content_shop #dr_productTabs .features, #dr_productTabs .included, #dr_productTabs .imageLeft { position: relative; }
		#icp_content_shop #dr_bottomBtns #ul-table { margin: 0px; }
		&lt;/style&gt;
		&lt;![endif]</xsl:comment>
		
		<link rel="stylesheet" type="text/css" href="{$website-resources-drhm}css/drstyle.css" />

		<script type="text/javascript" src="{$website-resources-drhm}js/jquery.dltabs.js"></script>

		<script type="text/javascript" src="{$icp-host}js/product/product_shop.js"></script>
	</xsl:template>

	<xsl:template match="Products" mode="product-shop">
		<div id="icp_view_shop" class="icp_view">
			<div id="icp_content_shop" class="icp_content">
				<xsl:apply-templates select="Product[position() &lt;= $max-items]" mode="l-prd-shop"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="Product" mode="l-prd-shop">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:variable name="ctn-norm" select="translate(CTN, '/', '_')"/>
		<div class="icp_container {{id:'{$ctn}'}}" id="{$ctn-norm}_container_shop">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			
			<div id="main">
				<div id="p-body">
					<div id="p-body-wrapper">
						<div class="p-clearfix" id="p-body-innerwrapper">
							<div id="dr_CategoryProductList" class="dr_Content">
								<div id="breadcrumbs">
									<h1><xsl:call-template name="display-text">
										<xsl:with-param name="text-node" select="ProductName"/>
									</xsl:call-template></h1>
								</div>

								<div class="dr_Content" id="dr_ProductDetails">
									<xsl:apply-templates select="." mode="l-prd-shop-summary"/>
								</div>

								<div class="dr_rightBanner">&#160;</div>
								
								<div id="dr_tabs">
									<div class="tabs">
										<dl id="dr_productTabs" class="dr_productTabs">
											<dt id="dr_tab1Text">[Overview]</dt>
											<dd id="dr_tab1Content">
												<xsl:apply-templates select="(KeyBenefitArea/Feature)[position() &lt; 4]" mode="l-prd-shop-extensive">
													<xsl:with-param name="ctn" select="$ctn"/>
												</xsl:apply-templates>
												
												<div class="divider">
													<hr/>
												</div>
												
												<div class="features">
													<h4>[Features]</h4>
													<ul>
														<xsl:apply-templates select="(KeyBenefitArea/Feature)[position() &gt;= 4]" mode="l-prd-shop-simple"/>
													</ul>
													<br style="clear: both;"/>
												</div>
												
												<xsl:if test="AccessoryByPacked">
													<div class="included">
														<h4>[Included in the box]</h4>
														<ul>
															<xsl:apply-templates select="AccessoryByPacked" mode="l-prd-shop"/>
														</ul>
													</div>
												</xsl:if>
												<br style="clear: both;"/>
												<br style="clear: both;"/>
											</dd>
											<dt id="dr_tab2Text">[Specifications]</dt>
											<dd id="dr_tab2Content">
												<xsl:if test="Assets/Asset[@type='PSS']">
													<ul>
														<p>
															<img width="16" height="16" alt="Productspecifications" title="Productspecifications" src="{$website-resources-drhm}images/pdf.gif"/><a href="{Assets/Asset[@type='PSS']/text()}" target="_blank"><span>Productspecifications</span></a>
														</p>
													</ul>
												</xsl:if>
												<xsl:apply-templates select="CSChapter" mode="l-prd-shop"/>
												<xsl:apply-templates select="descendant::Disclaimers[Disclaimer]|(descendant::Disclaimer[DisclaimerName])[1]" mode="l-prd-shop-spec"/>
											</dd>
										</dl>
									</div>
								</div>
								<br style="clear: left;"/>
								<div id="dr_bottomBtns">
									<ul id="ul-table">
										<li>
											<div class="productTitle"><xsl:call-template name="display-text">
												<xsl:with-param name="text-node" select="ProductName"/>
											</xsl:call-template></div>
										</li>
										<li>
											<div class="productPrice"></div>
										</li>
										<li>
											<div class="dr_buttons"></div>
										</li>
									</ul>
									<br style="clear: both;" />
								</div>
							</div>
						</div>
					</div>
					<div id="p-body-bottomwrapper"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="Product" mode="l-prd-shop-summary">
		<div id="dr_productSummary">
			<div id="dr_thumbnailImage">
				<div style="width:340px; height:340px;" class="icp_main_prd_photo" id="mainPhoto_shop_{translate(CTN,'/','_')}">
					<xsl:call-template name="product-photo">
						<xsl:with-param name="product" select="."/>
						<xsl:with-param name="width" select="340"/>
						<xsl:with-param name="height" select="340"/>
					</xsl:call-template>
				</div>
				<div class="dr_pdThumbnails icp_carousel" id="carouselViewer_shop_{translate(CTN,'/','_')}"></div>
			</div>
			<div id="dr_purchaseDetails">
				<div style="text-align:right; padding:10px 0; height:70px;">
					<xsl:if test="Assets/Asset[@type='BRP']">
						<xsl:call-template name="display-image">
							<xsl:with-param name="id" select="Assets/Asset[@type='BRP']/@code"/>
							<xsl:with-param name="doc-type" select="'BRP'"/>
							<xsl:with-param name="height" select="30"/>
						</xsl:call-template>
					</xsl:if>
				</div>
				<div id="dr_productName">
					<h1><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="ProductName"/>
					</xsl:call-template></h1>
					<h2 class="partNumber"><xsl:value-of select="NamingString/Alphanumeric"/></h2>
				</div>
				<div id="dr_longDescription">
					<div class="wowText"><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="WOW"/>
					</xsl:call-template></div>
					<xsl:if test="SubWOW != ''">
						<div class="subWowText"><xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="SubWOW"/>
						</xsl:call-template></div>
					</xsl:if>
					<p><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="MarketingTextHeader"/>
					</xsl:call-template></p>
					<span id="dr_socialTitle">Share:&#160;</span>
					<span id="dr_socialNetworkLinks">
						<span id="dr_delicious"><img src="{$website-resources-drhm}images/sn_delicious.gif" alt="del.icio.us" title="del.icio.us" border="0"/></span>
						<span id="dr_facebook"><img src="{$website-resources-drhm}images/sn_facebook.gif" alt="Facebook" title="Facebook" border="0"/></span>
						<span id="dr_stumble"><img src="{$website-resources-drhm}images/sn_stumble.gif" alt="StumbleUpon" title="StumbleUpon" border="0"/></span>
						<span id="dr_digg"><img src="{$website-resources-drhm}images/sn_digg.gif" alt="Digg" title="Digg" border="0"/></span>
					</span>
				</div>
			</div>
			<div id="dr_priceBox">Pricing information not available</div>
		</div>
		<br style="clear: both;"/>
	</xsl:template>
	
	<xsl:template match="Feature" mode="l-prd-shop-extensive">
		<xsl:param name="ctn"/>
		<xsl:if test="key('asset-by-code',concat($ctn,FeatureCode))">
			<div class="imageleft">
				<xsl:call-template name="feature-image">
					<xsl:with-param name="feature" select="."/>
					<xsl:with-param name="width" select="'125'"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<h3><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="FeatureLongDescription"/>
		</xsl:call-template></h3>
		<p><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="FeatureGlossary"/>
		</xsl:call-template></p>
		<br clear="left"/>
	</xsl:template>
	
	<xsl:template match="Feature" mode="l-prd-shop-simple">
		<li><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="FeatureName"/>
		</xsl:call-template></li>
	</xsl:template>

	<xsl:template match="AccessoryByPacked" mode="l-prd-shop">
		<li><xsl:value-of select="AccessoryByPackedName"/></li>
	</xsl:template>
	
	<xsl:template match="CSChapter" mode="l-prd-shop">
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th><xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="CSChapterName"/>
					</xsl:call-template></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="CSItem" mode="l-prd-shop">
					<xsl:sort data-type="number" select="CSItemRank"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="CSItem" mode="l-prd-shop">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">even</xsl:when>
				<xsl:otherwise>odd</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="{$class}">
			<td class="attribute"><xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="CSItemName"/>
			</xsl:call-template></td>
			<td class="value"><xsl:call-template name="display-csitem-values">
				<xsl:with-param name="csitem" select="."/>
				<xsl:with-param name="unit-of-measure-type" select="'symbol'"/>
			</xsl:call-template></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Disclaimers|Disclaimer[DisclaimerName]" mode="l-prd-shop-spec">
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>[Disclaimers]</th>
				</tr>
			</thead>
			<tbody>
				<xsl:choose>
					<xsl:when test="Disclaimer">
						<!-- xUCDM 1.1 -->
						<xsl:apply-templates select="Disclaimer" mode="l-prd-shop-spec-1_1">
							<xsl:sort select="@rank" data-type="number"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="DisclaimerName">
						<!-- xUCDM 1.0.7 -->
						<xsl:apply-templates select=".|following-sibling::Disclaimer" mode="l-prd-shop-spec-1_0_7"/>
					</xsl:when>
				</xsl:choose>
			</tbody>
		</table>	
	</xsl:template>
	
	<xsl:template match="Disclaimer" mode="l-prd-shop-spec-1_1">
		<tr>
			<td>
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="DisclaimerText"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Disclaimer" mode="l-prd-shop-spec-1_0_7">
		<tr>
			<td>
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="DisclaimerName"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="*|@*" mode="l-prd-shop">
		<!-- catch all: do nothing -->
	</xsl:template>
	
</xsl:stylesheet>
