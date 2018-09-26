<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet extension-element-prefixes="local" version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:local="http://pww.pkachu.philips.com/functions/local" xmlns:r4u="http://www.relate4u.com/xsl/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../Assets/XSL/rendering-functions.xsl"/>
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets.
			It contains definitions for rendering the different assets</description>
	</stylesheet>
	<!-- external parameters -->
	<xsl:param name="asset-folder">../Assets/Images</xsl:param>
	<xsl:param name="shadow-folder">../Assets/Shadows</xsl:param>
	<xsl:param name="debug-image-folder">none</xsl:param>
	<!-- main assets -->
	<!-- Attention: New imagetypes, also need to be enabled in 'pipes\LeafletRendering\config\doctypeConfig_FMT.xml' and 'pipes\LeafletRendering\config\doctypeConfig_PMT.xml'. -->
	<xsl:template match="Asset[ResourceType = 'CLP']" mode="cover-image">
		<!-- family cover image -->
		<fo:block margin-bottom="{3 * $grid-line}mm" text-align="center" xsl:use-attribute-sets="image-block">
			<fo:external-graphic content-height="{concat(120 * $grid-line,'mm')}" content-width="{$grid-5-column-plus}mm">
				<!-- apply image source -->
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>
	<xsl:template match="Asset[ResourceType = 'RTP']" mode="cover-image">
		<!-- product cover image -->
		<fo:block margin-bottom="{3 * $grid-line}mm" text-align="center" xsl:use-attribute-sets="image-block">
			<fo:external-graphic content-height="{concat(51 * $grid-line,'mm')}" content-width="{$grid-5-column-plus}mm">
				<!-- apply image source -->
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>
	<!-- award logo -->
	<xsl:template match="Award">
		<!-- award asset lookup -->
		<xsl:variable name="awardcode" select="AwardCode"/>
		<xsl:variable name="rootElement" select="ancestor::Product[1] | ancestor::Node[1]"/>
		<xsl:apply-templates select="$rootElement/ObjectAssetList/Object[id = $awardcode]/Asset[ResourceType = 'GAP']"/>
	</xsl:template>
	<xsl:template match="Asset[ResourceType = 'GAP']">
		<fo:block xsl:use-attribute-sets="image-block">
			<fo:external-graphic max-height="{$footer-height}mm" max-width="{$grid-5-column}mm">
				<xsl:call-template name="addDebugBorders"/>
				<!-- apply image source -->
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>
	<!-- system logo's -->
	<xsl:template match="SystemLogo">
		<xsl:variable name="assetId" select="SystemLogoCode"/>
		<xsl:variable name="system-logo-asset" select="$root-node/ObjectAssetList/Object[id = $assetId]/Asset[ResourceType = 'SLO']"/>
		<xsl:if test="$system-logo-asset">
			<fo:float float="left">
				<!-- system logo asset lookup -->
				<xsl:apply-templates select="$system-logo-asset"/>
			</fo:float>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Asset[ResourceType = 'SLO']">
		<fo:block margin-right="1mm" xsl:use-attribute-sets="image-block">
			<fo:external-graphic content-height="{3 * $grid-line}mm" padding-bottom="{$grid-line}mm">
				<xsl:call-template name="addDebugBorders"/>
				<!-- apply image source -->
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>
	<!-- product photometical data -->
	<xsl:variable name="photometric-product">LAS,LCD,LPD,LGU,LCC,LPC</xsl:variable>
	<xsl:template match="Asset[contains($photometric-product,ResourceType)]" mode="photometric">
		<!-- full width photometric assets -->
		<fo:block xsl:use-attribute-sets="blank-line keep-together">
			<!-- draw image with shadow -->
			<xsl:apply-templates mode="shadow-image" select="current()">
				<xsl:with-param name="image-width" select="$body-width"/>
				<xsl:with-param name="padding" select="$grid-gap"/>
			</xsl:apply-templates>
			<!-- caption -->
			<xsl:apply-templates select="Caption"/>
		</fo:block>
	</xsl:template>
	
	<!-- Parked following code (CR 8681) for the time being untill problem with AHF is soveld. -->
	<xsl:variable name="extended-photometric-products">LSQ,LSP</xsl:variable>
	<xsl:template match="Asset[contains($extended-photometric-products,ResourceType)]">
		<fo:table-cell>
			<xsl:call-template name="addDebugBorders"/>
			<fo:block margin-bottom="0mm" text-align="center" xsl:use-attribute-sets="image-block">
				<fo:external-graphic content-height="{concat(51 * $grid-line,'mm')}" content-width="{$grid-4-column}mm">
					<xsl:apply-templates select="InternalResourceIdentifier"/>
				</fo:external-graphic>
				<!-- caption -->
				<xsl:apply-templates select="Caption"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- Parked preceding code (CR 8681) for the time being untill problem with AHF is soveld. -->
	
	
	<!-- family photometric assets -->
	<xsl:variable name="photometric-family">LPI,LPW</xsl:variable>
	<xsl:template match="Asset[contains($photometric-family,ResourceType)]" mode="photometric">
		<fo:float float="left">
			<xsl:variable name="container-height" select="42 * $grid-line"/>
			<fo:block margin-right="3.6mm" xsl:use-attribute-sets="keep-together blank-line">
				<fo:block-container height="{$container-height + (3 * $grid-line)}mm" width="{$grid-4-column}mm">
					<xsl:call-template name="addDebugBorders"/>
					<fo:block-container display-align="center" height="{$container-height}mm" width="100%">
						<xsl:call-template name="addDebugBorders"/>
						<fo:block text-align="left" xsl:use-attribute-sets="image-block">
							<fo:external-graphic content-height="{$container-height}mm" content-width="{$grid-4-column}mm">
								<!-- apply image source -->
								<xsl:apply-templates select="InternalResourceIdentifier"/>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
					<xsl:apply-templates select="Caption"/>
				</fo:block-container>
			</fo:block>
		</fo:float>
	</xsl:template>
	<!-- dimensional drawing -->
	<xsl:template match="Asset[ResourceType = 'GVR']">
		<fo:block xsl:use-attribute-sets="image-block">
			<fo:external-graphic content-height="{18 * $grid-line}mm" content-width="{$grid-6-column}mm">
				<!-- make sure max height/width are set last -->
				<xsl:attribute name="max-height" select="concat(18 * $grid-line,'mm')"/>
				<xsl:attribute name="max-width" select="concat($grid-6-column,'mm')"/>
				<xsl:call-template name="addDebugBorders"/>
				<!-- apply image source -->
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
		</fo:block>
	</xsl:template>
