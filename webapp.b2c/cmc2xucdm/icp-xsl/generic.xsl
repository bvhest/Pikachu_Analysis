<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="constants.xsl"/>
	<xsl:output method="html" encoding="UTF-8" indent="yes" standalone="yes"/>
	<!-- Adding a doctype breaks a lot of thing in IE
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	-->

	<xsl:variable name="catalog" select="'CONSUMER'"/>
	<!-- Index on Asset by code attribute to easily find Assets -->
	<xsl:key name="asset-by-code" match="//Assets/Asset" use="concat(ancestor::Product/CTN,@code)"/>

	<xsl:variable name="locale">
		<xsl:choose>
			<xsl:when test="/*/@targetLocale">
				<xsl:value-of select="(/*/@targetLocale)[1]"/>
			</xsl:when>
			<xsl:when test="/*/*[1]/@Locale">
				<xsl:value-of select="(/*/*[1]/@Locale)[1]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'en_GB'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="locale-lc" select="translate($locale,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="country" select="substring($locale,4,2)"/>
	<xsl:variable name="country-lc" select="translate($country,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="lang" select="substring($locale,1,2)"/>
		 
	<xsl:template match="/">
		<!-- Insert "Mark of the Web" comment for IE. See http://msdn.microsoft.com/en-us/library/ms537628(VS.85).aspx -->
		<xsl:comment><xsl:text> saved from url=(0014)about:internet </xsl:text></xsl:comment><xsl:text><![CDATA[
]]></xsl:text>
<!-- Leave the above line unindented -->
		<html locale="{$locale}">
			<head>
				<xsl:comment>Generic headers</xsl:comment>
				<title>In Context Preview</title>
				<script type="text/javascript" src="{$icp-host}js/jquery/jquery-1.3.2.js"></script>
				<script type="text/javascript" src="{$icp-host}js/jquery/jquery.dimensions.min.js"></script>
				<script type="text/javascript" src="{$icp-host}js/jquery/jquery.tooltip.min.js"></script>
				<script type="text/javascript" src="{$icp-host}js/jquery/jquery.metadata.min.js"></script>
				<script type="text/javascript" src="{$icp-host}js/jquery/jquery.imageLoader.js"></script>
				<script type="text/javascript" src="{$icp-host}flowplayer/flowplayer-3.1.1.min.js"></script>

				<script type="text/javascript" src="{$icp-host}js/icp/md5.js"></script>
				<script type="text/javascript" src="{$icp-host}js/icp/logger.js"></script>
				<script type="text/javascript" src="{$icp-host}js/icp/AssetIndex.js"></script>
				<script type="text/javascript" src="{$icp-host}js/icp/icpconfig.js"></script>
				<script type="text/javascript" src="{$icp-host}js/icp/icp.js"></script>
				<script type="text/javascript" src="{$icp-host}js/icp/CcrUtil.js"></script>
				
				<link rel="stylesheet" type="text/css" href="{$icp-host}css/icp/icp.css" />
				<link rel="stylesheet" type="text/css" href="{$icp-host}css/icp/icp_print.css" media="print"/>
				<link rel="stylesheet" type="text/css" href="{$icp-host}css/icp/generic.css" />
				<xsl:comment>[if IE]&gt;
					<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/icp/generic_ie.css" /&gt;</xsl:text>
				&lt;![endif]</xsl:comment>
				<link rel="stylesheet" type="text/css" href="{$icp-host}css/icp/logger.css" />
				
				<!-- Apply to all data types in headers mode to let each data type add its specific head elements -->
				<xsl:apply-templates select="/Products[Product]" mode="headers-product"/>
				<xsl:apply-templates select="/Nodes[Node]|/Products[Node]" mode="headers-range"/>
				<xsl:apply-templates select="/Products/Categorization|/Categorization" mode="headers-categorization"/>
				<xsl:apply-templates select="/Products/PackagingText|/PackagingText" mode="headers-packaging"/>
				
				<script type="text/javascript">
					// Transfer configuration settings to the javascript engine
					if (typeof window.ICPConfig === "undefined")
						ICPConfig = {config: {}};
					
					ICPConfig.config.icpHost = "<xsl:value-of select="$icp-host"/>";
					ICPConfig.config.scene7GetUrl = "<xsl:value-of select="$scene7-url"/>";
					ICPConfig.config.ccrGetUrl = "<xsl:value-of select="$ccr-url"/>";
					ICPConfig.config.ccrIsSecure = <xsl:value-of select="$ccr-is-secure"/>;
					ICPConfig.config.ccrIsDisabled = <xsl:value-of select="$ccr-is-disabled"/>;
					ICPConfig.config.system = "<xsl:value-of select="$system"/>";
					
				</script>
			</head>
			<body id="icp">
				<div id="icp_top">
					<div id="icp_logo_phl"></div>
					<div id="icp_title">In Context Preview</div>
					<div id="icp_viewbar">
						<table><tr>
							<td class="last">
								<xsl:if test="//*[@translate='yes']">
									<input type="checkbox" id="icp_highlight_translation_texts"/> <label for="icp_highlight_translation_texts">Highlight translatable text in Details tab</label>
								</xsl:if>
							</td>
						</tr></table>
					</div>
				</div>
				<!-- The view bar tabs will be rendered at 'runtime', based on the available views in the output -->
				
				<xsl:variable name="translation-errors">
					<xsl:apply-templates mode="collect-errors"/>
				</xsl:variable>
				<xsl:if test="string-length(normalize-space($translation-errors)) &gt; 0">
					<div id="icp_error_summary" class="icp_error_summary">
						<div class="icp_title">
							<div style="float: left">There are translation errors</div>
							<div style="float: right"><input type="checkbox" id="icp_show_errors_in_context" /><label for="icp_show_errors_in_context">Show errors in Details tab</label></div>
						</div>
						<div class="icp_errors">
							<xsl:copy-of select="$translation-errors"/>
						</div>
					</div>
				</xsl:if>
				
				<xsl:apply-templates/>
				
				<xsl:if test="$show-log">
					<div id="logger"></div>
				</xsl:if>
			</body>
		</html>
	</xsl:template>

	<!--
		Functions
	-->
	
	<!--
		Display a text
		
		text-node						an element whose text should be displayed.
		id-prefix						prefix for the id that is put on a translatable text.
		class								An additional class to put on the displayed element(s)
		tokenization-chars	characters that should be use to split the text string into separate elements in the output.
												(This is used for the leaflet to allow moving the text parts around.)
												This works only for non translatable texts.
		tokenization-class	style class to put on tokenized parts.
	-->
	<xsl:template name="display-text">
		<xsl:param name="text-node"/>
		<xsl:param name="id-prefix"/>
		<xsl:param name="class"/>
		<xsl:param name="tokenization-chars"/>
		<xsl:param name="tokenization-class"/>
		<xsl:choose>
			<xsl:when test="$text-node/@translate = 'yes'"> <!-- and $text-node/@validate = 'yes' -->
				<xsl:variable name="the-text">
					<xsl:choose>
						<xsl:when test="$text-node/trans">
							<xsl:value-of select="normalize-space($text-node/trans/text())"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space($text-node/text())"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="text-ownerId">
					<xsl:call-template name="ownerId-for-textnode">
						<xsl:with-param name="text-node" select="$text-node"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($the-text) &gt; $text-node/@maxlength">
						<span key="_{$text-node/@key}" class="icp_translationMaxLength {$class}"><xsl:value-of select="substring($the-text, 1, number($text-node/@maxlength))"/></span>
						<span class="icp_translationLengthExceeded {$class}" idref="{concat($id-prefix,generate-id($text-node),translate($text-node/@key,'/','_'))}"><xsl:value-of select="substring($the-text, number($text-node/@maxlength) + 1)"/></span>
						<!-- Tooltip text -->
						<span class="icp_translationInfo">
							Max. length is <b><xsl:value-of select="$text-node/@maxlength"/></b> characters.<br />
							Actual length is <b><xsl:value-of select="string-length($the-text)"/></b> characters.<br />
							The following text will be dropped: <i>'<xsl:value-of select="substring($the-text, number($text-node/@maxlength) + 1)"/>'</i>.
						</span>
					</xsl:when>
					<xsl:otherwise>
						<span key="_{$text-node/@key}" class="icp_translationOk {$class}"><xsl:value-of select="$the-text"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="normalize-space($text-node) != ''">
				<xsl:choose>
					<xsl:when test="$tokenization-chars!=''"><xsl:call-template name="string-tokenize">
						<xsl:with-param name="string" select="$text-node/text()"/>
						<xsl:with-param name="delimiters" select="$tokenization-chars"/>
						<xsl:with-param name="style-class" select="$tokenization-class"/>
					</xsl:call-template></xsl:when>
					<xsl:otherwise><span class="{$class}"><xsl:value-of select="$text-node"/></span></xsl:otherwise></xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display-field">
		<xsl:param name="node"/>
		<xsl:if test="count($node) > 0 and $node != ''">
			<dt><xsl:value-of select="local-name($node)"/></dt>
			<dd><xsl:call-template name="display-text">
				<xsl:with-param name="text-node" select="$node"/>
			</xsl:call-template></dd>
		</xsl:if>
	</xsl:template>

	<!-- Display multiple texts -->
	<xsl:template name="joined-text">
		<xsl:param name="nodes"/>
		<xsl:param name="separator">, </xsl:param>
		<xsl:for-each select="$nodes">
			<xsl:call-template name="display-text"><xsl:with-param name="text-node" select="."/></xsl:call-template>
			<xsl:if test="position() != last()"><xsl:value-of select="$separator"/></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ownerId-for-textnode">
		<xsl:param name="text-node"/>
		<xsl:choose>
			<xsl:when test="$text-node/ancestor::Product">
				<xsl:value-of select="translate($text-node/ancestor::Product/CTN,'/','_')"/>
			</xsl:when>
			<xsl:when test="$text-node/ancestor::Catalog">
				<xsl:value-of select="$text-node/ancestor::Catalog/CatalogCode"/>
			</xsl:when>
			<xsl:when test="$text-node/ancestor::Node">
				<xsl:value-of select="$text-node/ancestor::Node/@code"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!--
		Find all nodes that are marked for translation and 
		that have a text that exceeds the specified maximum length.
		The resulting nodes will be rendered with an idref attribute that is
		equal to the id of the same rendered node in the context preview.
	-->
	<xsl:template name="collect-errors">
		<xsl:param name="item"/>
		<xsl:variable name="errors" select="$item//*[@translate='yes' and @validate='yes' and ((not(./trans/text()) and string-length(.) &gt; @maxlength) or (./trans/text() and string-length(./trans) &gt; @maxlength))]"/>
		<xsl:if test="count($errors) &gt; 0">
			<ul>
			<xsl:for-each select="$errors">
				<li idref="{concat(generate-id(),translate(@key,'/','_'))}">
					<xsl:call-template name="display-text">
						<xsl:with-param name="text-node" select="."/>
						<xsl:with-param name="id-prefix" select="'ref'"/> <!-- this avoids ending up with duplicate id's -->
					</xsl:call-template>
				</li>
			</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<!--
		Display an image that will be lazily loaded when it comes into view.
		To to this a div element is created with some meta data to load the image.
		
		Parameters:
			id					The object id, e.g. feature code or CTN
			doc-type		The Scene7 doc type to display
			index				A Scene7 index
			class				Class to put on the div wrapper
			width				The width of the image
			height			The height of the image
									You should provide at least the width or the height.
									
			img-id      The id attribute to put on the div wrapper.
			img-class		Class to put on the image after it is loaded.
			metadata		Additional meta data to put on the div wrapper.
	-->
	<xsl:template name="display-image">
		<xsl:param name="id"/>
		<xsl:param name="doc-type"/>
		<xsl:param name="index"/>
		<xsl:param name="class"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="img-id"/>
		<xsl:param name="img-class"/>
		<xsl:param name="metadata"/>
		
		<xsl:variable name="use-class">
			<xsl:text>icp_lazyload</xsl:text>
			<xsl:if test="$class">
				<xsl:text> </xsl:text><xsl:value-of select="$class"/>
			</xsl:if>
			<xsl:text> {imageData: {id:'</xsl:text><xsl:value-of select="$id"/><xsl:text>'</xsl:text>
			<xsl:text>,docType:'</xsl:text><xsl:value-of select="$doc-type"/><xsl:text>'</xsl:text>
			<xsl:if test="$index">
				<xsl:text>,index:'</xsl:text><xsl:value-of select="$index"/><xsl:text>'</xsl:text>
			</xsl:if>
			<xsl:if test="$width">
				<xsl:text>,width:</xsl:text><xsl:value-of select="$width"/>
			</xsl:if>
			<xsl:if test="$height">
				<xsl:text>,height:</xsl:text><xsl:value-of select="$height"/>
			</xsl:if>
			<xsl:if test="$img-class != ''">
				<xsl:text>,styleClass:'</xsl:text>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="in" select="$img-class"/>
					<xsl:with-param name="s"><xsl:text>'</xsl:text></xsl:with-param>
					<xsl:with-param name="r"><xsl:text>\'</xsl:text></xsl:with-param>
				</xsl:call-template>
				<xsl:text>'</xsl:text>
			</xsl:if>
			<xsl:text>}</xsl:text>
			<xsl:if test="$metadata != ''">
				<xsl:value-of select="concat(',',$metadata)"/>
			</xsl:if>
			<xsl:text>}</xsl:text>
		</xsl:variable>
		
		<div class="{$use-class}">
			<xsl:attribute name="style">
				<xsl:if test="$width">width: <xsl:value-of select="$width"/>px;</xsl:if>
				<xsl:if test="$height">height: <xsl:value-of select="$height"/>px;</xsl:if>
			</xsl:attribute>
			<xsl:if test="$img-id">
				<xsl:attribute name="id">
					<xsl:value-of select="$img-id"/>
				</xsl:attribute>
			</xsl:if>
		</div>
	</xsl:template>
	
	<!--
		Return a URL to an asset.
		This calls either p4c-asset-url or scene7-asset-url, based on the system parameter.
		
		Parameters:
			system    Specifies whether p4c or scene7 is used. (p4c | scene7)
			url       A base URL to use. [OPTIONAL]
			          For Scene7 this URL will be amended to include width and height if specified.
								For P4C the URL will be returned unmodified.
								If url is specified, doc-type, index, laco, alt and default-image will not be used.
			id        The id of the asset, e.g a CTN or feature code
			doc-type  The document type of the asset.
			doc-type-variant  The document type variant of the asset. If specified it will be used to amend the requested doc-type when using CCR.
												E.g. when doc-type is RTP and the variant is W, the requested doc type becomes RTW.
			width     The width to return; applicable for scene7 images only.
			height    The height to return; applicable for scene7 images only.
			index     The index of the asset; applicable for scene7 images only.
			laco      Language code of the asset; applicable for p4c only.
			alt       applicable for p4c only.
			default-image  1: return a default image if the requested asset is not found.
			               0: return an error message if the requested asset is not found.
	-->
	<xsl:template name="asset-url">
		<xsl:param name="system">p4c</xsl:param>
		<xsl:param name="url"/>
		<xsl:param name="doc-type"/>
		<xsl:param name="doc-type-variant"/>
		<xsl:param name="id"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="index"/>
		<xsl:param name="laco">AEN</xsl:param>
		<xsl:param name="alt">1</xsl:param>
		<xsl:param name="default-image">1</xsl:param>
		<xsl:choose>
			<xsl:when test="$system = 'p4c'">
				<xsl:call-template name="p4c-asset-url">
					<xsl:with-param name="url" select="$url"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="doc-type" select="$doc-type"/>
					<xsl:with-param name="doc-type-variant" select="$doc-type-variant"/>
					<xsl:with-param name="alt" select="$alt"/>
					<xsl:with-param name="default-image" select="$default-image"/>
					<xsl:with-param name="laco" select="$laco"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$system = 'scene7'">
				<xsl:call-template name="scene7-asset-url">
					<xsl:with-param name="url" select="$url"/>
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="doc-type" select="$doc-type"/>
					<xsl:with-param name="width"/>
					<xsl:with-param name="height"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- @deprecated -->
	<xsl:template name="p4c-asset-url">
		<xsl:param name="url"/>
		<xsl:param name="doc-type"/>
		<xsl:param name="doc-type-variant"/>
		<xsl:param name="alt">1</xsl:param>
		<xsl:param name="default-image">1</xsl:param>
		<xsl:param name="id"/>
		<xsl:param name="laco"/>

		<xsl:choose>
			<xsl:when test="$url != ''">
				<xsl:value-of select="$url"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="l-doc-type" select="substring($doc-type,1,2)"/>
				<xsl:variable name="use-id">
					<xsl:choose>
						<xsl:when test="$l-doc-type!='FI' and $l-doc-type!='FL'"><xsl:value-of select="translate($id,'_','/')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$id"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="use-doc-type">
					<xsl:choose>
						<xsl:when test="$doc-type-variant != ''">
							<xsl:choose>
								<!-- No variants available -->
								<xsl:when test="contains('HW L1 L2 L3 L4 PV SI TD U3 U4 U5 VW', $l-doc-type)">
									<xsl:value-of select="concat($l-doc-type,'P')"/>
								</xsl:when>
								<!-- S variant not available -->
								<xsl:when test="contains('RC', $l-doc-type) and $doc-type-variant='S'">
									<xsl:value-of select="concat($l-doc-type,'W')"/>
								</xsl:when>
								<!-- W variant not available -->
								<xsl:when test="contains('D1 D2 D3 D4 D5', $l-doc-type) and $doc-type-variant='W'">
									<xsl:value-of select="concat($l-doc-type,'V')"/>
								</xsl:when>
								<!-- BRP has some different variant names -->
								<xsl:when test="$l-doc-type='BR' and contains('L M S', $doc-type-variant)">
									<xsl:value-of select="concat('BL',$doc-type-variant)"/>
								</xsl:when>
								<!-- COP has only one additional variant -->
								<xsl:when test="$l-doc-type='CO' and $doc-type-variant!='P'">
									<xsl:value-of select="'COW'"/>
								</xsl:when>
								
								<xsl:when test="contains('FD FM', $l-doc-type) and $doc-type-variant!='B'">
									<xsl:value-of select="concat($l-doc-type,'S')"/>
								</xsl:when>
								
								<xsl:when test="contains('PD PM', $l-doc-type) and $doc-type-variant!='B'">
									<xsl:value-of select="concat($l-doc-type,'T')"/>
								</xsl:when>
								<!-- Only additional variant is W -->
								<xsl:when test="contains('GA MC RE SF SL', $l-doc-type) and $doc-type-variant!='P'">
									<xsl:value-of select="concat($l-doc-type,'W')"/>
								</xsl:when>
								
								<xsl:when test="contains('PB MI', $l-doc-type) and $doc-type-variant!='P'">
									<xsl:value-of select="concat($l-doc-type,'2')"/>
								</xsl:when>
								
								<xsl:when test="contains('PB MI', $l-doc-type) and $doc-type-variant='P'">
									<xsl:value-of select="concat($l-doc-type,'1')"/>
								</xsl:when>
								
								<xsl:when test="contains('PF PL PP PR PS PT', $l-doc-type) and $doc-type-variant!='P'">
									<xsl:value-of select="concat($l-doc-type,'1')"/>
								</xsl:when>
								
								<xsl:when test="contains('PF PL PP PR PS PT', $l-doc-type) and $doc-type-variant='P'">
									<xsl:value-of select="concat($l-doc-type,'2')"/>
								</xsl:when>
								<!-- Only additional variant is S -->
								<xsl:when test="contains('PI', $l-doc-type) and $doc-type-variant!='P'">
									<xsl:value-of select="concat($l-doc-type,'S')"/>
								</xsl:when>
								
								<xsl:when test="contains('TS AP', $l-doc-type) and $doc-type-variant='S'">
									<xsl:value-of select="concat($l-doc-type,'2')"/>
								</xsl:when>

								<xsl:when test="contains('AP', $l-doc-type) and $doc-type-variant='W'">
									<xsl:value-of select="concat($l-doc-type,'1')"/>
								</xsl:when>

								<xsl:when test="contains('U1 U2', $l-doc-type) and $doc-type-variant='W'">
									<xsl:value-of select="concat($l-doc-type,'V')"/>
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="concat($l-doc-type,$doc-type-variant)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$doc-type"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="concat($ccr-url,'?id=',$use-id,'&amp;alt=',$alt,'&amp;defaultimg=',$default-image,'&amp;doctype=',$use-doc-type,'&amp;laco=',$laco)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- @deprecated -->
	<xsl:template name="scene7-asset-url">
		<xsl:param name="doc-type">GAL</xsl:param>
		<xsl:param name="id"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="index"/>
		<xsl:param name="url">
				<xsl:value-of select="concat($scene7-url,'/',translate($id,'/','_'),'-',$doc-type,'-global')"/>
				<xsl:if test="$index != ''"><xsl:value-of select="concat('-',$index)"/></xsl:if>
		</xsl:param>
		
		<xsl:value-of select="$url"/>
		<xsl:text>?</xsl:text>
		<xsl:choose>
			<xsl:when test="$width or $height">
				<xsl:choose>
					<xsl:when test="($width and number($width) &lt; 100) or ($height and number($height) &lt; 100)">
						<xsl:text>$jpgsmall$</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>$jpglarge$</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$width">
					<xsl:text>&amp;wid=</xsl:text><xsl:value-of select="$width"/>
				</xsl:if>
				<xsl:if test="$height">
					<xsl:text>&amp;hei=</xsl:text><xsl:value-of select="$height"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>$jpglarge$</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
		Display a CSItem's values by concatenating the CSValueName and (if present) the UnitOfMeasure
		
		Parameters:
			csitem                The CSItem whose values should be displayed
			separator             The string to join the CSValues with
			unit-of-measure-type  Type of unit of measure to use.
					'symbol' displays the UnitOfMesaureSymbol
					'name'   displays the UnitOfMeeasureName
					'both'   displayes UnitOfMeeasureName with UnitOfMesaureSymbol appended in parenthesis
	-->
	<xsl:template name="display-csitem-values">
		<xsl:param name="csitem"/>
		<xsl:param name="separator"><xsl:text>, </xsl:text></xsl:param>
		<xsl:param name="unit-of-measure-type">symbol</xsl:param> <!-- symbol | name | both -->
		<xsl:for-each select="$csitem/CSValue">
			<xsl:sort data-type="number" select="CSValueRank"/>
			<xsl:call-template name="display-text"><xsl:with-param name="text-node" select="CSValueName"/></xsl:call-template>
			<xsl:variable name="uom" select="following-sibling::UnitOfMeasure[UnitOfMeasureCode!='']"/>
			<xsl:if test="$uom">
				<xsl:if test="$unit-of-measure-type = 'name' and normalize-space($uom/UnitOfMeasureName) != ''">
					<xsl:text>&#160;</xsl:text><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="(following-sibling::UnitOfMeasure)[1]/UnitOfMeasureName"/></xsl:call-template>
				</xsl:if>
				<xsl:if test="$unit-of-measure-type = 'symbol' and normalize-space($uom/UnitOfMeasureSymbol) != ''">
					<xsl:text>&#160;</xsl:text><xsl:call-template name="display-text"><xsl:with-param name="text-node" select="(following-sibling::UnitOfMeasure)[1]/UnitOfMeasureSymbol"/></xsl:call-template>
				</xsl:if>
				<xsl:if test="$unit-of-measure-type = 'both'">
					<xsl:if test="normalize-space($uom/UnitOfMeasureSymbol) != ''">
						<xsl:text>&#160;</xsl:text><xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="(following-sibling::UnitOfMeasure)[1]/UnitOfMeasureSymbol"/>
							<xsl:with-param name="class" select="'icp_uom'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="normalize-space($uom/UnitOfMeasureName) != ''">
						<xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="(following-sibling::UnitOfMeasure)[1]/UnitOfMeasureName"/>
							<xsl:with-param name="class" select="'icp_fulluom'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="position() != last()"><xsl:value-of select="$separator"/></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- From the XSLT Cookbook -->
	<xsl:template name="string-tokenize">
		<xsl:param name="string" select="''"/>
		<xsl:param name="delimiters" select="' &#x9;'"/>
		<xsl:param name="style-class"/>
		<xsl:param name="last-delimit"/>
		<!-- Extract a delimiter -->
		<xsl:variable name="delimiter" select="substring($delimiters,1,1)"/>
		<xsl:choose>
			<!-- If the delimiter is empty we have a token -->
			<xsl:when test="string-length($delimiter)=0">
				<span><xsl:if test="$style-class != ''">
					<xsl:attribute name="class"><xsl:value-of select="$style-class"/></xsl:attribute></xsl:if><xsl:value-of select="$string"/><xsl:value-of select="$last-delimit"/></span>
			</xsl:when>
			<!-- If the string contains at least one delimiter char we must split it -->
			<xsl:when test="contains($string,$delimiter)">
				<!-- If it starts with a delimiter we don;t need to handle the before part -->
				<xsl:if test="not(starts-with($string, $delimiter))">
					<xsl:call-template name="string-tokenize">
						<xsl:with-param name="string" select="substring-before($string,$delimiter)"/>
						<xsl:with-param name="delimiters" select="substring($delimiters,2)"/>
						<xsl:with-param name="last-delimit" select="$delimiter"/>
						<xsl:with-param name="style-class" select="$style-class"/>
					</xsl:call-template>
				</xsl:if>
				<!-- Handle the part that comes after the delimiter using the current delimiter char -->
				<xsl:call-template name="string-tokenize">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="delimiters" select="$delimiters"/>
					<xsl:with-param name="last-delimit" select="$delimiter"/>
					<xsl:with-param name="style-class" select="$style-class"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- No ocurrances of the delimiter so move ono the the next -->
				<xsl:call-template name="string-tokenize">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="delimiters" select="substring($delimiters,2)"/>
					<xsl:with-param name="last-delimit" select="$delimiter"/>
					<xsl:with-param name="style-class" select="$style-class"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="string-replace">
		<xsl:param name="in"/>
		<xsl:param name="s"/>
		<xsl:param name="r"/>
		
		<xsl:choose>
			<xsl:when test="$s and contains($in,$s)">
				<xsl:value-of select="substring-before($in,$s)"/>
				<xsl:value-of select="$r"/>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="in" select="substring-after($in,$s)"/>
					<xsl:with-param name="s" select="$s"/>
					<xsl:with-param name="r" select="$r"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$in"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="locale-to-languagecode">
		<xsl:param name="locale"/>
		<xsl:choose>
			<xsl:when test="$language-codes[@locale=$locale]/@code != ''">
				<xsl:value-of select="$language-codes[@locale=$locale]/@code"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'AEN'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
