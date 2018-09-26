<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets.
			It contains templates for page definitions, margins and static area's. These templates are called from product/node perspective
		</description>
	</stylesheet>
	<!-- external parameters -->
	<xsl:param name="debug-grid">false</xsl:param>
	<xsl:param name="logo-folder">../Assets/Logos</xsl:param>
	<xsl:param name="grid-folder">../Assets/Grids</xsl:param>
	<!-- grid definitions -->
	<xsl:variable name="grid-column">12.2</xsl:variable>
	<xsl:variable name="grid-gap">3.6</xsl:variable>
	<xsl:variable name="grid-2-column" select="2 * $grid-column + 1 * $grid-gap"/>
	<xsl:variable name="grid-2-column-plus" select="$grid-2-column + $grid-gap"/>
	<xsl:variable name="grid-3-column" select="3 * $grid-column + 2 * $grid-gap"/>
	<xsl:variable name="grid-3-column-plus" select="$grid-3-column + $grid-gap"/>
	<xsl:variable name="grid-4-column" select="4 * $grid-column + 3 * $grid-gap"/>
	<xsl:variable name="grid-4-column-plus" select="$grid-4-column + $grid-gap"/>
	<xsl:variable name="grid-5-column" select="5 * $grid-column + 4 * $grid-gap"/>
	<xsl:variable name="grid-5-column-plus" select="$grid-5-column + $grid-gap"/>
	<xsl:variable name="grid-6-column" select="6 * $grid-column + 5 * $grid-gap"/>
	<xsl:variable name="grid-6-column-plus" select="$grid-6-column + $grid-gap"/>
	<xsl:variable name="grid-7-column" select="7 * $grid-column + 6 * $grid-gap"/>
	<xsl:variable name="grid-7-column-plus" select="$grid-7-column + $grid-gap"/>
	<xsl:variable name="footer-height">25.125</xsl:variable>
	<!-- page definition -->
	<xsl:variable as="element(page-settings)" name="page-settings">
		<!-- this variable holds page template sizes and margins-->
		<page-settings column-gap="{$grid-gap}" height="297" width="210">
			<page-template margin-bottom="40.525" margin-left="12" margin-right="12" margin-top="12" name="first"/>
			<page-template margin-bottom="15.76" margin-left="12" margin-right="12" margin-top="24.72" name="other"/>
			<page-template margin-bottom="53.9" margin-left="12" margin-right="12" margin-top="24.72" name="last"/>
			<page-template margin-bottom="90" margin-left="12" margin-right="12" margin-top="24.72" name="last-legal-text"/>
		</page-settings>
	</xsl:variable>
	<xsl:variable name="body-width" select="$page-settings/@width - $page-settings/page-template[1]/@margin-left - $page-settings/page-template[1]/@margin-right"/>
	<xsl:variable name="body-height-first" select="$page-settings/@height - $page-settings/page-template[1]/@margin-top - $page-settings/page-template[1]/@margin-bottom"/>
	<xsl:variable name="body-height" select="$page-settings/@height - $page-settings/page-template[2]/@margin-top - $page-settings/page-template[2]/@margin-bottom"/>
	<xsl:variable name="column-width" select="($body-width - $page-settings/@column-gap) div 2"/>
	<!-- template for page-settings page element -->
	<xsl:template match="page-template">
		<fo:simple-page-master master-name="A4-{@name}" page-height="{parent::page-settings/@height}mm" page-width="{parent::page-settings/@width}mm">
			<fo:region-body axf:column-count="2" axf:column-gap="{parent::page-settings/@column-gap}mm" margin-bottom="{@margin-bottom}mm" margin-left="{@margin-left}mm" margin-right="{@margin-right}mm"
				margin-top="{@margin-top}mm" region-name="body"/>
			<fo:region-before extent="{@margin-top}mm" region-name="{@name}-top"/>
			<fo:region-after extent="{@margin-bottom}mm" region-name="{@name}-bottom">
				<xsl:call-template name="addDebugBorders"/>
			</fo:region-after>
			<fo:region-start extent="{@margin-left}mm" precedence="true" region-name="{@name}-start"/>
			<fo:region-end extent="{@margin-right}mm" precedence="true" region-name="{@name}-end"/>
		</fo:simple-page-master>
	</xsl:template>
	<!-- page footer -->
	<xsl:variable name="legal-text-node" select="$root-node/RichTexts/RichText[@type = 'LegalTextEU']"/>
	<xsl:template name="drawFirstPageFooter">
		<!-- logo's for first page, in bottom static content -->
		<fo:float float="left">
			<fo:block>
				<fo:block-container display-align="after" height="{$footer-height}mm" text-align="left" width="{$grid-5-column}mm">
					<!-- render award logo; e.g. green flag, or ifa award -->
					<xsl:apply-templates select="Award[@AwardType = 'global'][1]"/>
				</fo:block-container>
			</fo:block>
		</fo:float>
		<fo:float float="right">
			<fo:block>
				<fo:block-container display-align="after" height="{$footer-height}mm" text-align="right" width="{$grid-5-column}mm">
					<!-- add slighty negative offset for brand logo -->
					<fo:block font-size="0pt" line-height="0pt" padding-bottom="-1.374mm">
						<fo:external-graphic content-width="63.375mm">
							<xsl:call-template name="addDebugBorders"/>
							<xsl:attribute name="src">
								<xsl:value-of select="$logo-folder"/>
								<xsl:text>/PhilipsWordmark_Payoff_CMYK.pdf</xsl:text>
							</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
				</fo:block-container>
			</fo:block>
		</fo:float>
	</xsl:template>
	<xsl:template name="drawPageFooter">
		<!-- page footer on every (but first and last) page, in bottom static content -->
		<fo:block-container left="{9 * ($grid-column + $grid-gap)}mm" position="absolute" top="2.2mm">
			<xsl:call-template name="drawDateChangeBlock"/>
		</fo:block-container>
	</xsl:template>
	<xsl:template name="drawLastPageFooter">
		<!-- page footer on last page, in bottom static content -->
		<fo:block-container display-align="after" height="26.987mm" left="0mm" position="absolute">
			<xsl:attribute name="top">
				<xsl:choose>
					<xsl:when test="$legal-text-node and name($root-node) = 'Product'">47.85mm</xsl:when>
					<xsl:otherwise>11.75mm</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<fo:block>
				<fo:block-container left="0mm" position="absolute" width="{$grid-2-column}mm">
					<xsl:call-template name="addDebugBorders"/>
					<fo:block font-size="0pt" line-height="0pt">
						<fo:external-graphic content-width="19.22mm">
							<xsl:attribute name="src">
								<xsl:value-of select="$logo-folder"/>
								<xsl:text>/PhilipsShield_CMYK.pdf</xsl:text>
							</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
				</fo:block-container>
				<fo:block-container left="{$grid-2-column-plus}mm" position="absolute" width="{$grid-7-column}mm" display-align="before">
					<xsl:call-template name="addDebugBorders"/>
					<fo:block xsl:use-attribute-sets="FooterText">
						<xsl:text>© </xsl:text>
						<xsl:call-template name="getYearValue"/>
						<xsl:text> </xsl:text>
						<xsl:call-template name="getStaticText">
							<xsl:with-param name="field">copyright_royal</xsl:with-param>
						</xsl:call-template>
					</fo:block>
					<fo:block xsl:use-attribute-sets="FooterText">
						<xsl:call-template name="getStaticText">
							<xsl:with-param name="field">copyright_text</xsl:with-param>
						</xsl:call-template>
					</fo:block>
					<fo:block line-height="{$grid-line}mm">&#160;</fo:block>
				</fo:block-container>
				<fo:block-container left="{9 * ($grid-column + $grid-gap)}mm" margin-bottom="{$grid-line}mm" position="absolute" width="{$grid-3-column}mm">
					<xsl:call-template name="addDebugBorders"/>
					<xsl:call-template name="drawDateChangeBlock"/>
					<fo:block line-height="{$grid-line}mm">&#160;</fo:block>
				</fo:block-container>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	<!-- page header -->
	<xsl:template name="drawPageFamilyHeading">
		<!-- page heading on every (but first) page, in top static content -->
		<fo:block-container background-color="{$blue_base}" height="{$grid-line * 5}mm" left="-{$grid-gap}mm" position="absolute" top="12mm">
			<fo:block>
				<fo:float float="left">
					<xsl:apply-templates mode="header" select="Name"/>
				</fo:float>
				<fo:float float="right">
					<fo:block margin-right="{$grid-gap}mm" xsl:use-attribute-sets="PageHeading">
						<fo:page-number/>
					</fo:block>
				</fo:float>
				<fo:block clear="both"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	<xsl:template name="drawPageProductHeading">
		<!-- page heading on every (but first) page, in top static content -->
		<fo:block-container background-color="{$blue_base}" height="{$grid-line * 5}mm" left="-{$grid-gap}mm" position="absolute" top="12mm">
			<xsl:apply-templates mode="header" select="NamingString/Family/FamilyName"/>
		</fo:block-container>
	</xsl:template>
	<xsl:template match="Name | FamilyName" mode="header">
		<!-- content for page header -->
		<fo:block margin-left="{$grid-gap}mm" xsl:use-attribute-sets="PageHeading">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- debug grid -->
	<xsl:template name="drawDebugGrid">
		<xsl:if test="$debug-grid = 'true'">
			<fo:static-content flow-name="first-start">
				<fo:block-container left="0mm" position="fixed" top="0mm" z-index="-100">
					<fo:block font-size="0pt" line-height="0pt">
						<fo:external-graphic src="{$grid-folder}/phl_leaflet_grid_first.pdf"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="other-start">
				<fo:block-container left="0mm" position="fixed" top="0mm" z-index="-100">
					<fo:block font-size="0pt" line-height="0pt">
						<fo:external-graphic src="{$grid-folder}/phl_leaflet_grid_other.pdf"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="last-start">
				<fo:block-container left="0mm" position="fixed" top="0mm" z-index="-100">
					<fo:block font-size="0pt" line-height="0pt">
						<fo:external-graphic src="{$grid-folder}/phl_leaflet_grid_other.pdf"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			<fo:static-content flow-name="last-legal-text-start">
				<fo:block-container left="0mm" position="fixed" top="0mm" z-index="-100">
					<fo:block font-size="0pt" line-height="0pt">
						<fo:external-graphic src="{$grid-folder}/phl_leaflet_grid_other.pdf"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
