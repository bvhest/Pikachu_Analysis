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
		<description>This stylesheet transforms Philips Lighting product XML (internal format) into an XLSFO family leaflet document.
			This stylesheet is written for FMT XML documents, compatible with the xUCDM_treenode_marketing_1_2 v003.xsd schema.</description>
		<toolset>
			<xslttransformer>Saxon 9</xslttransformer>
			<xslforenderer>Antennahouse XSLFormatter v5</xslforenderer>
		</toolset>
		<versions>
			<version nr="0.01">
				<date>2009/10/14</date>
				<features>
					<feature>Implement family template (Node element), based on the product leaflet</feature>
				</features>
			</version>
			<version nr="0.02">
				<date>2009/10/22</date>
				<features>
					<feature>Added key benefits</feature>
					<feature>Added features</feature>
					<feature>Added application</feature>
					<feature>Added system logo's to text table (specifications)</feature>
				</features>
			</version>
			<version nr="0.03">
				<date>2009/10/23</date>
				<features>
					<feature>Added beauty shot for cover page</feature>
					<feature>Dimensional drawing table over more than 6 columns</feature>
				</features>
			</version>
			<version nr="0.04">
				<date>2009/11/06 - 2009/11/09</date>
				<features>
					<feature>Split up global static text file into static text file per doc type, per language</feature>
					<feature>Added table label to specifications table</feature>
					<feature>Added related products</feature>
					<feature>Added accessoirces</feature>
					<feature>Added other photometric data (Spectral power distribution, CRV diagram, Performance diagram</feature>
				</features>
				<updates>
					<update>Updated image asset source path contruction (based on Locale, Image size and CTN, example provided by Bart van Hest)</update>
					<update>Updated some templates to match new XML schema: xUCDM_treenode_marketing_1_2 - render.xsd (2009/11/09)</update>
				</updates>
				<fixes>
					<fix>Fixed issue with multiple specifications tables; space on page was not used optimally</fix>
				</fixes>
			</version>
			<version nr="0.05">
				<date>2009/11/13 - 2009/11/16</date>
				<features>
					<feature>Added DTN as caption header for accessoires</feature>
					<feature>Added product detail images</feature>
					<feature>Added comparison table (column, page and multi page)</feature>
				</features>
				<updates>
					<update>Reverted image asset source path contruction; removed the image size part, from release 0.4</update>
					<update>Resource type for dimensional drawing asset renamed from DIM to GVR</update>
					<update>Resource type for cover family asset renamed from LBS to PWL</update>
				</updates>
			</version>
			<version nr="0.06">
				<date>2009/11/26</date>
				<features>
					<feature>Implemented photometric data for family (LPI and LPW)</feature>
				</features>
				<fixes>
					<fix>Keep dimensional drawing table header with table (if more than six columns)</fix>
					<fix>Hide product details header if there are no product detail assets</fix>
				</fixes>
			</version>
			<version nr="0.07">
				<date>2010/02/24 - 2010/02/25</date>
				<features>
					<feature>Apply 20% smaller font-size to WOW</feature>
					<feature>Updated family name to use same style as product DTM</feature>
					<feature>Add hyphenation to specifications table and headers in compare table</feature>
					<feature>Filter headers where there is no content (Key benefits, Accessoires, Related products, Photometric data)</feature>
					<feature>Introduction image; center, widen, max-height</feature>
					<feature>Implement backup image if CLP asset is absent; RTP asset from first related product</feature>
					<feature>Remove caption header (@DTN) for Related products</feature>
					<feature>Insert '-' when value in compare table is empty or missing</feature>
					<feature>Use @referenceName when header in compare table is empty or missing, warning; always English</feature>
					<feature>Filter columns in compare table if there are no values, and substracted empty columns from the max. column count (12)</feature>
				</features>
				<fixes>
					<fix>Keep system logo's with table</fix>
					<fix>Compare table headers, only render first if more are found</fix>
					<fix>Ranking in accesoires and related products</fix>
				</fixes>
			</version>
			<version nr="0.08">
				<date>2010/03/02 - 2010/03/03</date>
				<features>
					<feature>Updated introduction image to have max 3/4 of body height and less width</feature>
					<feature>(Temporarily) disable the ranking for the specification table</feature>
					<feature>Don't stretch RTP images, but place centered in the square container (details, accessoires, related... all images with shadow)</feature>
					<feature>For photometric data; render all LPI and LPW assets, not via CTN lookup</feature>
				</features>
				<fixes>
					<fix>Continuation of compare tables should count max 10 + 2 columns, not 12 + 2</fix>
					<fix>Make compare table title go over two columns for narrow tables (if continuation)</fix>
					<fix>Make at least two rows should exist on page when table breaks</fix>
					<fix>Fix compare table running through last page footer</fix>
				</fixes>
			</version>
			<version nr="0.09">
				<date>2010/03/09 - 2010/03/22</date>
				<features>
					<feature>Add accessory column and data lookup to compare table</feature>
					<feature>Hide rows for compare table where CTN has no data (lookup)</feature>
					<feature>Always place accessories data after product data in compare table</feature>
					<feature>Hide empty items in specification table</feature>
				</features>
				<fixes>
					<fix>Fix for filtering duplicate related products</fix>
					<fix>Fixed max-height for intro image</fix>
					<fix>Fix keep with next for compare table title (span vs. horizontal alignment on small table column break)</fix>
				</fixes>
			</version>
			<version nr="0.10">
				<date>2010/03/29 - 2010/04/06</date>
				<features>
					<feature>Add support for captions below photometric data assets</feature>
					<feature>Apply grid to photometric assets</feature>
					<feature>Apply new shadow mechanism</feature>
					<feature>Revise photometric asset grid; use fixed size containers on 3x3 grid and align the caption horizontally</feature>
				</features>
			</version>
			<version nr="0.11">
				<date>2010/04/21</date>
				<fixes>
					<fix>Ignore legal text for FMT leaflet (layout rule for legal text was common)</fix>
				</fixes>
			</version>
			<version nr="0.12">
				<date>2011/02/07</date>
				<features>
					<feature>Add support for more than one "RichText[@type='TextTable']" elements to the leaflet</feature>
<!-- Activated following code (CR 8681) although the problem with AHF isn't solved. -->
					<feature>Add support for more photometric assettypes (LSQ, LSP) to the leaflet</feature>
					<feature>Add support for more dimensional assettypes (LCB) to the leaflet</feature>
				</features>
			</version>
			<version nr="0.13">
				<date>2011/02/28</date>
				<features>
					<feature>Add support for "RichText[@type = 'WarningText']" elements to the leaflet</feature>
				</features>
			</version>
			<version nr="0.14">
				<date>2011/03/04</date>
				<features>
					<feature>Add support for "SUB" elements (subscript) to the leaflet</feature>
				</features>
			</version>
			<version nr="0.15">
				<date>2011/03/14</date>
				<features>
					<feature>Added support for Wiring Diagrams to the leaflet</feature>
				</features>
			</version>
			<version nr="0.16">
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
	<xsl:include href="phl_include_richtext.xsl"/>
	<xsl:include href="phl_include_tables.xsl"/>
	<xsl:include href="phl_include_assets.xsl"/>
	<xsl:include href="phl_include_static.xsl"/>
	<!-- global variables -->
	<xsl:variable name="root-node" select="/Nodes/descendant::Node[1]"/>
	<!-- Robert Melskens: Why this variable has been placed here while its not used here and all related variables are within 
		 the 'phl_include_static.xsl' stylesheet is puzzling me! Consider moving it to that stylesheet. -->
	<xsl:variable name="static-text-file" select="concat($static-text-folder,'/static_text_FMT_',$locale-code,'.xml')"/>
	<xsl:variable name="last-modified" select="$root-node/@masterLastModified"/>
	<!-- nodes-->
	<xsl:template match="/">
		<fo:root>
			<axf:document-info name="title" value="Product Familiy Leaflet: {$root-node/Name}"/>
			<axf:document-info name="author" value="Philips Lighting"/>
			<axf:document-info name="keywords">
				<xsl:attribute name="value">
					<xsl:text>XSL-FO stylesheet created by Relate4u (http://www.relate4u.com), </xsl:text>
					<xsl:text>v0.8, </xsl:text>
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
						<fo:conditional-page-master-reference master-reference="A4-last" page-position="last"/>
						<fo:conditional-page-master-reference master-reference="A4-other"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<!-- start appending content -->
			<xsl:apply-templates/>
		</fo:root>
	</xsl:template>
	<xsl:template match="Nodes">
		<!-- by-pass any (optional) sql:* elements, Node can also be direct child -->
		<xsl:apply-templates select="descendant::Node"/>
	</xsl:template>
	<xsl:template match="Node">
		<fo:page-sequence master-reference="A4" xsl:use-attribute-sets="page">
			<!-- page sequence static content for content outside body region -->
			<fo:static-content flow-name="first-bottom">
				<!-- render logo's on first page  -->
				<xsl:call-template name="drawFirstPageFooter"/>
			</fo:static-content>
			<fo:static-content flow-name="other-top">
				<xsl:call-template name="drawPageFamilyHeading"/>
			</fo:static-content>
			<fo:static-content flow-name="last-top">
				<xsl:call-template name="drawPageFamilyHeading"/>
			</fo:static-content>
			<fo:static-content flow-name="other-bottom">
				<xsl:call-template name="drawPageFooter"/>
			</fo:static-content>
			<fo:static-content flow-name="last-bottom">
				<xsl:call-template name="drawLastPageFooter"/>
			</fo:static-content>
			<!-- render debug grid (if in debug mode) -->
			<xsl:call-template name="drawDebugGrid"/>
			<fo:flow flow-name="body">
				<!-- apply specific content elements in given order -->
				<xsl:call-template name="renderFamilyElements"/>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template name="renderFamilyElements">
		<fo:block>
			<!-- beauty shot on first page left column -->
			<xsl:choose>
				<xsl:when test="AssetList/Asset[ResourceType = 'CLP']">
					<xsl:apply-templates mode="cover-image" select="AssetList/Asset[ResourceType = 'CLP']"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- get backup image; first related product RTP asset-->
					<xsl:variable name="first-product" select="ProductRefs/ProductReference[@ProductReferenceType = 'assigned']/CTN[1]"/>
					<xsl:apply-templates mode="cover-image" select="$root-node/ObjectAssetList/Object[id = $first-product/@CTN]/Asset[ResourceType = 'RTP']"/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
		<!-- first page right column -->
		<fo:block break-before="column">
			<!-- date change field -->
			<fo:block-container height="{11 * $grid-line}mm">
				<fo:block margin-left="{$grid-3-column}mm">
					<xsl:call-template name="drawDateChangeBlock"/>
				</fo:block>
			</fo:block-container>
			<!-- title and subtitle -->
			<xsl:apply-templates select="WOW"/>
			<xsl:apply-templates mode="family" select="Name"/>
			<!-- introduction text -->
			<xsl:apply-templates mode="family" select="MarketingTextHeader"/>
			<!-- benefits -->
			<xsl:call-template name="KeyBenefitAreas"/>
			<!-- features -->
			<xsl:apply-templates select="RichTexts/RichText[@type = 'FeatureText']"/>
			<!-- application -->
			<xsl:apply-templates select="RichTexts/RichText[@type = 'ApplicationText']"/>
			<!-- warnings -->
			<xsl:apply-templates select="RichTexts/RichText[@type = 'WarningText']"/>
		</fo:block>
		<fo:block break-before="column"/>
		<!-- specifications table -->
		<xsl:apply-templates select="RichTexts/RichText[@type = 'TextTable']"/>
		<!-- related products -->
		<xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType = 'assigned']"/>
		<!-- dimensional drawing -->
		<xsl:apply-templates select="RichTexts/RichText[@type = 'DimensionDiagramTable']"/>
		<!-- accessories-->
		<xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType = 'Accessory']"/>
		<!-- product detail images -->
		<xsl:call-template name="drawProductDetailAssets"/>
		<!-- photometric data -->
		<xsl:call-template name="drawFamilyPhotometricData"/>
		<!-- compare table -->
		<xsl:apply-templates select="Filters/Purpose[@type = 'Differentiating']"/>
	</xsl:template>
</xsl:stylesheet>
