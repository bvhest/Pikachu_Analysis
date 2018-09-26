<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets.
			It contains the layout for rich text components; dimensional drawing, related products, asseccoires, product details, features, applications ...</description>
	</stylesheet>
	<!-- key benefit -->
	<xsl:template name="KeyBenefitAreas">
		<xsl:if test="KeyBenefitArea">
			<xsl:comment>Key Benefits</xsl:comment>
			<fo:block xsl:use-attribute-sets="keep-together blank-line">
				<!-- render key benefit header -->
				<fo:block xsl:use-attribute-sets="BodyHeader">
					<xsl:call-template name="getStaticText">
						<xsl:with-param name="field">benefits</xsl:with-param>
					</xsl:call-template>
				</fo:block>
				<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
					<!-- apply key benefit area's, sorted by rank -->
					<xsl:apply-templates select="KeyBenefitArea">
						<xsl:sort data-type="number" select="KeyBenefitAreaRank"/>
					</xsl:apply-templates>
				</fo:list-block>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<xsl:template match="KeyBenefitArea">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="BodyText">
					<xsl:text>•</xsl:text>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<!-- apply text or sub list -->
				<xsl:apply-templates select="KeyBenefitAreaName"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="KeyBenefitAreaName">
		<fo:block xsl:use-attribute-sets="BodyText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- feature text -->
	<xsl:template match="RichText[@type = 'FeatureText']">
		<xsl:if test="Item">
			<xsl:comment>Features</xsl:comment>
			<fo:block xsl:use-attribute-sets="keep-together blank-line">
				<!-- render key benefit header -->
				<fo:block xsl:use-attribute-sets="BodyHeader">
					<xsl:call-template name="getStaticText">
						<xsl:with-param name="field">features</xsl:with-param>
					</xsl:call-template>
				</fo:block>
				<!-- see content include -->
				<xsl:apply-templates mode="genericlist" select="Item">
					<xsl:sort data-type="number" select="@rank"/>
				</xsl:apply-templates>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- application text -->
	<xsl:template match="RichText[@type = 'ApplicationText']">
		<xsl:if test="Item">
			<xsl:comment>Application</xsl:comment>
			<fo:block xsl:use-attribute-sets="keep-together blank-line">
				<!-- render key benefit header -->
				<fo:block xsl:use-attribute-sets="BodyHeader">
					<xsl:call-template name="getStaticText">
						<xsl:with-param name="field">application</xsl:with-param>
					</xsl:call-template>
				</fo:block>
				<!-- see content include -->
				<xsl:apply-templates mode="genericlist" select="Item">
					<xsl:sort data-type="number" select="@rank"/>
				</xsl:apply-templates>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- legal text -->
	<xsl:template match="RichText[@type = 'LegalTextEU']">
		<xsl:comment>Legal text</xsl:comment>
		<fo:block-container display-align="after" height="{(28 * $grid-line) + 0.25}mm" width="100%">
			<!-- keep 3 grid-lines distance from shield -->
			<fo:block span="all" xsl:use-attribute-sets="keep-together">
				<xsl:apply-templates mode="legal" select="Item">
					<xsl:sort data-type="number" select="@rank"/>
				</xsl:apply-templates>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="Item" mode="legal">
		<xsl:apply-templates mode="legal" select="Body"/>
	</xsl:template>
	<xsl:template match="Body[not(contains(.,'&#9;'))]" mode="legal">
		<fo:block xsl:use-attribute-sets="LegalText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="Body[contains(.,'&#9;')]" mode="legal">
		<fo:block>
			<fo:list-block provisional-distance-between-starts="5mm" provisional-label-separation="1mm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block xsl:use-attribute-sets="LegalText">
							<xsl:value-of select="normalize-space(tokenize(text(),'&#9;')[1])"/>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="LegalText">
							<xsl:for-each select="tokenize(text(),'&#9;')">
								<xsl:if test="position() > 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	<!-- warning text -->
	<xsl:template match="RichText[@type = 'WarningText']">
		<xsl:if test="Item">
			<xsl:comment>Warnings</xsl:comment>
			<xsl:choose>
				<xsl:when test="/Products">
					<fo:block xsl:use-attribute-sets="blank-line">
						<fo:block xsl:use-attribute-sets="RichTextTitle" span="all">
							<!-- render warnings header -->
							<xsl:call-template name="getStaticText">
								<xsl:with-param name="field">warningssafety</xsl:with-param>
							</xsl:call-template>
						</fo:block>
						<!-- see content include -->
						<xsl:apply-templates mode="genericlist" select="Item">
							<xsl:sort data-type="number" select="@rank"/>
						</xsl:apply-templates>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="keep-together blank-line">
						<fo:block xsl:use-attribute-sets="BodyHeader">
							<!-- render warnings header -->
							<xsl:call-template name="getStaticText">
								<xsl:with-param name="field">warningssafety</xsl:with-param>
							</xsl:call-template>
						</fo:block>
						<!-- see content include -->
						<xsl:apply-templates mode="genericlist" select="Item">
							<xsl:sort data-type="number" select="@rank"/>
						</xsl:apply-templates>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- dimension diagram table -->
	<xsl:template match="RichText[@type = 'DimensionDiagramTable']">
		<xsl:variable name="dimensional-assets-exist">
			<xsl:apply-templates mode="asset-exists" select="Item"/>
		</xsl:variable>
		<xsl:if test="contains($dimensional-assets-exist,'true')">
			<xsl:comment>Dimensional diagram table</xsl:comment>
			<fo:block span="all" xsl:use-attribute-sets="blank-line">
				<fo:table width="100%">
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- dimensional drawing title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">dimensionaldrawing</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<!-- image and table -->
								<xsl:apply-templates mode="dimensiontable" select="Item">
									<xsl:sort data-type="number" select="@rank"/>
								</xsl:apply-templates>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Item" mode="asset-exists">
		<!-- check if the this item has an existing dimensional drawing -->
		<xsl:variable name="drawingAssetCode" select="@code"/>
		<xsl:choose>
			<xsl:when test="$root-node/ObjectAssetList/Object[id = $drawingAssetCode]/Asset[ResourceType = 'GVR']">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Item" mode="dimensiontable">
		<xsl:variable name="dimensional-asset-exist">
			<xsl:apply-templates mode="asset-exists" select="current()"/>
		</xsl:variable>
	<!-- Parked following code (CR 8681) for the time being untill problem with AHF is soveld. -->
		<xsl:variable name="cap-base-asset-or-wiringdiagram-exist">
			<xsl:choose>
				<xsl:when test="$root-node/AssetList/Asset[ResourceType = 'LCB' or ResourceType = 'LWD']">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$dimensional-asset-exist = 'true'">
			<!-- count the 'columns' of the first 'table row' -->
			<xsl:variable name="isLargeDimensionTable" select="(count(BulletList/BulletItem[1]/SubList/SubItem) + 1) > 6"/>
			<!--fo:block keep-together.within-page="always" xsl:use-attribute-sets="blank-line"-->
			<fo:block xsl:use-attribute-sets="blank-line">
				<fo:table>
					<fo:table-column column-width="{$grid-6-column}mm"/>
					<fo:table-column column-width="{$grid-gap}mm"/>
					<fo:table-column column-width="{$grid-6-column}mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<xsl:call-template name="addDebugBorders"/>
								<fo:block>
									<!-- dimensional drawing asset lookup -->
									<xsl:variable name="drawingAssetCode" select="@code"/>
									<xsl:apply-templates select="$root-node/ObjectAssetList/Object[id = $drawingAssetCode]/Asset[ResourceType = 'GVR']"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block/>
							</fo:table-cell>
							<fo:table-cell>
								<xsl:call-template name="addDebugBorders"/>
								<!--fo:block keep-together.within-page="always"-->
								<fo:block>
									<!-- hide table here if it has more that 6 columns -->
									<xsl:if test="not($isLargeDimensionTable)">
										<!-- table header -->
										<xsl:apply-templates mode="dimensiontable" select="Head"/>
										<!-- table -->
										<xsl:apply-templates mode="dimensiontable" select="BulletList"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
						<xsl:if test="$isLargeDimensionTable">
							<fo:table-row>
								<!-- add dimension table in new table row, using full page body width -->
								<fo:table-cell number-columns-spanned="3" padding-top="{3 * $grid-line}mm">
									<!-- make sure table is never wider than body -->
									<fo:block-container overflow="hidden">
										<!-- table header -->
										<xsl:apply-templates mode="dimensiontable" select="Head"/>
										<!-- table -->
										<xsl:apply-templates mode="dimensiontable" select="BulletList"/>
									</fo:block-container>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</fo:table-body>
				</fo:table>
			</fo:block>
			<fo:block clear="both"/>
		</xsl:if>
