<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="product_generic.xsl"/>
  
	<xsl:template name="headers-product-leaflet">
		<xsl:comment>Product leaflet headers</xsl:comment>
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/product/product_leaflet.css" />
		<xsl:comment>[if IE]&gt;
			<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/product/product_leaflet_ie.css" /&gt;</xsl:text>
		&lt;![endif]</xsl:comment>

		<script type="text/javascript" src="{$icp-host}js/jquery/jquery.columnLayout.js"></script>
		<script type="text/javascript" src="{$icp-host}js/product/product_leaflet.js"></script>
	</xsl:template>

  <xsl:template match="Products" mode="product-leaflet">
		<div id="icp_view_leaflet" class="icp_view">
			<div id="icp_content_leaflet" class="icp_content">
				<xsl:apply-templates select="Product[position() &lt;= $max-items]" mode="product-leaflet"/>
			</div>
		</div>
  </xsl:template>
  
	<xsl:template match="Product" mode="product-leaflet">
		<xsl:variable name="ctn" select="CTN"/>
		<xsl:variable name="ctn-norm" select="translate(CTN, '/', '_')"/>
		<div class="icp_container {{id:'{$ctn}'}}" id="{$ctn-norm}_container_leaflet">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			<xsl:variable name="philips-lang-code" select="$language-codes[@locale=$locale]/@code"/>
			<xsl:variable name="leaflet-url">
				<xsl:if test="$system != 'tms' and $system != 'pfs' and Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet']">
					<xsl:choose>
						<!-- Try leaflet for current product's locale -->
						<xsl:when test="Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][@locale=$locale or @language=$philips-lang-code]">
							<!--xsl:value-of select="normalize-space(Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][@locale=$locale or @language=$philips-lang-code]/text())"/-->
							<xsl:variable name="asset" select="Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][@locale=$locale or @language=$philips-lang-code]"/>
							<xsl:call-template name="p4c-asset-url">
								<xsl:with-param name="doc-type" select="$asset/@type"/>
								<xsl:with-param name="id" select="translate($asset/@code,'_','/')"/>
								<xsl:with-param name="laco" select="$philips-lang-code"/>
							</xsl:call-template>
						</xsl:when>
						<!-- Try leaflet for current product's language only (e.g. nl for nl_NL and nl_BE) -->
						<xsl:when test="Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][substring(@locale,1,2)=$lang]">
							<!--xsl:value-of select="normalize-space(Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][substring(@locale,1,2)=$lang]/text())"/-->
							<xsl:variable name="asset" select="Assets/Asset[@code=$ctn or @code=$ctn-norm][@description='Leaflet'][@extension='pdf'][substring(@locale,1,2)=$lang]"/>
							<xsl:call-template name="p4c-asset-url">
								<xsl:with-param name="doc-type" select="$asset/@type"/>
								<xsl:with-param name="id" select="translate($asset/@code,'_','/')"/>
								<xsl:with-param name="laco" select="$philips-lang-code"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$leaflet-url != ''">
					<div class="icp_leaflet_pdf {{src: '{$leaflet-url}'}}"/>
				</xsl:when>
				<xsl:otherwise>
					<div class="leaf_p1 leaf_page">
						<div class="left">
							<div class="mainPhoto">
								<div id="mainPhoto_leaflet_{$ctn-norm}" style="width: 303px;">
									<xsl:call-template name="product-photo">
										<xsl:with-param name="product" select="."/>
										<xsl:with-param name="width" select="404"/>
										<xsl:with-param name="height" select="502"/>
									</xsl:call-template>
								</div>
							</div>
							<div class="mainText">
								<xsl:apply-templates select="WOW" mode="l-prd-leaf"/>
								<xsl:apply-templates select="SubWOW" mode="l-prd-leaf"/>
								<xsl:apply-templates select="MarketingTextHeader" mode="l-prd-leaf"/>
								<div class="features">
									<xsl:apply-templates select="KeyBenefitArea" mode="l-prd-leaf-p1"/>
								</div>
							</div>
						</div>
						<div class="right">
							<xsl:apply-templates select="NamingString" mode="l-prd-leaf-p1"/>
						</div>
					</div>
					
					<div class="leaf_p2 leaf_page">
						<xsl:apply-templates select="NamingString" mode="l-prd-leaf"/>
						<xsl:apply-templates select="CTN" mode="l-prd-leaf"/>
						<br clear="both"/>
						<div class="header">Highlights</div>
						<xsl:call-template name="create-page-items"/>
						
						<div class="highlights" style="display: none;">
							<xsl:apply-templates select="FeatureHighlight" mode="l-prd-leaf"/>
						</div>
						
						<div class="logos">
							<xsl:apply-templates select="Assets/Asset[@type='FLP']" mode="l-prd-leaf"/>
						</div>
					</div>

					<div class="leaf_p3 leaf_page">
						<xsl:apply-templates select="NamingString" mode="l-prd-leaf"/>
						<xsl:apply-templates select="CTN" mode="l-prd-leaf"/>
						<br clear="both"/>
						<div class="header">Specifications</div>
						<xsl:call-template name="create-page-items"/>

						<xsl:apply-templates select="Assets/Asset[@type='RCP']" mode="l-prd-leaf"/>

						<table class="footer">
							<xsl:apply-templates select="Assets/Asset[@type='COP']" mode="l-prd-leaf-p3"/>
							<tr><td class="filler" colspan="3"></td></tr>
							<tr>
								<td class="logo" rowspan="3"></td>
								<td class="info">
									Issue date <xsl:value-of select="CRDate"/><br/>
									Version: <xsl:value-of select="MarketingVersion"/><br/>
								</td>
								<td class="copyright">
									&#169;<xsl:value-of select="ModelYears/ModelYear[position()=last()]"/> Koninklijke Philips Electronics N.V.<br/>
									All Rights reserved.<br/>
								</td>
							</tr>
							<tr>
								<td class="info"></td>
								<td class="copyright">
									Specifications are subject to change without notice.
									Trademarks are the property of Koninklijke Philips Electronics N.V. or their respective owners.<br/>
								</td>
							</tr>
							<tr>
								<td class="info">
									12 NC: <xsl:value-of select="Code12NC"/><br/>
									EAN: <xsl:value-of select="GTIN"/><br/>
								</td>
								<td class="url">www.philips.com</td>
							</tr>
						</table>

						<xsl:apply-templates select="Disclaimers" mode="l-prd-leaf"/>
						
						<div class="specifications" style="display: none;">
							<xsl:apply-templates select="CSChapter" mode="l-prd-leaf"/>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="WOW" mode="l-prd-leaf">
		<div class="wow"><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="."/>
		</xsl:call-template></div>
	</xsl:template>

	<xsl:template match="SubWOW" mode="l-prd-leaf">
		<div class="subWow"><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="."/>
		</xsl:call-template></div>
	</xsl:template>
	
	<xsl:template match="MarketingTextHeader" mode="l-prd-leaf">
		<div class="marketingText"><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="."/>
		</xsl:call-template></div>
	</xsl:template>
	
	<xsl:template match="NamingString" mode="l-prd-leaf-p1">
		<div class="descriptorText">
			<table>
				<tr><td class="name">
					<xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="BrandString"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="Concept">
							<xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="Concept/ConceptName"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:when test="Family">
							<xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="Family/FamilyName"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
						</xsl:when>
					</xsl:choose>
				</td></tr>
				<tr><td class="description">
					<xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="DescriptorBrandedFeatureString"/>
					</xsl:call-template>
				</td></tr>
				<tr><td class="versionInfo">
					<xsl:apply-templates select="VersionElement1" mode="l-prd-leaf-p1"/>
					<div class="version">
						<xsl:apply-templates select="VersionElement2|VersionElement3" mode="l-prd-leaf-p1"/>
					</div>
				</td></tr>
			</table>
		</div>
		
		<xsl:if test="Concept[ConceptNameUsed=1][key('asset-by-code',concat(current()/../CTN,ConceptCode))]">
			<div class="conceptLogo">
				<xsl:call-template name="display-image">
					<xsl:with-param name="id" select="Concept/ConceptCode"/>
					<xsl:with-param name="doc-type" select="'MCP'"/>
					<xsl:with-param name="width" select="164"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		
		<xsl:if test="key('asset-by-code',concat(../CTN,../CTN))[@type='UPL']">
			<div class="productPhoto">
				<xsl:call-template name="display-image">
					<xsl:with-param name="id" select="../CTN"/>
					<xsl:with-param name="doc-type" select="'UPL'"/>
					<xsl:with-param name="width" select="162"/>
					<xsl:with-param name="height" select="162"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		
		<div class="productId">
			<xsl:value-of select="Alphanumeric"/>
		</div>
	</xsl:template>
	
	<xsl:template match="NamingString" mode="l-prd-leaf">
		<div class="descriptor">
			<div class="info">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="DescriptorBrandedFeatureString"/>
				</xsl:call-template>
			</div>
			<div class="versionInfo">
				<xsl:apply-templates select="VersionElement1|VersionElement2|VersionElement3" mode="l-prd-leaf"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="VersionElement1" mode="l-prd-leaf-p1">
		<div class="mainVersion">
			<xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="VersionElementName"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="VersionElement2" mode="l-prd-leaf-p1">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="VersionElementName"/>
		</xsl:call-template>
		<xsl:if test="../VersionElement3">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="VersionElement3" mode="l-prd-leaf-p1">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="VersionElementName"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="CTN" mode="l-prd-leaf">
		<div class="productId"><xsl:value-of select="."/></div>
	</xsl:template>

	<xsl:template match="VersionElement1" mode="l-prd-leaf">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="VersionElementName"/>
		</xsl:call-template>
		<xsl:if test="following-sibling::VersionElement2|following-sibling::VersionElement3">
			<xsl:text>&#160;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="VersionElement2" mode="l-prd-leaf">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="VersionElementName"/>
		</xsl:call-template>
		<xsl:if test="following-sibling::VersionElement3">
			<xsl:text>&#160;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="VersionElement3" mode="l-prd-leaf">
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="VersionElementName"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="KeyBenefitArea" mode="l-prd-leaf-p1">
		<dl>
			<dt><xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="KeyBenefitAreaName"/>
			</xsl:call-template></dt>
			<xsl:apply-templates select="Feature" mode="l-prd-leaf-p1"/>
		</dl>
	</xsl:template>

	<xsl:template match="KeyBenefitArea" mode="l-prd-leaf">
		<xsl:apply-templates select="Feature" mode="l-prd-leaf"/>
	</xsl:template>

	<xsl:template match="Feature" mode="l-prd-leaf-p1">
		<dd>
			<div class="li"><span class="marker">●</span>
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="FeatureLongDescription"/>
				</xsl:call-template>
			</div>
		</dd>
	</xsl:template>

	<xsl:template match="FeatureHighlight" mode="l-prd-leaf">
		<xsl:apply-templates select="../KeyBenefitArea/Feature[FeatureCode=current()/FeatureCode]" mode="l-prd-leaf"/>
	</xsl:template>
	
	<xsl:template match="Feature" mode="l-prd-leaf">
		<div>
			<div class="featureName">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="FeatureName"/>
				</xsl:call-template>
			</div>
			<xsl:if test="ancestor::Product/Assets/Asset[@code=current()/FeatureCode and @type='FIL']">
				<div class="featureImage">
					<xsl:call-template name="feature-image">
						<xsl:with-param name="feature" select="."/>
						<xsl:with-param name="width" select="225"/>
						<xsl:with-param name="height" select="128"/>
					</xsl:call-template>
				</div>
			</xsl:if>
		</div>
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="FeatureGlossary"/>
			<xsl:with-param name="tokenization-chars" select="' '"/>
			<xsl:with-param name="tokenization-class" select="'featureGlossary'"/>
		</xsl:call-template>
		<div class="featureGlossaryEnd"/>
	</xsl:template>
	
	<xsl:template match="CSChapter" mode="l-prd-leaf">
		<div>
			<div class="chapterName">
				<xsl:call-template name="display-text">
					<xsl:with-param name="text-node" select="CSChapterName"/>
				</xsl:call-template>
			</div>
			<xsl:apply-templates select="CSItem[position() &lt;= 1]" mode="l-prd-leaf"/> <!-- Keep at least one item with tyhe header -->
		</div>
		<xsl:apply-templates select="CSItem[position() &gt; 1]" mode="l-prd-leaf"/>
	</xsl:template>

	<xsl:template match="CSItem" mode="l-prd-leaf">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="count(following-sibling::CSItem) = 0">li lilast</xsl:when>
				<xsl:otherwise>li</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{$class}"><span class="marker">●</span><xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="CSItemName"/>
			</xsl:call-template>
			<xsl:text>:&#160;</xsl:text>
			<xsl:call-template name="display-csitem-values">
				<xsl:with-param name="csitem" select="."/>
				<xsl:with-param name="unit-of-measure-type" select="'symbol'"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="Asset[@type='FLP']" mode="l-prd-leaf">
		<xsl:call-template name="display-image">
			<xsl:with-param name="id" select="@code"/>
			<xsl:with-param name="doc-type" select="'FLP'"/>
			<xsl:with-param name="index" select="@number"/>
			<xsl:with-param name="width" select="43"/>
			<xsl:with-param name="class" select="'featureLogo'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="Asset[@type='COP']" mode="l-prd-leaf-p3">
		<tr>
			<td class="connectorDrawing" colspan="3">
				<xsl:call-template name="display-image">
					<xsl:with-param name="id" select="@code"/>
					<xsl:with-param name="doc-type" select="'COP'"/>
					<xsl:with-param name="index" select="@number"/>
					<xsl:with-param name="height" select="126"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="Asset[@type='RCP']" mode="l-prd-leaf">
		<div class="remoteControl">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="@code"/>
				<xsl:with-param name="doc-type" select="'RCP'"/>
				<xsl:with-param name="index" select="@number"/>
				<xsl:with-param name="width" select="108"/>
				<xsl:with-param name="height" select="280"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template match="Disclaimers" mode="l-prd-leaf">
		<div class="disclaimers">
			<xsl:apply-templates select="Disclaimer" mode="l-prd-leaf"/>
		</div>
	</xsl:template>
	
	<xsl:template match="Disclaimer" mode="l-prd-leaf">
		<div class="li"><span class="marker">*</span>
		<xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="DisclaimerText"/>
		</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="create-page-items">
		<div class="column columnleft"/>
		<div class="column columnmiddle"/>
		<div class="column columnright"/>
	</xsl:template>
	
</xsl:stylesheet>
