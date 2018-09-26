/*
	VideoPlayerType
*/
var VideoPlayerType = {VIEW_GALLERY: 0, VIEW_360: 1, VIEW_360_LEGACY: 2, VIEW_VIDEO_PRODUCT: 3, VIEW_VIDEO_FEATURE: 4};

/*
	VideoPlayer class
	
	params hash may contain the following items:
		container			DOM element to insert the video player into.
		styleClass		class attribute to put on the video player container.
		closeLabel		label of the close button.
*/
function VideoPlayer(id, params) {
	this.id = id || ("vplayer" + now());
	this.playerId = this.id + "_swf";
	this.params = params || {};
	if ($("#"+this.id).length == 0)
		this._create();
}

/* private */ VideoPlayer.prototype._create = function() {
	if ($("#"+this.id).length > 0) {
		// Remove previous player
		$("#"+this.id).remove();
	}
	var container;
	if (typeof(this.params.container) != "undefined") {
		container = $(this.params.container);
	} else {
		container = $("body");
	}
	var html = "<div id=\""+this.id+"\" style=\"display:none;\"";
	if (this.params.styleClass) {
		html += " class=\""+this.params.styleClass+"\"";
	}
	html += "><div class=\""+this.id+"_hlp\"><p onclick=\"VideoPlayer.destroy('"+this.id+"')\" class=\"closeVideoPlayer\"><a href=\"javascript:void(0)\">"
			 + (this.params.closeLabel || "close") + "</a></p>"
			 + "<div id=\""+this.id+"_content\">&nbsp;</div>"
			 + "</div></div>";
	container.prepend(html);
}

VideoPlayer.prototype.show = function() {
	$("#"+this.id).show();
}

VideoPlayer.prototype.hide = function() {
	$("#"+this.id).hide();
}

VideoPlayer.prototype.destroy = function() {
	var playerCont = $("#"+this.playerId);
	// player container may be a div (when flowplayer is visible)
	// or an object (when a Scene7 player is visible.)
	if (playerCont.is("div") && playerCont.flowplayer().size() > 0) {
		var player = playerCont.flowplayer(0);
		try {
			player.stopBuffering();
			player.stop();
			player.unload();
			player.close();
		} catch(e) {}
	}
	$("#"+this.id).remove();
}

VideoPlayer.prototype.load = function(type, locale, ctn, params) {
	switch (type) {
		case VideoPlayerType.VIEW_GALLERY:
			this.loadGalleryViewer(ctn, locale, params);
			break;
		case VideoPlayerType.VIEW_360:
			this.load360Viewer(ctn, locale, params);
			break;
		case VideoPlayerType.VIEW_360_LEGACY:
			this.load360LegacyViewer(ctn, locale, params);
			break;
		case VideoPlayerType.VIEW_VIDEO_PRODUCT:
			this.loadVideoViewer(ctn, locale, params);
			break;
		case VideoPlayerType.VIEW_VIDEO_FEATURE:
			this.loadVideoViewer(ctn, locale, params);
			break;
	}
}