<!-- Parked following code (CR 8681) for the time being untill problem with AHF is soveld. -->
<!-- Development: New dimensional image type. -->
<xsl:variable name="cap-base-assets-and-wiringdiagrams">LCB,LWD</xsl:variable>
<xsl:template match="Asset[contains($cap-base-assets-and-wiringdiagrams,ResourceType)]">
<!--xsl:template match="Asset[ResourceType = 'LCB']"-->
	<fo:table-cell>
		<xsl:call-template name="addDebugBorders"/>
		<fo:block margin-bottom="0mm" text-align="center" xsl:use-attribute-sets="image-block">
			<fo:external-graphic content-height="{concat(51 * $grid-line,'mm')}" content-width="{$grid-2-column}mm">
				<xsl:apply-templates select="InternalResourceIdentifier"/>
			</fo:external-graphic>
			<!-- caption -->
			<xsl:apply-templates select="Caption"/>
		</fo:block>
	</fo:table-cell>
</xsl:template>
	<!-- common asset templates -->
	<xsl:template match="Asset" mode="asset-caption-float">
		<!-- render container for image and caption (and external catpion header) -->
		<xsl:param name="caption-header" required="no"/>
		<fo:float float="left" margin-right="{$grid-gap}mm">
			<fo:block margin-bottom="{(3 * $grid-line) - 1.2}mm" xsl:use-attribute-sets="keep-together">
				<xsl:call-template name="addDebugBorders"/>
				<fo:table>
					<!-- Warning; 
						This table in the float element is wider than one text column, due to spacing between asset caption area's 
						It requires a container with a width of body-width + grid-gap 
					-->
					<fo:table-column column-width="{$grid-3-column}mm"/>
					<fo:table-column column-width="{$grid-gap}mm"/>
					<fo:table-column column-width="{$grid-3-column}mm"/>
					<fo:table-column column-width="{$grid-gap}mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<!-- render the image (including shadow) -->
								<xsl:apply-templates mode="shadow-image" select="current()">
									<xsl:with-param name="image-width" select="$grid-3-column"/>
									<xsl:with-param name="image-height" select="27 * $grid-line"/>
								</xsl:apply-templates>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block/>
							</fo:table-cell>
							<fo:table-cell>
								<!-- render (optional) caption header -->
								<xsl:if test="$caption-header">
									<xsl:apply-templates select="$caption-header"/>
								</xsl:if>
								<!-- render asset caption -->
								<xsl:apply-templates select="Caption"/>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block/>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</fo:float>
	</xsl:template>
	<xsl:template match="Asset" mode="shadow-image">
		<!-- render image with shadow -->
		<xsl:param name="image-height">none</xsl:param>
		<xsl:param name="image-width">none</xsl:param>
		<xsl:param name="padding">0</xsl:param>
		<!-- variable -->
		<xsl:variable name="shadow-offset">1.2</xsl:variable>
		<xsl:variable name="border-width" select="r4u:convert-pt-mm(0.4)"/>
		<fo:block start-indent="-{$shadow-offset}mm" xsl:use-attribute-sets="keep-together-always">
			<fo:table margin="0mm" padding="0mm" table-layout="fixed">
				<fo:table-column column-width="{$shadow-offset}mm"/>
				<fo:table-column column-width="{$image-width}mm"/>
				<fo:table-body start-indent="0mm">
					<fo:table-row>
						<xsl:if test="string($image-height) != 'none'">
							<xsl:attribute name="height" select="concat(($image-height - (2 * $border-width)),'mm')"/>
							<xsl:attribute name="overflow">hidden</xsl:attribute>
						</xsl:if>
						<fo:table-cell axf:background-content-width="{$shadow-offset}mm" axf:background-repeat="repeat-y" display-align="before">
							<!-- left center shadow -->
							<xsl:attribute name="axf:background-image" select="concat($shadow-folder,'/shadow-center-left.png')"/>
							<xsl:attribute name="axf:background-color" select="$white"/>
							<!-- left top shadow -->
							<fo:block xsl:use-attribute-sets="image-block">
								<fo:external-graphic content-height="{$shadow-offset}mm" content-width="{$shadow-offset}mm" src="{concat($shadow-folder,'/shadow-top-left.png')}">
									<xsl:call-template name="addDebugBorders"/>
								</fo:external-graphic>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="{$border-width}mm solid {$grey}" display-align="center" padding="{$padding}mm">
							<!-- image content -->
							<fo:block text-align="center">
								<xsl:variable name="width" select="$image-width - $border-width - (2 * $padding)"/>
								<xsl:variable name="height" select="number($image-height) - (2 * $border-width) - (2 * $padding)"/>
								<fo:block-container position="relative" width="{$width}mm">
									<xsl:if test="string($image-height) != 'none'">
										<xsl:attribute name="height" select="concat($height,'mm')"/>
										<xsl:attribute name="overflow">hidden</xsl:attribute>
									</xsl:if>
									<fo:block xsl:use-attribute-sets="image-block">
										<fo:external-graphic content-width="{$width}mm">
											<xsl:if test="string($image-height) != 'none'">
												<xsl:attribute name="content-height" select="concat($height,'mm')"/>
											</xsl:if>
											<!-- apply image source -->
											<xsl:apply-templates select="InternalResourceIdentifier"/>
										</fo:external-graphic>
									</fo:block>
								</fo:block-container>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="{$shadow-offset}mm">
						<fo:table-cell axf:background-content-width="{$shadow-offset}mm" axf:background-repeat="repeat-x" display-align="after">
							<!-- bottom left filler shadow -->
							<xsl:attribute name="axf:background-color" select="$white"/>
							<xsl:attribute name="axf:background-image" select="concat($shadow-folder,'/shadow-center-left.png')"/>
							<!-- bottom left shadow -->
							<fo:block text-align="left" xsl:use-attribute-sets="image-block">
								<fo:external-graphic content-height="{$shadow-offset}mm" content-width="{$shadow-offset}mm" src="{concat($shadow-folder,'/shadow-bottom-left.png')}">
									<xsl:call-template name="addDebugBorders"/>
								</fo:external-graphic>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell axf:background-content-height="{$shadow-offset * 1.25}mm" axf:background-repeat="repeat-x" display-align="after">
							<!-- bottom filler shadow-->
							<xsl:attribute name="axf:background-color" select="$white"/>
							<xsl:attribute name="axf:background-image" select="concat($shadow-folder,'/shadow-bottom-center-high.png')"/>
							<!-- bottom right shadow -->
							<fo:block text-align="right" xsl:use-attribute-sets="image-block">
								<fo:external-graphic content-height="{$shadow-offset}mm" content-width="{$shadow-offset}mm" src="{concat($shadow-folder,'/shadow-bottom-right.png')}">
									<xsl:call-template name="addDebugBorders"/>
								</fo:external-graphic>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="Asset/Caption">
		<fo:block xsl:use-attribute-sets="CaptionText keep-previous">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="InternalResourceIdentifier">
		<xsl:attribute name="src">
			<xsl:choose>
				<xsl:when test="$debug-image-folder != 'none'">
					<xsl:value-of select="$debug-image-folder"/>
					<xsl:text>/</xsl:text>
					<xsl:variable name="tmp-file" select="translate(tokenize(.,'/')[position() = last()],$uppercase,$lowercase)"/>
					<xsl:value-of select="if (contains($tmp-file, '.eps')) then replace($tmp-file, '.eps', '.pdf') else $tmp-file"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="asset-id">
						<xsl:choose>
							<xsl:when test="ancestor::Object">
								<!-- Object asset -->
								<xsl:value-of select="ancestor::Object/id"/>
							</xsl:when>
							<xsl:when test="name($root-node) = 'Product'">
								<!-- Product -->
								<xsl:value-of select="$root-node/CTN"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- Family -->
								<xsl:value-of select="$root-node/@code"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($asset-folder,'/',local:get-raw-asset-cache-file-path($asset-id, ..)) "/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
