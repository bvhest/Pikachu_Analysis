<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:r4u="http://www.relate4u.com/xsl/functions"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="UTF-8" exclude-result-prefixes="sql xs r4u" indent="yes" method="xml"/>
	<xsl:strip-space elements="*"/>
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<author>
			<name>Thijs Rovers</name>
			<company>Relate4u, Eindhoven</company>
			<email>thijs.rovers@relate4u.com</email>
		</author>
		<description>This stylesheet transforms Philips Lighting product XML (internal format) into an XLSFO product leaflet document.
			This stylesheet is written for PMT XML documents, compatible with the xUCDM_product_marketing_1_2 v003.xsd schema.</description>
		<toolset>
			<xslttransformer>Saxon 9</xslttransformer>
			<xslforenderer>Antennahouse XSLFormatter v5</xslforenderer>
		</toolset>
		<versions>
			<version nr="0.01">
				<date>2009/10/06 - 2009/10/13</date>
				<features>
					<feature>Page master layout</feature>
					<feature>Headers, footers and logo's</feature>
					<feature>Basic content for first page (?)</feature>
					<feature>Static text retreival</feature>
					<feature>Base line grid support</feature>
					<feature>Specification table</feature>
				</features>
			</version>
			<version nr="0.02">
				<date>2009/10/15 - 2009/10/19</date>
				<features>
					<feature>Moved asset templates to asset include</feature>
					<feature>Use asset for introduction image (beauty shot)</feature>
					<feature>Added dimensional drawing component</feature>
					<feature>Added photo metric data component</feature>
					<feature>Implemented debug area borders if 'debug-borders' param is true (renamed 'debug' to 'debug-grid')</feature>
				</features>
			</version>
			<version nr="0.03">
				<date>2009/10/22</date>
				<features>
					<feature>Renamed some asset resource types</feature>
					<feature>Award logo rendered from asset list</feature>
					<feature>Product data title from static text file</feature>
				</features>
			</version>
			<version nr="0.04">
				<date>2009/10/28 - 2009/10/29</date>
				<features>
					<feature>Multiple product data tables allowed</feature>
					<feature>Multiple CSChapter elements merged into one table, added sub-headers for separation</feature>
				</features>
				<fixes>
					<fix>Product data with system logo table border</fix>
					<fix>Dimensional table wider than page body</fix>
				</fixes>
			</version>
			<version nr="0.05">
				<date>2009/11/06 - 2009/11/11</date>
				<features>
					<feature>Height for text container on first page flexible, due to possible large amounts of text</feature>
				</features>
				<fixes>
					<fix>Fixed issue with system logo's</fix>
				</fixes>
			</version>
			<version nr="0.06">
				<date>2009/11/26</date>
				<features>
					<feature>Added CSValueDescription to Product data table values (if present)</feature>
				</features>
				<fixes>
					<fix>Added photometric data header text to static text files</fix>
				</fixes>
			</version>
			<version nr="0.07">
				<date>2010/01/25</date>
				<features>
					<feature>Reduce the font size of the product name in the product leaflet to 40% of the family name</feature>
					<feature>Filter specifications without value</feature>
				</features>
			</version>
			<version nr="0.08">
				<date>2010/02/24</date>
				<features>
					<feature>Changes by Bart van Hest</feature>
					<feature>Introduction image; remove border, center and widen, max-height</feature>
					<feature>Re-styled product data table</feature>
					<feature>Apply automatic hyphenation for table content</feature>
				</features>
				<fixes>
					<fix>Keep system logo's with table</fix>
				</fixes>
			</version>
			<version nr="0.09">
				<date>2010/03/02 - 2010/03/03</date>
				<features>
					<feature>Updated introduction image to have max 1/2 of body height and less width</feature>
					<feature>Hide dimensional drawing (title and table) when asset is missing, and header when all are missing</feature>
					<feature>Give dimensional drawings maximum height and width allowed in the container</feature>
				</features>
				<fixes>
					<fix>Don't set minimum height on intro text when it counts more than 2000 characters</fix>
				</fixes>
			</version>
			<version nr="0.10">
				<date>2010/03/09 - 2010/03/16</date>
				<features>
					<feature>Show different assets for photometric data; floating in three different sizes</feature>
					<feature>Set max height for intro image to 1/3 of body height</feature>
				</features>
				<fixes>
					<fix>Add hyphenation to product data table CSItem name elements</fix>
					<fix>Fixed max-height for intro image</fix>
				</fixes>
			</version>
			<version nr="0.11">
				<date>2010/03/29 - 2010/04/06</date>
				<features>
					<feature>Add support for legal text rich text element (do tab replace to preserve lettered list)</feature>
					<feature>Add support for XML change on CSChapter for product data table (plural elements)</feature>
					<feature>Don't render these photometric asset types: LBD, LQE, LUF, LUG (LGU), LUT, LTT</feature>
					<feature>Add caption to photometric data</feature>
					<feature>Give photometric data image full page-body width and add a border (all types equal)</feature>
					<feature>Revise shadow mechanism to also cope with images without preset size (height and width)</feature>
					<feature>Added padding to photometric image inside frame</feature>
					<feature>Place legal text in last page footer region (extend region size if text is present), account for 20% extra text height</feature>
					<feature>Widen copyright text area to prevent collision with legal text and set vertical text align to top instead of bottom</feature>
				</features>
				<fixes>
					<fix>Keep repeatable component headers with next element</fix>
					<fix>Photometric data going through last page footer if asset larger than body region</fix>
					<fix>Bottom shadow; removed line by using different (repeating) background image</fix>
				</fixes>
			</version>
			<version nr="0.12">
				<date>2010/12/01</date>
				<features>
					<feature>Add a short product description (from PMT FullProductName) to the leaflet</feature>
				</features>
			</version>
			<version nr="0.13">
				<date>2011/02/07</date>
				<features>
					<feature>Add support for more than one "RichText[@type='TextTable']" elements to the leaflet</feature>
