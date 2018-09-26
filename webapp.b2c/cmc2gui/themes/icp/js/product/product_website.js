function icp_init_view_product_website() {
	ICP.instance.logger.debug("Enter icp_init_view_product_website()");

	// Initialization from lib_global.js
	ICP.instance.logger.debug("+Calling icp_init_view_product_website_global()");
	icp_init_view_product_website_global();
	ICP.instance.logger.debug("-Calling icp_init_view_product_website_global()");

	// Postponed initialization from global.js
	_page.switchHandler = EplatformSwitchhandler
	today = new Date();
	months = new Array("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
	year = today.getFullYear();
	years  = new Array(year-5,year-4, year-3, year-2, year-1, year, year+1, year+2, year+3, year+4, year+5);
	MM_reloadPage(true);
	
	// Override some configuration parameters for unneeded things
	_page.externalUrlPrefix.metrixLab = "";
	_page.externalUrlPrefix.stockQuotes = "";
	_page.updateStockQuote = function() {};
	_page.searchHandler = function () {};
	_page.switchHandler = function () {};
	_page.eSurvey.include = function() {};
	_page.loadOmniture = false;

	// buy popup layer
	//$("div.buy").click(function() { loadBuyLayer(this); });
	// Tell a friend popup layer
	//$("div.tellAFriend").click(function() { loadLayer("tellAFriend");window.scrollTo(0,170); });
	// Green product popup layer
	$("a.greenproduct").click(function() { loadLayer("greenProduct"); });
	// newsletter popup layer
	//$("li.newsletter").click(function() { loadLayer("newsLetter"); });
	// if KBAs are clicked, move to features tab and show relevant KBA
	$(".icp_p-features .p-features-img").click(function() { changeTabAndShowFeature(this); });
	$(".icp_p-features .p-feature-link").click(function() { changeTabAndShowFeature(this); });

	// tab switcher
	ICP.instance.logger.debug("+tab switcher");
	$(".icp_tab_pce_productdetails li").click(function(obj) {
		if($(".popuplayer2").length > 0)
			$(".popuplayer2").empty();
		if($("#icp_product_video_player").length > 0)
			VideoPlayer.destroy("icp_product_video_player");
		if(!$(this).hasClass("current") && $(this).attr("id") != "back" && $(this).attr("id") != "support" && $(this).attr("id") != "experience") {
			ICP.instance.selectInView(".icp_tabscontent").children().addClass("icp_hidden");
			$(".popuplayer").hide();
			ICP.instance.selectInView(".icp_tab_pce_productdetails > li").removeClass("current");
			$(this).addClass("current");
			ICP.instance.selectInView(".icp_" + $(this).attr("id") + "_content").removeClass("icp_hidden");
		}
	});
	ICP.instance.logger.debug("+tab switcher");

	// specification mainbar dropdown funcionality
	ICP.instance.logger.debug("+mainbar dropdown");
	$("a.expandlt").click(function() {
		$(this).toggleClass("lselected");
		$(this).parent().siblings("dd").children("div.hidden").hide();
		$(this).parent().siblings("dd").children("a.viewmore").show();
		$(this).parent().siblings("dd").children("a.alternatetxt").hide();
		$(this).parent().siblings("dd").slideToggle("slow");
	});
	$("a.viewmore").click(function() {
		$(this).parent().children("a").toggleClass("vselected");
		$(this).parent().children("a").toggle();
		$(this).siblings("div.hidden").slideToggle("slow");
	});
	ICP.instance.logger.debug("-mainbar dropdown");
	
	/**** ICP specific ****/

	// Register item in view callback
	ICP.instance.registerCallback("website", "updateItemInView", icp_update_item_in_view_prd_website);

	if (ICP.instance.currentView === "website")
		icp_update_item_in_view_prd_website(ICP.instance.getItemInView("website"));

	ICP.instance.logger.debug("Leave icp_init_view_product_website()");
}

function showReviews() {
}

function showSpecs() {
}

function showFeatures() {
}

function showSpecFeature(obj) {
	var className = obj.className;
	if(className == 'featureTable_pce close'){
		$(obj).parent().parent().parent().parent().removeClass('hidden');
		$(obj).parent().parent().parent().parent().addClass('pce_featureTable');
		$(obj).removeClass('featureTable_pce close');
		$(obj).addClass('featureTable_pce open');
	}
	if(className == 'featureTable_pce open'){
		$(obj).parent().parent().parent().parent().removeClass('pce_featureTable');
		$(obj).parent().parent().parent().parent().addClass('hidden');
		$(obj).removeClass('featureTable_pce open');
		$(obj).addClass('featureTable_pce close');
	}
}

function changeTabAndShowFeature(obj) {
	if( $("#icp_product_video_player").length > 0 )
		VideoPlayer.destroy("icp_product_video_player");
	ICP.instance.selectInView(".icp_tabscontent").children().addClass("icp_hidden");
	ICP.instance.selectInView(".icp_tab_pce_productdetails > li").removeClass("current");
	ICP.instance.selectInView(".icp_tab_features").addClass("current");
	ICP.instance.selectInView(".icp_tab_features_content").removeClass("icp_hidden");

	var featureId = "fif" + obj.id.substring(3);
	var kbaId = $("#"+featureId).parents("table")[0].id;
	openKBA(kbaId);
	var featureTop = $("#"+featureId).offset().top;
	ICP.instance.getViewContainer().children(".icp_content").scrollTop(featureTop);
}

function openKBA(kbaId) {
	ICP.instance.selectInView(".pce_features table").removeClass('pce_featureTable')
	                                                .addClass('hidden')
	                                                .find(" a").removeClass('open')
	                                                           .addClass('close');
	ICP.instance.selectInView("#"+kbaId).removeClass('hidden')
	                                    .addClass('pce_featureTable')
	                                    .find(" a").removeClass('close')
	                                               .addClass('open');
}

function checkEnter(e){
}

var focuscount = 0;
function clearfield(obj) {
	formfield = obj;
	if(focuscount > 0) {
		formfield.select();
	} else {
		focuscount += 1;
		formfield.value = "";
	}
}
function submitIfNotEmpty(){
}

function loadLayer(pageToLoad) { /*
	switch(pageToLoad) {
		case "tellAFriend":
			this.urlToLoad = "/consumer/common/fragments/pLayer_tellAFriend.jsp";
		break;
		case "greenProduct":
			this.urlToLoad = "/consumer/catalog/pageitems/pi_GreenProductItem.jsp";
		break;
		case "newsLetter":
			this.urlToLoad = "/consumer/common/fragments/pLayer_newsLetter.jsp";
		break;
	}
	$("#movieLayer").remove();
	$("#buyLayer").remove();
	$("#viewLayer360").remove();
	var popupLyr = $(".popuplayer");
	if($(popupLyr).length > 0) {
		popupLyr.remove();
	}
	$("body").append("<div class=\"popuplayer\" id=\"popuplyr\"></div>");
	$(".popuplayer").load(this.urlToLoad,
		{
		productId:ICP.instance.getItemInViewNormalized()+"_"+ICP.instance.getCountry()+"_CONSUMER",
		catalogType:"CONSUMER",
		country:ICP.instance.getCountry().toLowerCase(),
		language:ICP.instance.getLanguage(),
		privacyUrl:""
		}
	)
	if($.browser.safari) {
		$( function() { $(".popuplayer").show(); } );
	} else {
		$(".popuplayer").fadeIn(50);
	}
	centerPosition('.popuplayer');
*/}
function playMovie(pMovieType) { /*
	$("#videoPlayerContainer").fadeIn("fast");
	switch(pMovieType) {
		case "pProductMovie":
			$("#p-360viewContent").hide();
			$("#videoPlayerContainer").css({height:522});
			$("#p-videoPlayerContent").show();
		break;
		case "p360view":
			$("#p-videoPlayerContent").hide();
			$("#videoPlayerContainer").css({height:580});
			$("#p-360viewContent").show();
		break;
	}
	var scrollPosTop = getScrollPosTop();
	if(scrollPosTop > 180)
	{
		window.scrollTo(0,80);
	}
*/}
function closeMovie() {
	//$("#videoPlayerContainer").fadeOut("fast")
}
function changeGalleryImage(imageToReplace, replacementImage) {
//	$("#" + imageToReplace).fadeOut("fast", function() {
//		$("#" + imageToReplace).attr("src",replacementImage).fadeIn("slow");
//	});
}
function submitForm(theform) {
}
function loadBuyLayer(obj,obj1,obj2) {
}
function loadDownloadLayer(obj) {
}
function openGalleryViewer( scene7AssetId, initialAssetIndex ) {
	icp_open_gallery_viewer(scene7AssetId, initialAssetIndex);
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
function icp_update_item_in_view_prd_website(itemId) {
	ICP.instance.logger.debug("Enter icp_update_item_in_view_prd_website()");

	// Activate 360 view button if present
	var threeSixtyButton = ICP.instance.selectInView(".threeSixtyView");
	if (threeSixtyButton.length > 0 && typeof(threeSixtyButton.data('icp_inited')) === "undefined") {
		if (threeSixtyButton.hasClass("legacy")) {
			threeSixtyButton.click(function() {
				var player = new VideoPlayer("icp_product_video_player", {
													container: ICP.instance.selectInView("").get(0),
													styleClass: "icp_prd_vid_player_"+ICP.instance.currentView,
													playerUrl: "" //ICP.instance.config.icpHost + ICP.instance.config.flowPlayerUrl
												});
				player.load(VideoPlayerType.VIEW_360_LEGACY, ICP.instance.getLocale(), ICP.instance.getItemInView(),
						{ href: CcrUtil.getCcrUrl({
																ccrUrl : ICP.instance.config.ccrGetUrl
															,	ccrIsSecure : ICP.instance.config.ccrIsSecure
															, ccrMagic : ICP.instance.config.ccrMagic
														}, {
																"id": ICP.instance.getItemInView()
															, "docType": "PRV"
														})
						}
				);
				// Scroll to the top of the item
				ICP.instance.getViewContainer().children(".icp_content").scrollTop(0);
				player.show();
			});
		} else {
			var scene7Asset = ICPConfig.config.scene7GetUrl + "/" + ICP.instance.getItemInViewNormalized() + "-P3D-" + "global";
			ICP.instance.scene7AssetExists(scene7Asset, function() {
				// exists
				threeSixtyButton.click(function() {
					var player = new VideoPlayer("icp_product_video_player", {
														container: ICP.instance.selectInView("").get(0),
														styleClass: "icp_prd_vid_player_"+ICP.instance.currentView,
														playerUrl: "" //ICP.instance.config.icpHost + ICP.instance.config.flowPlayerUrl
													});
					player.load(VideoPlayerType.VIEW_360, ICP.instance.getLocale(), ICP.instance.getItemInView(),
							{ href: scene7Asset}
					)
					// Scroll to the top of the item
					ICP.instance.getViewContainer().children(".icp_content").scrollTop(0);
					player.show();
				});
			}, function() {
				// !exists
				threeSixtyButton.click(function() {
					alert("Although an asset exists for a 360 view, it is not yet available for viewing.");
				});
			});
		}
		
		threeSixtyButton.data('icp_inited', true);
	}
	//icp_load_main_product_photo("website");
	icp_load_carousel_viewer("website");
	ICP.instance.logger.debug("Leave icp_update_item_in_view_prd_website()");
}

$(document).ready(icp_init_view_product_website);