<!-- Parked following code (CR 8681) for the time being untill problem with AHF is soveld. -->
<!-- Development: Added cap-base asset to the dimensionaltable section. -->
<xsl:if test="/Products and $cap-base-asset-or-wiringdiagram-exist = 'true'">
	<fo:block keep-together.within-page="always" xsl:use-attribute-sets="blank-line">
		<fo:table margin="0mm" padding="0mm">
			<fo:table-body start-indent="0mm">
				<fo:table-row>
					<xsl:apply-templates select="$root-node/AssetList/Asset[ResourceType = 'LCB' or ResourceType = 'LWD']"/>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</fo:block>
	<fo:block clear="both"/>
</xsl:if>
	</xsl:template>
	<xsl:template match="Head" mode="dimensiontable">
		<fo:block margin-bottom="{$grid-line}mm" xsl:use-attribute-sets="RichTextHeader">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="BulletList" mode="dimensiontable">
		<xsl:variable name="isLargeDimensionTable" select="(count(BulletItem[1]/SubList/SubItem) + 1) > 6"/>
		<fo:table>
			<fo:table-body>
				<!-- table rows -->
				<xsl:apply-templates mode="dimensiontable"/>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	<xsl:template match="BulletItem" mode="dimensiontable">
		<fo:table-row>
			<!-- first column -->
			<xsl:apply-templates mode="dimensiontable" select="Text"/>
			<!-- next column(s) -->
			<xsl:apply-templates mode="dimensiontable" select="SubList"/>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="BulletItem/Text" mode="dimensiontable">
		<fo:table-cell padding-left="1mm" xsl:use-attribute-sets="TableDimensionDataCell">
			<xsl:call-template name="addDebugBorderRight"/>
			<fo:block xsl:use-attribute-sets="TableDataText">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<xsl:template match="SubList" mode="dimensiontable">
		<xsl:apply-templates mode="dimensiontable" select="SubItem">
			<xsl:sort data-type="number" select="@rank"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="SubItem" mode="dimensiontable">
		<fo:table-cell xsl:use-attribute-sets="TableDimensionDataCell">
			<xsl:call-template name="addDebugBorderRight"/>
			<fo:block xsl:use-attribute-sets="TableDataText">
				<xsl:apply-templates select="Text"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- related producs and accessories -->
	<xsl:template match="ProductReference[@ProductReferenceType = 'assigned']">
		<xsl:variable name="related-assets-exist">
			<xsl:apply-templates mode="asset-exists" select="CTN">
				<xsl:with-param name="resource-type">RTP</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:if test="contains($related-assets-exist,'true')">
			<xsl:comment>Related products</xsl:comment>
			<fo:block span="all" xsl:use-attribute-sets="blank-line">
				<!-- extra width required for asset caption floating area -->
				<fo:table width="{$body-width + $grid-gap + 1}mm">
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- related products title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">relatedproducts</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<!-- render related products in one row, one cell table -->
						<fo:table-row>
							<fo:table-cell>
								<fo:block>
									<!-- get unique CTN elements (first occurance), ordered by group -->
									<xsl:apply-templates mode="asset" select="CTN[not(@group = preceding-sibling::CTN/@group)]">
										<xsl:sort data-type="number" select="@groupRank"/>
										<xsl:with-param name="resource-type">RTP</xsl:with-param>
										<xsl:with-param name="show-header">false</xsl:with-param>
									</xsl:apply-templates>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
			<fo:block clear="both"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ProductReference[@ProductReferenceType = 'Accessory']">
		<xsl:variable name="accessory-assets-exist">
			<xsl:apply-templates mode="asset-exists" select="CTN">
				<xsl:with-param name="resource-type">RTP</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:if test="contains($accessory-assets-exist,'true')">
			<xsl:comment>Product accessoires</xsl:comment>
			<fo:block span="all" xsl:use-attribute-sets="blank-line">
				<!-- extra width required for asset caption floating area -->
				<fo:table width="{$body-width + $grid-gap + 1}mm">
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- accessories title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">accessories</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<!-- render accessories in one row, one cell table -->
						<fo:table-row>
							<fo:table-cell>
								<fo:block>
									<xsl:apply-templates mode="asset" select="CTN">
										<xsl:sort data-type="number" select="@rank"/>
										<xsl:with-param name="resource-type">RTP</xsl:with-param>
									</xsl:apply-templates>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
			<fo:block clear="both"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ProductReference/CTN" mode="asset">
		<xsl:param name="resource-type">none</xsl:param>
		<xsl:param name="show-header">true</xsl:param>
		<xsl:variable name="object-id" select="@CTN"/>
		<!-- render the asset and caption area from Asset perspective-->
		<xsl:apply-templates mode="asset-caption-float" select="$root-node/ObjectAssetList/Object[id = $object-id]/Asset[ResourceType = $resource-type]">
			<xsl:with-param name="caption-header" select="if($show-header = 'true') then(@DTN) else('')"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="ProductReference/CTN" mode="asset-exists">
		<xsl:param name="resource-type">none</xsl:param>
		<xsl:variable name="object-id" select="@CTN"/>
		<xsl:choose>
			<xsl:when test="$root-node/ObjectAssetList/Object[id = $object-id]/Asset[ResourceType = $resource-type]">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@DTN">
		<fo:block xsl:use-attribute-sets="CaptionHeader keep-next">
			<xsl:value-of select="."/>
		</fo:block>
	</xsl:template>
	<!-- product detail assets -->
	<xsl:template name="drawProductDetailAssets">
		<xsl:variable name="detail-asset-types">PDP,D1P,D2P,D3P,D4P,D5P</xsl:variable>
		<xsl:variable name="detail-assets" select="$root-node/ObjectAssetList/Object/Asset[contains($detail-asset-types,ResourceType)]"/>
		<xsl:if test="$detail-assets">
			<xsl:comment>Product details</xsl:comment>
			<fo:block span="all" xsl:use-attribute-sets="blank-line">
				<!-- extra width required for asset caption floating area -->
				<fo:table width="{$body-width + $grid-gap}mm">
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- product details title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">productdetails</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<!-- render product details in one row, one cell table -->
						<fo:table-row>
							<fo:table-cell>
								<fo:block>
									<!-- render the asset and caption area from Asset perspective-->
									<xsl:apply-templates mode="asset-caption-float" select="$detail-assets"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
			<fo:block clear="both"/>
		</xsl:if>
	</xsl:template>
	<!-- photometric data -->
	<xsl:template name="drawProductPhotometricData">
		<xsl:variable name="photometric-assets" select="$root-node/ObjectAssetList/Object/Asset[contains($photometric-product,ResourceType)]"/>
		<xsl:variable name="extended-photometric-assets" select="$root-node/AssetList/Asset[contains($extended-photometric-products,ResourceType)]"/>
		<xsl:if test="$photometric-assets or $extended-photometric-assets">
			<xsl:comment>Photometric data</xsl:comment>