<!-- Activated following code (CR 8681) although the problem with AHF isn't solved. -->
					<feature>Add support for more photometric assettypes (LSQ, LSP) to the leaflet</feature>
					<feature>Add support for more dimensional assettypes (LCB) to the leaflet</feature>
				</features>
			</version>
			<version nr="0.14">
				<date>2011/02/28</date>
				<features>
					<feature>Add support for "RichText[@type = 'WarningText']" elements to the leaflet</feature>
				</features>
			</version>
			<version nr="0.15">
				<date>2011/03/04</date>
				<features>
					<feature>Add support for "SUB" elements (subscript) to the leaflet</feature>
				</features>
			</version>
			<version nr="0.16">
				<date>2011/03/14</date>
				<features>
					<feature>Added support for Wiring Diagrams to the leaflet</feature>
				</features>
			</version>
			<version nr="0.17">
				<date>2011/03/15</date>
				<features>
					<feature>Add support for "SUP" elements (superscript) to the leaflet</feature>
				</features>
			</version>
		</versions>
	</stylesheet>
	<!-- includes -->
	<xsl:include href="phl_include_pages.xsl"/>
	<xsl:include href="phl_include_styles.xsl"/>
	<xsl:include href="phl_include_content.xsl"/>
	<xsl:include href="phl_include_assets.xsl"/>
	<xsl:include href="phl_include_richtext.xsl"/>
	<xsl:include href="phl_include_tables.xsl"/>
	<xsl:include href="phl_include_static.xsl"/>
	<!-- global variables -->
	<xsl:variable name="root-node" select="/Products/descendant::Product[1]"/>
	<!-- Robert Melskens: Why this variable has been placed here while its not used here and all related variables are within 
		 the 'phl_include_static.xsl' stylesheet is puzzling me! Consider moving it to that stylesheet. -->
	<xsl:variable name="static-text-file" select="concat($static-text-folder,'/static_text_PMT_',$locale-code,'.xml')"/>
	<xsl:variable name="last-modified" select="$root-node/@lastModified"/>
	<!-- product-->
	<xsl:template match="/">
		<fo:root>
			<axf:document-info name="title" value="Product Leaflet: {$root-node/ProductName}"/>
			<axf:document-info name="author" value="Philips Lighting"/>
			<axf:document-info name="keywords">
				<xsl:attribute name="value">
					<xsl:text>XSL-FO stylesheet created by Relate4u (http://www.relate4u.com), </xsl:text>
					<xsl:text>v0.9, </xsl:text>
					<xsl:text>Transformer=[</xsl:text>
					<xsl:value-of select="system-property('xsl:vendor')"/>
					<xsl:text>], XSLT Version=[</xsl:text>
					<xsl:value-of select="system-property('xsl:version')"/>
					<xsl:text>], Vendor Url=[</xsl:text>
					<xsl:value-of select="system-property('xsl:vendor-url')"/>
					<xsl:text>]</xsl:text>
				</xsl:attribute>
			</axf:document-info>
			<fo:layout-master-set>
				<!-- render simpel page masters -->
				<xsl:apply-templates select="$page-settings/page-template"/>
				<!-- page sequence master, assigning simple page masters to page positions -->
				<fo:page-sequence-master master-name="A4">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="A4-first" page-position="first"/>
						<xsl:choose>
							<xsl:when test="$legal-text-node">
								<!-- apply page with larger footer region when legal text is present -->
								<fo:conditional-page-master-reference master-reference="A4-last-legal-text" page-position="last"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:conditional-page-master-reference master-reference="A4-last" page-position="last"/>
							</xsl:otherwise>
						</xsl:choose>
						<fo:conditional-page-master-reference master-reference="A4-other"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<!-- start appending content -->
			<xsl:apply-templates/>
		</fo:root>
	</xsl:template>
	<xsl:template match="Products">
		<!-- by-pass any (optional) sql:* elements, Product can also be direct child -->
		<xsl:apply-templates select="descendant::Product"/>
	</xsl:template>
	<xsl:template match="Product">
		<fo:page-sequence master-reference="A4" xsl:use-attribute-sets="page">
			<!-- page sequence static content for content outside body region -->
			<fo:static-content flow-name="first-bottom">
				<!-- render logo's on first page  -->
				<xsl:call-template name="drawFirstPageFooter"/>
			</fo:static-content>
			<fo:static-content flow-name="other-top">
				<xsl:call-template name="drawPageProductHeading"/>
			</fo:static-content>
			<fo:static-content flow-name="other-bottom">
				<xsl:call-template name="drawPageFooter"/>
			</fo:static-content>
			<xsl:choose>
				<xsl:when test="$legal-text-node">
					<fo:static-content flow-name="last-legal-text-top">
						<xsl:call-template name="drawPageProductHeading"/>
					</fo:static-content>
					<fo:static-content flow-name="last-legal-text-bottom">
						<xsl:apply-templates select="$legal-text-node"/>
						<xsl:call-template name="drawLastPageFooter"/>
					</fo:static-content>
				</xsl:when>
				<xsl:otherwise>
					<fo:static-content flow-name="last-top">
						<xsl:call-template name="drawPageProductHeading"/>
					</fo:static-content>
					<fo:static-content flow-name="last-bottom">
						<xsl:call-template name="drawLastPageFooter"/>
					</fo:static-content>
				</xsl:otherwise>
			</xsl:choose>
			<!-- render debug grid (if in debug mode) -->
			<xsl:call-template name="drawDebugGrid"/>
			<fo:flow flow-name="body">
				<!-- apply specific content elements in given order -->
				<xsl:call-template name="renderProductElements"/>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="renderProductElements">
		<fo:block>
			<!-- beauty shot on first page left column -->
			<xsl:apply-templates mode="cover-image" select="AssetList/Asset[ResourceType = 'RTP']"/>
		</fo:block>
		<!-- first page right column -->
		<fo:block break-before="column"/>
		<fo:block-container xsl:use-attribute-sets="blank-line">
			<xsl:if test="string-length(MarketingTextHeader) &lt; 2000">
				<!-- don't add min-height if text is longer than first page, the min-height is also applied on part of block container on next page -->
				<xsl:attribute name="min-height">
					<xsl:value-of select="69 * $grid-line"/>
					<xsl:text>mm</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<!-- use minimum height so this area can grow if there is too much text -->
			<xsl:call-template name="addDebugBorders"/>
			<!-- title and subtitle -->
			<xsl:apply-templates mode="product" select="NamingString/Family/FamilyName"/>
			<xsl:apply-templates select="DTN"/>
			<!-- short product description -->
			<xsl:apply-templates mode="product" select="FullProductName"/>
			<!-- introduction text -->
			<xsl:apply-templates mode="product" select="MarketingTextHeader"/>
		</fo:block-container>
		<!-- product data  -->
		<xsl:call-template name="drawProductDataTable"/>
		<!-- warning text  -->
		<xsl:apply-templates select="RichTexts/RichText[@type = 'WarningText']"/>
		<!-- dimensional drawing -->
		<xsl:apply-templates select="RichTexts/RichText[@type = 'DimensionDiagramTable']"/>
		<!-- photometric data -->
		<xsl:call-template name="drawProductPhotometricData"/>
		<fo:block clear="both"/>
	</xsl:template>
</xsl:stylesheet>