VideoPlayer.prototype.loadGalleryViewer = function(ctn, locale, params) {
	var flashVars = this.getCommonFlashVars();
	flashVars.config = "PhilipsConsumer/GalleryConfig";
	flashVars.instancename = "PhilipsGalleryViewer";
	
	var ctnNorm = ctn.replace(/\//g, "_")
	var galImage = ICP.instance.getAsset(ctnNorm, 'GAL');
	if (galImage != null) {
		flashVars.image = galImage.url.substring(galImage.url.indexOf("PhilipsConsumer"));
	} else { // Fall back to default path
		flashVars.image = "PhilipsConsumer/" + ctnNorm + "-GAL-global";
	}
	flashVars.initialFrame = typeof(params.initialAssetIndex) != "undefined" ? params.initialAssetIndex : 0;
	flashVars.localeXMLURL = this.getScene7LocaleXmlUrl("PhilipsGalleryViewer", locale);
	
	var params = this.getCommonSwfParams();
	
	this.loadPlayerContent("http://images.philips.com/skins/PhilipsConsumer/SWFs/PhilipsGenericZoom.swf",
													920, 535, "8.0.0", flashVars, params, {});
}

VideoPlayer.prototype.load360Viewer = function(ctn, locale, params) {
	var flashVars = this.getCommonFlashVars();
	flashVars.config = "PhilipsConsumer/SpinConfig";
	flashVars.instancename = "Philips360Viewer";

	var ctnNorm = ctn.replace(/\//g, "_")
	var galImage = params.href;
	if (typeof galImage !== "undefined") {
		flashVars.image = galImage.substring(galImage.indexOf("PhilipsConsumer"));
	} else { // Fall back to default path
		flashVars.image = "PhilipsConsumer/" + ctnNorm + "-P3D-global";
	}
	flashVars.spinTime = 150;
	flashVars.localeXMLURL = this.getScene7LocaleXmlUrl("PhilipsGallerySpinViewer", locale);
	
	var params = this.getCommonSwfParams();
	
	this.loadPlayerContent("http://images.philips.com/skins/PhilipsConsumer/SWFs/PhilipsGenericSpin.swf",
													920, 535, "6.0.0", flashVars, params, {});
}

VideoPlayer.prototype.load360LegacyViewer = function(ctn, locale, params) {
	var flashVars = {
		xmlfile: ""
	};
	
	var swfParams = {
			wmode: "transparent"
		, bgcolor: "#FFFFFF"
		, quality: "best"
	};
	
	this.loadPlayerContent(params.href, 650, 480, "6.0.0", flashVars, swfParams, {});
}

VideoPlayer.prototype.loadVideoViewer = function(ctn, locale, params) {
	var ctnNorm = ctn.replace(/\//g,"_");
	//var movieAsset = ICP.instance.getAsset(ctnNorm, params.assetType);
	// The URL in the asset may point to Scene7, which is incorrect.
	// Since there seems to be no feasible way to get the correct CCR URL, we construct
	// the URL here.
	var movieUrl = ICP.instance.config.ccrGetUrl
							 + "?id=" + ctn
							 + "&doctype=" + params.assetType
							 + "&laco=" + params.assetLangCode;
	// The consumer website's player can't be used, because it needs an XML configuration file.
	// We use the free flowpayer instead.
	var contentContainer = $("#"+this.id+"_content");
	contentContainer.empty().prepend("<div id=\""+this.playerId+"\" style=\"margin: auto;\"></div>");
	
	$("#"+this.playerId).flowplayer({
			src: this.params.playerUrl,
			width: 920,
			height: 535
		},
		{
		clip: {
			url:escape(movieUrl)
		},
		playlist: [
			{url:escape(movieUrl)}
		],
		canvas: {
			backgroundColor: "#ffffff",
			backgroundGradient: "none",
			backgroundImage: "",
			width: 920,
			height: 535
		},
		screen: {
			width: 660,
			height: 446
		},
		plugins: {
			 controls: {
					height: 30,
					opacity: 1.0,
					fullscreen: false,
					time: false,
					mute: false,
					
					backgroundColor: '#ffffff',
					backgroundGradient: 'none',
					borderRadius: '0px',
					bufferColor: '#8081A3',
					bufferGradient: 'low',
					buttonColor: '#55566D',
					buttonOverColor: '#55566D',
					progressColor: '#55566D',
					progressGradient: 'middle',
					scrubberHeightRatio: 0.6,
					scrubberBarHeightRatio: .4,
					sliderColor: '#dddddd',
					sliderGradient: 'none',
					tooltipColor: '#5F747C',
					tooltipTextColor: '#ffffff',
					volumeSliderColor: "#55566D",
					volumeSliderGradient: 'middle'
			 }
		}
	});
	/* Below is the consumer website method to show the player
	var lang = locale.substring(0,2);
	var country = locale.substring(3,2);
	var id = ctn.replace(/\//g,"_");
	var flashVars = {};
	flashVars.xmlLocation = "http://www.consumer.philips.com/consumer/en/gb/consumer/cc/_productid_"
						+ id + "_" + country + "_CONSUMER"
						+ "/_proxyBusterOff_true/_startVideoId_product-"
						+ id + "_" + country + "_CONSUMER" + "-PRM-" + locale + "-001"
						+ "/_videoType_product/p/consumer/dataservices/productVideosUnCachedXmlOutput/i/videosXml.xml";
	flashVars.country = country.toLowerCase();
	flashVars.language = lang;
	
	var params = {};
	params.quality = "high";
	params.bgColor = "#ffffff";
	params.wmode = "opaque";
	
	this.loadPlayerContent("http://images.philips.com/skins/PhilipsConsumer/SWFs/PhilipsGenericSpin.swf",
													920, 535, "6.0.0", flashVars, params, {});	
	*/
}

VideoPlayer.prototype.getScene7LocaleXmlUrl = function(type,locale) {
	return "http://s7info2.scene7.com/s7info/data/Philips%20Consumer/"+type+"/"+locale;
}

VideoPlayer.prototype.getCommonFlashVars = function() {
	var vars = {};
	vars.popupShowFriendly = false;
	vars.contentRoot = "http://images.philips.com/skins";
	vars.swHighlightColor = "0xa0a2b0";
	vars.displayCloseButton = false;
	vars.serverUrl = "http://images.philips.com/is/image/";
	vars.swBorderColor = "0xe0e0e8";
	vars.codeRoot = "http://images.philips.com/is-viewers-3.8/flash"
	vars.persistence = 0;
	vars.outerBorder = false;
	return vars;
}

VideoPlayer.prototype.getCommonSwfParams = function() {
	var params = {};
	params.menu = false;
	params.quality = "high";
	params.scale = "noscale";
	params.salign = "LT";
	params.bgcolor = "#ffffff";
	params.allowScriptAccess = "always";
	params.swliveconnect = true;
	params.wmode = "opaque";
	
	return params;
}

VideoPlayer.prototype.loadPlayerContent = function(playerUrl, width, height, minVersion, flashVars, params, attributes) {
	var contentContainer = $("#"+this.id+"_content");
	var swfId = this.id + "_swf";
	contentContainer.empty().prepend("<div id=\""+swfId+"\">&nbsp;</div>");
	swfobject.embedSWF(playerUrl, swfId, width, height, minVersion, false, flashVars, params, attributes);
}

VideoPlayer.destroy = function(id) {
	new VideoPlayer(id).destroy();
}