<!-- Remove the 'break-before' attribute when AHF problem is solved. -->
			<fo:block span="all" xsl:use-attribute-sets="blank-line" break-before="page">
				<!-- extra width required for floating area margin-->
				<fo:table width="{$body-width + $grid-gap}mm">
					<xsl:if test="count($photometric-assets) = 1">
						<!-- don't repeat header at break when there is one asset (possibly larger than page!) -->
						<xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
					</xsl:if>
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- photometric data title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">photometricdata</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<!-- render photometric assets in one row, one cell table -->
						<!-- Only handle photometric-assets when they are available. -->
						<xsl:if test="$photometric-assets">
							<fo:table-row>
								<fo:table-cell>
									<xsl:apply-templates mode="photometric" select="$photometric-assets"/>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
						<!-- Only handle extended-photometric-assets when they are available. -->
						<xsl:if test="$extended-photometric-assets">
							<fo:table-row>
								<fo:table-cell>
									<fo:block>
										<fo:table margin="0mm" padding="0mm">
											<fo:table-body start-indent="0mm">
												<fo:table-row>
													<xsl:apply-templates select="$root-node/AssetList/Asset[contains($extended-photometric-products,ResourceType)]"/>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<xsl:template name="drawFamilyPhotometricData">
		<xsl:variable name="photometric-assets" select="$root-node/ObjectAssetList/Object/Asset[contains($photometric-family,ResourceType)]"/>
		<xsl:variable name="extended-photometric-assets" select="$root-node/ObjectAssetList/Object/Asset[contains($extended-photometric-products,ResourceType)]"/>
		<xsl:if test="$photometric-assets or $extended-photometric-assets">
			<xsl:comment>Photometric data</xsl:comment>
