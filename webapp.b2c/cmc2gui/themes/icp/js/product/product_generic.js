/*
	Load the carousel viewer.
	If the GAL imageset is available from Scene7 we display the Scene7 flash carousel.
	Otherwise we display up to 5 images of doc types that correspond to the GAL imageset, retrieving
	them from CCR.
*/
function icp_load_carousel_viewer(view) {
	ICP.instance.logger.debug("Enter icp_load_carousel_viewer()");
	var targetView = view || ICP.instance.currentView;
	var carouselId = "carouselViewer_"+targetView+"_"+ICP.instance.getItemInViewNormalized();
	if (typeof $("#"+carouselId).data("loaded") === "undefined") {
//		var asset = ICP.instance.getAsset(ICP.instance.getItemInViewNormalized(view), 'GAL');
		var galImage;
//		if (asset != null) {
//			galImage = asset.url;
//		} else {
			galImage = ICP.instance.getItemInViewNormalized(view) + "-GAL-global";
//		}
		ICP.instance.scene7AssetExists(galImage,
			function() {			// The asset exists -> show the carousel viewer from Scene7
				//icp_load_carousel_mock(view);
				icp_load_carousel_scene7(view);
			},
			function() {			// The asset does not exist -> show a mock up version if the carousel
				icp_load_carousel_mock(view);
			}
		);
	}
	ICP.instance.logger.debug("Leave icp_load_carousel_viewer()");
}

function icp_load_carousel_scene7(view) {
	ICP.instance.logger.debug("Enter icp_load_carousel_scene7()");
	var targetView = view || ICP.instance.currentView;
	var carouselId = "carouselViewer_"+targetView+"_"+ICP.instance.getItemInViewNormalized();
	var flashvars = {};
	flashvars.config="PhilipsConsumer/CarouselConfig";
	flashvars.popupShowFriendly="false";
	flashvars.contentRoot="http://images.philips.com/skins";
	flashvars.instancename="PhilipsCarouselViewer";
	flashvars.swHighlightColor="0xa0a2b0";
	flashvars.serverUrl="http://images.philips.com/is/image/";
	flashvars.codeRoot="http://images.philips.com/is-viewers-3.8/flash";
	flashvars.swBorderColor="0xe0e0e8";
	
//	var galImage = ICP.instance.getAsset(ICP.instance.getItemInViewNormalized(), 'GAL');
//	if (galImage != null) {
//		flashvars.image = galImage.url.substring(galImage.url.indexOf("PhilipsConsumer"));
//	} else {
		flashvars.image = "PhilipsConsumer/"+ICP.instance.getItemInViewNormalized()+"-GAL-global";
//	}
	var params = {};
	params.quality = "high";
	params.align = "center";
	params.wmode = "transparent";
	params.bgcolor = "#ffffff";
	params.allowScriptAccess = "always";
	var attributes = {};
	
	swfobject.embedSWF(
		"http://images.philips.com/skins/PhilipsConsumer/SWFs/PhilipsGenericZoom.swf",
		carouselId,
		"372",
		"100",
		"6.0.0",
		false,
		flashvars,
		params,
		attributes
	);
	ICP.instance.logger.debug("Leave icp_load_carousel_scene7()");
}

function icp_load_carousel_mock(view) {
	ICP.instance.logger.debug("Enter icp_load_carousel_mock()");
	var targetView = view || ICP.instance.currentView;
	var carouselId = "carouselViewer_"+targetView+"_"+ICP.instance.getItemInViewNormalized();
	var container = $("#"+carouselId)[0];
	// These are the doc types in the GAL imageset
	var types = ['PWS','RTS','TLS','TRS','UWS','_FS','FTS','RCS','DPS','D1S','D2S','D3S','D4S','D5S','PA4','TS2','AP2','MI2','UPS','U1S','U2S'];
	
	var count = $(container).children("img").length;
	// Insert the div placeholders if we haven't done so earlier
	if ($(container).children("div").length == 0) {
		var t;
		while (t = types.shift()) {
			var metadata = "{imageData: {id: '"+ICP.instance.getItemInView()+"', width: 50, docType: '"+t+"', index: '001'}}";
			$("<div style=\"display:inline;\" class=\"icp_lazyload "+metadata+"\"/>").appendTo(container);
		}
	}
	// Let the imageLoader plugin load the images
	$(container).children("div.icp_lazyload").imageLoaderLoad({
		  assetTypes: ICP.instance.assetIndex
		, ccrUrl : ICP.instance.config.ccrGetUrl
		, ccrIsSecure : ICP.instance.config.ccrIsSecure
		, ccrMagic : ICP.instance.config.ccrMagic
		, maxNumImages: 6-count			// Load remaining images
		, scene7Disabled: true			// No use in trying Scene7; if Scene7 had the GAL we wouldn't be here.
		, placingPolicy: 'replace'	// Replace the placeholder with an img
		, abortCurrent: false				// Let any current loading queues finish
		, ownerId: ICP.instance.getItemInView()
		, callback: function() {
				// Mark the carousel as loaded
				$(container).data("loaded", true);
		  }
	});
	ICP.instance.logger.debug("Leave icp_load_carousel_mock()");
}

function icp_open_gallery_viewer( scene7AssetId, initialAssetIndex ) {
	var player = new VideoPlayer("icp_product_video_player", {
										container: ICP.instance.selectInView("").get(0),
										styleClass: "icp_prd_vid_player_"+ICP.instance.currentView,
										playerUrl: ICP.instance.config.icpHost + ICP.instance.config.flowPlayerUrl
									});
	player.load(VideoPlayerType.VIEW_GALLERY, ICP.instance.getLocale(), ICP.instance.getItemInView(), {"initialAssetIndex": initialAssetIndex});
	// Scroll to the top of the item
	ICP.instance.getViewContainer().children(".icp_content").scrollTop(0);
	player.show();
}
