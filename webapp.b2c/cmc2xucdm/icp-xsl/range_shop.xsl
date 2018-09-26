<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="range_generic.xsl"/>
  
	<xsl:variable name="rangedata" select="document('rangedata.xml')/ranges"/>
	
	<xsl:template name="headers-range-shop">
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/range/range_shop.css"/>
		<!--xsl:comment>[if IE]&gt;
			<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/range/range_shop_ie.css" /&gt;</xsl:text>
		&lt;![endif]</xsl:comment-->
		<link rel="stylesheet" type="text/css" href="{$icp-host}web/drhm/css/generic.css"/>
		<link rel="stylesheet" type="text/css" href="{$icp-host}web/drhm/css/drstyle.css"/>

		<xsl:comment>[if IE 6]&gt;
		&lt;style type="text/css"&gt;
		#content #productbox .product { height: 228px; }
		#categorysidebar { margin-right: 5px; }
		&lt;/style&gt;
		&lt;![endif]</xsl:comment>
		<xsl:comment>[if gte IE 6]&gt;
		&lt;style type="text/css"&gt;
		#content #productbox .product .checkbox { bottom: 17px; }
		.diffitems ul { height: 56px; }
		&lt;/style&gt;
		&lt;![endif]</xsl:comment>

		<!--script type="text/javascript" src="{$icp-host}js/range/range_shop.js"></script-->
		<script type="text/javascript" src="{$icp-host}web/drhm/js/jquery.cluetip.js"></script>
		<script type="text/javascript" src="{$icp-host}web/drhm/js/jquery.overlay.min.js"></script>
		<script type="text/javascript" src="{$icp-host}js/range/range_shop.js"></script>
		<script type="text/javascript"><![CDATA[
		// Page-level global variable
		var q = true;
		// Global popUp function (minified/obfuscated)
		(function($){var B=null;var C=50;var D=50;var E=location.protocol+'//'+location.hostname;window.popUp=function(b,c,d,f){var g=b;if(b.constructor!=String){b=b.href;var h=$(b).attr('title');if(h===''){h=$(b).text()}g=(h)?h:b}if(((arguments.length>4)&&!arguments[4])||((location.protocol=='https:')&&/^http:/i.test(b))||($('.popup_window_wrapper').length==0)){if(B&&!B.closed){B.close()}B=self.open(b,c,'width='+d+',height='+f+',resizable=yes,status=yes,screenX='+D+',screenY='+C+',top='+C+',left='+D+',scrollbars=yes')}else{var i=($.browser.msie&&($.browser.version<=6));var j=(arguments.length>4)&&arguments[4];var k=(j&&$.fn.overlay)?10003:1003;window.popUp.zIndex=(window.popUp.zIndex)?window.popUp.zIndex+1:k;var l=d;var m=d+52;var n=f+71;var o=f+6;var p=d-10;var q=d;var r=f;if(i){m+=6;l+=4;o+=4;p+=4;q+=4;r+=4}var s='popUp_'+c;var t=function(){window.popUp[c]=false;$('#'+s).slideUp('fast',function(){if(j&&$.fn.overlay){$(this).hideOverlay(function(a){$(a).remove()})}$(this).remove()})};if(window.popUp[c]){var u=$('#'+s)[0];var v=$('.popup_content_iframe',u);var w=$('div.popup_window_wrapper:not([id]) .popup_content_iframe').clone();w.attr({width:v.attr('width'),height:v.attr('height')});v.replaceWith(w[0])}else{var u=$('div.popup_window_wrapper:not([id])').clone().attr('id',s).css({width:m+'px',height:n+'px',top:C+'px',left:D+'px'})[0];$('.popup_title_bar',u).width(l).find('.popup_title_header').width(d).mousedown(function(){$('#'+s).css('z-index',++window.popUp.zIndex);return true});$('a.popup_close_button_link',u).one('click',function(){t();return false});$('.popup_shadow2,.popup_shadow8',u).height(o);$('.popup_shadow5',u).width(p);$('.popup_content_wrapper',u).css({width:q+'px',height:r+'px'});var x=$('iframe.popup_content_iframe',u).attr({width:d,height:f}).text();var y={handle:'.popup_title_header',opacity:($.browser.msie)?1:0.85};if($.fn.draggable){$('.popup_title_header',u).css('cursor','move')}$(u).prependTo('body');if($.fn.overlay&&(i||j)){if(j&&j.constructor==Boolean){j={css:{backgroundColor:'#FFFFFF',opacity:0.6}}}var z=$.extend(true,{drag:y},{modal:j});$(u).overlay(z).showOverlay()}else{if(j&&!$.fn.overlay&&window.console){console.warn('popUp in modal mode requires the jQuery overlay plugin.')}if($.fn.draggable){$(u).draggable(y)}$(u).show()}window.popUp[c]=true}self.scrollTo(0,0);var A=$('.popup_content_iframe',u)[0].contentWindow;A.document.open();A.document.write(x);A.document.close();if((b.substr(0,E.length)==E)||!/^https?:/i.test(b)){$('.popup_content_iframe',u).one('load',function(){try{var a=this.contentWindow.document.title;if(a!==''){$('.popup_title_header',u).text(a)}this.contentWindow.close=function(){t()}}catch(e){}})}A.location.replace(b);$(u).css('z-index',window.popUp.zIndex).find('.popup_title_header').text(g).attr('title',b)}}})(jQuery);
		// Function to hide/show info
		function hideText(id) {
			jQuery('#'+id).toggle();
		}
		// Function to disable submit button after it has been clicked once already to prevent multiple order submission on CheckoutPayment and ConfirmOrder
		function disableButton(button) {
			//jQuery(button).hide();
		}
		]]></script>

	</xsl:template>

	<xsl:template match="Nodes|Products" mode="range-shop">
		<div id="icp_view_shop" class="icp_view">
			<div id="icp_content_shop" class="icp_content">
				<xsl:apply-templates select="Node[position() &lt;= $max-items]" mode="l-rng-shop"/>
			</div>
		</div>
	</xsl:template>
  
	<xsl:template match="Node" mode="l-rng-shop">
		<div class="icp_container {{id:'{@code}'}}" id="{@code}_container_shop">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			<div id="main">
				<div id="p-body">
					<div id="p-body-wrapper">
						<div class="p-clearfix" id="p-body-innerwrapper">
							<div id="dr_CategoryProductList" class="dr_Content">
								<div class="content">
									<xsl:variable name="bg-image" select="$rangedata/range[@code=current()/@code]/assets/asset[@purpose='main background']/@url"/>
									<div class="contentTop">
										<xsl:if test="$bg-image != ''">
											<xsl:attribute name="style">
												<xsl:text>background-image: url('</xsl:text>
												<xsl:value-of select="$icp-host"/>
												<xsl:value-of select="$bg-image"/>
												<xsl:text>');</xsl:text>
											</xsl:attribute>
										</xsl:if>
										<div class="overlay">
											<h1><xsl:call-template name="display-text">
												<xsl:with-param name="text-node" select="Name"/>
											</xsl:call-template></h1>
											<h2 class="blurb"><xsl:call-template name="display-text">
												<xsl:with-param name="text-node" select="WOW"/>
											</xsl:call-template></h2>
											<xsl:if test="SubWOW">
												<p class="blurb"><xsl:call-template name="display-text">
													<xsl:with-param name="text-node" select="SubWOW"/>
												</xsl:call-template></p>
											</xsl:if>
											<p><xsl:call-template name="display-text">
												<xsl:with-param name="text-node" select="MarketingTextHeader"/>
											</xsl:call-template></p>
											<div class="featureoverlays">
												<xsl:apply-templates select="Filters/Purpose[@type='Base']/Features/Feature" mode="filter-feature-highlights">
													<xsl:sort select="@rank" data-type="number"/>
												</xsl:apply-templates>
											</div>
										</div>
									</div>

									<xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType='assigned']"/>
								</div>
							</div>
						</div>
					</div>
					<div id="p-body-bottomwrapper"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="Feature[position() &lt;= 2]" mode="filter-feature-highlights">
		<!-- Apply corresponding product feature -->
		<xsl:apply-templates select="(../../../../ProductRefs/referencedproducts/Product/Feature[FeatureCode=current()/@code])[position() = 1]" mode="product-feature-highlight"/>
	</xsl:template>

	<!-- The feature text is not rendered using display text,
		because for a range this text is not part of the translation -->
	<xsl:template match="Feature" mode="product-feature-highlight">
		<div class="basefeature">
			<div class="arrow"><img src="{$icp-host}web/drhm/images/cat_series_right_arrow.png" border="0" /></div>
			<xsl:value-of select="FeatureName"/>
			<div class="additional"><xsl:value-of select="FeatureLongDescription"/></div>
		</div>
	</xsl:template>
	
	<xsl:template match="ProductRefs/ProductReference[@ProductReferenceType='assigned']">
		<div class="products">
			<div class="contentmiddle">
				<div class="productbox">
					<div class="extendbox">
						<div class="head"><span class="compare"><a href="javascript:void(0)" onclick="compareLink(this); return false;">You´ve selected <span class="num_selected">0</span> items to compare</a></span></div>
						<div class="compareOverlay"></div>
						<form>
							<xsl:choose>
								<xsl:when test="../referencedproducts">
									<xsl:apply-templates select="../referencedproducts/Product"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="CTN|Product/@ctn"/>
								</xsl:otherwise>
							</xsl:choose>
						</form>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="ProductReference/CTN|ProductReference/Product/@ctn">
		<div class="product">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="."/>
				<xsl:with-param name="height" select="75"/>
				<xsl:with-param name="doc-type" select="'GAL'"/>
				<xsl:with-param name="class" select="'thumb'"/>
			</xsl:call-template>
			<h4><a href="javascript:void(0)"><xsl:value-of select="CTN"/></a></h4>
		</div>
	</xsl:template>
	
	<xsl:template match="referencedproducts/Product">
		<xsl:variable name="csitems" select="ancestor::Node/Filters/Purpose[@type='Differentiating']/CSItems/CSItem"/>

		<div class="product">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="CTN"/>
				<xsl:with-param name="doc-type" select="'GAL'"/>
				<xsl:with-param name="height" select="75"/>
				<xsl:with-param name="class" select="'thumb'"/>
			</xsl:call-template>
			
			<h4><a href="javascript:void(0)" title="{CTN}"><xsl:value-of select="ProductName"/></a></h4>
			<p class="price"><span class="dr_actualPrice">€ 0.00</span>&#160;<span class="lightgray">incl. VAT</span></p>
			<div class="diffitems">
				<table class="csitem">
					<xsl:apply-templates select="$csitems[position() &lt;= 2]" mode="filter-csitem">
						<xsl:with-param name="product-csitems" select="CSItem"/>
					</xsl:apply-templates>
				</table>
			</div>
			<div class="diffmore">
				<span><a class="load-local" rel="#diffmore_{generate-id()}">More&#160;<img src="{$icp-host}web/drhm/images/arrow_bottom_right.gif" /></a></span>
				<div id="diffmore_{generate-id()}" style="display: none;">
					<table class="csitem">
						<xsl:apply-templates select="$csitems" mode="filter-csitem">
							<xsl:with-param name="product-csitems" select="CSItem"/>
						</xsl:apply-templates>
					</table>
				</div>
			</div>
			<div class="checkbox"><input type="checkbox" name="product{position()}" value="compare" onclick="updateCompare(this, '32PFL7603D%2F12');" />Compare&#160;<img src="{$icp-host}web/drhm/images/corner_bot_right_new.gif" /></div>
		</div>
	</xsl:template>
	
	<xsl:template match="CSItem" mode="filter-csitem">
		<xsl:param name="product-csitems"/>
		<xsl:variable name="p-item" select="$product-csitems[CSItemCode=current()/@code]"/>
		<xsl:if test="$p-item">
			<tr>
				<td>-</td>
				<td>
					<xsl:value-of select="$p-item/CSItemName"/>
					<xsl:text>:&#160;</xsl:text>
					<xsl:value-of select="$p-item/CSValue/CSValueName[1]"/>
					<xsl:if test="$p-item/UnitOfMeasure">
						<xsl:text>&#160;</xsl:text>
						<xsl:value-of select="$p-item/UnitOfMeasure[1]/UnitOfMeasureSymbol"/>
					</xsl:if>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