<!-- Remove the 'break-before' attribute when AHF problem is solved. -->
			<fo:block span="all" xsl:use-attribute-sets="blank-line" break-before="page">
				<!-- extra width required for floating area margin-->
				<fo:table width="{$body-width + $grid-gap}mm">
					<!-- place title in table header, so it will be repeated on page break -->
					<fo:table-header>
						<fo:table-row xsl:use-attribute-sets="keep-next">
							<fo:table-cell>
								<!-- photometric data title -->
								<fo:block xsl:use-attribute-sets="RichTextTitle">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">photometricdata</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>
					<fo:table-body>
						<!-- render photometric assets in one row, one cell table -->
						<!-- Only handle photometric-assets when they are available. -->
						<xsl:if test="$photometric-assets">
							<fo:table-row>
								<fo:table-cell>
									<xsl:apply-templates mode="photometric" select="$photometric-assets"/>
									<fo:block clear="both"/>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
						<!-- Only handle extended-photometric-assets when they are available. -->
						<xsl:if test="$extended-photometric-assets">
							<fo:table-row>
								<fo:table-cell>
									<fo:block>
										<fo:table margin="0mm" padding="0mm">
											<fo:table-body start-indent="0mm">
												<xsl:for-each select="$root-node/ObjectAssetList/Object[Asset[contains($extended-photometric-products,ResourceType)]]">
													<fo:table-row>
														<xsl:apply-templates select="Asset[contains($extended-photometric-products,ResourceType)]"/>
													</fo:table-row>
												</xsl:for-each>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
