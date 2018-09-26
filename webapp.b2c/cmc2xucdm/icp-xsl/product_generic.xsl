<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="generic.xsl"/>

	<xsl:param name="website-resources-host"><xsl:value-of select="$icp-host"/></xsl:param>
	<xsl:param name="website-resources-crsc"><xsl:value-of select="concat($website-resources-host,'web/crsc/')"/></xsl:param>
	<xsl:param name="website-resources-assets"><xsl:value-of select="concat($website-resources-host,'web/assets/')"/></xsl:param>
	<xsl:param name="website-resources-drhm"><xsl:value-of select="concat($website-resources-host,'web/drhm/')"/></xsl:param>

	<xsl:variable name="language-codes" select="document('languagecodes.xml')/language-mapping/mapping"/>
	
	<!-- Add product generic HTML head elements here -->
	<xsl:template name="headers-product-generic">
		<!-- Generic product headers -->
		<script type="text/javascript" src="{$website-resources-crsc}scripts/lib_global.js"></script>

		<!--script type="text/javascript" src="{$website-resources-crsc}locale/locale_global"></script-->
		<!--script type="text/javascript" src='{$website-resources-crsc}locale/locale_{$locale-lc}'></script-->
		<!--script type="text/javascript" src="{$website-resources-crsc}scripts/404.js"></script-->
		<!--script type="text/javascript" src="{$website-resources-assets}js/popups.js"></script-->
		<script type="text/javascript" src="{$website-resources-assets}js/global.js"></script>
		<!--script type="text/javascript" src="{$website-resources-assets}js/utf8_fns.js"></script-->
		<script type="text/javascript" src="{$website-resources-assets}js/swfobject.js"></script>
		<!--script type="text/javascript" src="{$website-resources-assets}js/AC_OETags.js"></script-->

		<script type="text/javascript" src="{$icp-host}js/product/product_generic.js"></script>
		<script type="text/javascript" src="{$icp-host}js/product/VideoPlayer.js"></script>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_videoplayer.css" />
		<xsl:comment>[if IE]&gt;
			<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/product/product_videoplayer_ie.css" /&gt;</xsl:text>
		&lt;![endif]</xsl:comment>
	</xsl:template>

	<xsl:template match="/Products" mode="product-index">
		<xsl:if test="count(Product) &gt; 1">
			<div id="icp_index" class="icp_index icp_transparent">
				<div class="icp_title">Index</div>
				<ul>
					<xsl:apply-templates mode="product-index" select="Product[position() &lt;= $max-items]"/>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Product" mode="product-index">
		<li>
			<xsl:variable name="ctn" select="translate(CTN,'/','_')"/>
			<a id="{$ctn}" href="javascript:void(0)"><xsl:value-of select="CTN"/></a>
		</li>
	</xsl:template>
	
	<xsl:template match="MarketingStatus" mode="product-status">
		<!-- Set the status image -->
		<img class="icp_status_img" src="{$icp-host}img/{translate(.,'ABCDEFGHIJKLMONPQRSTUVWXYZ ','abcdefghijklmonpqrstuvwxyz_')}.png"/>
	</xsl:template>
	
	<!--
		Display the full product description.
	-->
	<xsl:template name="display-full-product-descriptor">
		<xsl:param name="product"/>
		<xsl:call-template name="joined-text">
			<xsl:with-param name="nodes" select="NamingString/*[substring(local-name(),1,string-length(local-name())-1) = 'VersionElement']/VersionElementName | NamingString/DescriptorBrandedFeatureString"/>
		</xsl:call-template>
	</xsl:template>
	
	<!--
		Display a product photograph.
		The image type is determined by the available Assets in the Product.
		The prioritization of preferred asset types is:
			For IMS: UWL, _FP, FTP, PWL, RTP, TLP, TRP.
			For GAL: PWL, RTP, TLP, TRP, UWL, _FP, FTP
		
		Parameters:
			product	a Product
	-->
	<xsl:template name="product-photo">
		<xsl:param name="product"/>
		<xsl:param name="doc-type" select="'GAL'"/>
		<xsl:param name="width" select="0"/>
		<xsl:param name="height" select="0"/>
		<xsl:param name="class"/>
		
		<xsl:call-template name="display-image">
			<xsl:with-param name="id" select="$product/CTN"/>
			<xsl:with-param name="doc-type" select="$doc-type"/>
			<xsl:with-param name="width" select="$width"/>
			<xsl:with-param name="height" select="$height"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
	</xsl:template>
	
	<!--
		Display all images that are available for a feature.
	-->
	<xsl:template name="feature-images">
		<xsl:param name="feature"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="class"/>
		<xsl:variable name="product" select="$feature/ancestor::Product"/>

		<xsl:choose>
			<!--xsl:when test="$product/Assets/Asset[@code=$feature/FeatureCode]"-->
			<xsl:when test="key('asset-by-code',concat($product/CTN,$feature/FeatureCode))">
				<!-- Use the Asset list to find feature images; process only one asset per master type -->
				<!--xsl:for-each select="$product/Assets/Asset[@code=$feature/FeatureCode and @extension='jpg'][contains($scene7-types,@type)]"-->
				<xsl:for-each select="key('asset-by-code',concat($product/CTN,$feature/FeatureCode))[contains($scene7-types,@type)]">
					<xsl:call-template name="display-image">
						<xsl:with-param name="id" select="$feature/FeatureCode"/>
						<xsl:with-param name="doc-type" select="@type"/>
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
						<xsl:with-param name="class" select="$class"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Use FeatureImage and FeatureLogo to find images -->
				<xsl:if test="$product/FeatureImage[FeatureCode = $feature/FeatureCode]">
					<xsl:call-template name="display-image">
						<xsl:with-param name="id" select="$feature/FeatureCode"/>
						<xsl:with-param name="doc-type" select="'FIL'"/>
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
						<xsl:with-param name="class" select="$class"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$product/FeatureLogo[FeatureCode = $feature/FeatureCode]">
					<xsl:call-template name="display-image">
						<xsl:with-param name="id" select="$feature/FeatureCode"/>
						<xsl:with-param name="doc-type" select="'FLP'"/>
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
						<xsl:with-param name="class" select="$class"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
		Display an image for a feature.
		
		Parameters:
			feature		a Feature
			doc-type	requested doc type
			width			the image width
			height		the image height
			class			the image class
			enable-movie	if there is a feature movie, display the activation image
	-->
	<xsl:template name="feature-image">
		<xsl:param name="feature"/>
		<xsl:param name="id-prefix"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="class"/>
		<xsl:param name="enable-movie"/>
		<xsl:variable name="img-id">
			<xsl:call-template name="KBA-Feature-ID">
				<xsl:with-param name="feature" select="$feature"/>
			</xsl:call-template>
		</xsl:variable>
		<!--xsl:variable name="assets" select="$feature/ancestor::Product/Assets/Asset[@code=$feature/FeatureCode]"/-->
		<xsl:variable name="assets" select="key('asset-by-code',concat($feature/ancestor::Product/CTN,$feature/FeatureCode))"/>
		<xsl:variable name="movie-assets" select="$assets[@type='FML' or @type='FDF']"/>
		<xsl:variable name="doc-type">
			<xsl:choose>
				<xsl:when test="$enable-movie">
					<xsl:call-template name="feature-image-type-with-movie">
						<xsl:with-param name="feature" select="$feature"/>
						<xsl:with-param name="feature-assets" select="$assets"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="feature-image-type-without-movie">
						<xsl:with-param name="feature" select="$feature"/>
						<xsl:with-param name="feature-assets" select="$assets"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$doc-type != ''">
			<xsl:variable name="movie-available" select="$enable-movie and ($doc-type = 'FMB' or $doc-type = 'FDB')"/>
			
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="$feature/FeatureCode"/>
				<xsl:with-param name="doc-type" select="$doc-type"/>
				<xsl:with-param name="width" select="$width"/>
				<xsl:with-param name="height" select="$height"/>
				<xsl:with-param name="img-id" select="concat($id-prefix, $img-id)"/>
				<xsl:with-param name="class">
					<xsl:choose>
						<xsl:when test="$movie-available">
							<xsl:value-of select="$class"/>
							<xsl:text> movieButton</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$class"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				
				<xsl:with-param name="metadata">
					<xsl:choose>
						<xsl:when test="$movie-available">
							<!--
								Sometimes there is a global as well as a localised asset.
								The localised asset is preferred.
							-->
							<xsl:variable name="movie-locale">
								<xsl:choose>
									<xsl:when test="$movie-assets[@locale!='global']">
										<xsl:value-of select="$movie-assets[@locale!='global']/@locale"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'global'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="movie-lang-code">
								<xsl:call-template name="locale-to-languagecode">
									<xsl:with-param name="locale" select="$movie-locale"/>
								</xsl:call-template>
							</xsl:variable>

							<xsl:value-of select="$class"/>
							<xsl:text>movieData: {id:'</xsl:text>
							<xsl:value-of select="$feature/FeatureCode"/>
							<xsl:text>',objectType:'feature',assetType:'</xsl:text>
							<xsl:value-of select="$movie-assets[@locale=$movie-locale]/@type"/>
							<xsl:text>',locale:'</xsl:text>
							<xsl:value-of select="$movie-locale"/>
							<xsl:text>',languageCode:'</xsl:text>
							<xsl:value-of select="$movie-lang-code"/>
							<xsl:text>'}</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="feature-image-type-with-movie">
		<xsl:param name="feature"/>
		<xsl:param name="feature-assets"/>
		<xsl:choose>
			<xsl:when test="count($feature-assets[@type='FML']) &gt;= 1 and count($feature-assets[@type='FMB']) &gt;= 1">
				<xsl:text>FMB</xsl:text>
			</xsl:when>
			<xsl:when test="count($feature-assets[@type='FDF']) &gt;= 1 and count($feature-assets[@type='FDB']) &gt;= 1">
				<xsl:text>FDB</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="feature-image-type-without-movie">
					<xsl:with-param name="feature" select="$feature"/>
					<xsl:with-param name="feature-assets" select="$feature-assets"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="feature-image-type-without-movie">
		<xsl:param name="feature"/>
		<xsl:param name="feature-assets"/>

		<xsl:choose>
			<xsl:when test="$feature-assets[@type='FIL']">
				<xsl:text>FIL</xsl:text>
			</xsl:when>
			<xsl:when test="$feature-assets[@type='FLP']">
				<xsl:text>FLP</xsl:text>
			</xsl:when>
			<xsl:when test="$feature/ancestor::Product/FeatureImage[FeatureCode=$feature/FeatureCode]">
				<xsl:text>FIL</xsl:text>
			</xsl:when>
			<xsl:when test="$feature/ancestor::Product/FeatureLogo[FeatureCode=$feature/FeatureCode]">
				<xsl:text>FLP</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="KBA-ID">
		<xsl:param name="kba"/>
		<xsl:value-of select="generate-id($kba)"/>
	</xsl:template>

	<xsl:template name="KBA-Feature-ID">
		<xsl:param name="feature"/>
		<xsl:value-of select="generate-id($feature)"/>
	</xsl:template>
</xsl:stylesheet>
