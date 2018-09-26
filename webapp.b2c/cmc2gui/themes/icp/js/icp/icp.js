/*
	The ICP class
*/
function ICP(icpConfig) {
	this.config = icpConfig || {};
	this.views = new Array();
	this.currentView = null;
	this.currentItemInView = {};	// Contains for each view the id of the currently visible item, e.g. a product CTN
	this.callback = {};					// Callback functions for each view
	this.scene7ExistsCache = {};
	this.locale = $("html").attr("locale");
	this.logger = new Logger("ICP", this.config.logLevel);
	this.logger.debug("ICP created.");
	this.assets = {};
}

/*
	Display the requested view
*/
ICP.prototype.displayView = function(view) {
	this.logger.debug("Enter displayView("+view+")");
	// Remove video player
	if ($("#icp_product_video_player").length > 0)
		VideoPlayer.destroy("icp_product_video_player");
	// Hide all views
	// This takes quite some time in IE, so don't do it if the page is just loading
	if (!this.isInitializing)
		$("#icp > .icp_view").hide();
	// Make the requested view visible
	$("#icp_view_"+view).show();
	this.currentView = view;
	this.updateViewbar();
	icp_onresize_window();
	this.loadLazyImages();
	this.executeCallback(this.currentView, "updateItemInView", this.getItemInView());
	this.logger.debug("Leave displayView()");
}

/*
	Display an item inside a view.
	
	Parameters:
		index		The index of the item to be displayed.	
		view 		The view to activate. If empty the current view will be used.
*/
ICP.prototype.displayItem = function(index, view) {
	this.logger.debug("Enter displayItem("+index+","+view+")");
	var targetView;
	if (arguments.length > 1)
		targetView = view;
	else
		targetView = this.currentView;

	this.logger.debug("Target view is "+targetView);
	
	var viewList;
	if (targetView == "all")
		viewList = this.views;
	else
		viewList = [targetView];
	
	// Remove video player
	if ($("#icp_product_video_player").length > 0)
		VideoPlayer.destroy("icp_product_video_player");
	
	this.logger.debug("+Making target item visible");
	for (var v = 0; v < viewList.length; v++) {
		var view = this.getViewContainer(viewList[v]);
		// Every item is contained in an element with class icp_container
		var targetItem = view.children(".icp_content").children(".icp_container:eq("+index+")");
		if (targetItem.length > 0 && targetItem.is(":hidden")) {
			// Determine the item ID
			var itemId = this.getItemId(targetItem);
			//var previousItemId = this.currentItemInView[viewList[v]];
			this.currentItemInView[viewList[v]] = itemId;
			// Hide all items
			view.children(".icp_content").children(".icp_container").hide();
			// Show the target item
			targetItem.show();
		}
	}
	this.logger.debug("-Making target item visible");

	// Show the target view if it is not visible.
	if (targetView != "all" && this.currentView != targetView)
		this.displayView(targetView);
	else
		this.loadLazyImages();

	// Show the translation errors for this item, if any
	this.logger.debug("+Showing translation errors");
	var errorBox = $("#icp_error_summary");
	if (errorBox.length > 0) {
		errorBox.find(".item_errors").hide();
		var itemErrors = errorBox.find(".item_errors[idref='"+this.getItemInViewNormalized()+"']");
		if (!itemErrors.is(":empty")) {
			itemErrors.show();
			errorBox.show();
		} else {
			errorBox.hide();
		}
	}
	this.logger.debug("-Showing translation errors");
	
	this.executeCallback(this.currentView, "updateItemInView", this.getItemInView());
	
	// Scroll to the top of the item
	this.getViewContainer().children(".icp_content").scrollTop(0);

	this.logger.debug("Leave displayItem()");
}

/*
	Initialize the view
*/
ICP.prototype.initView = function() {
	this.logger.debug("Enter initView()");
	// Draw the view tabs
	var tabsContainer = $("#icp_viewbar table tr");
	var tabsHtml = "";
	var icp = this;
	var viewSet = $("#icp > .icp_view");
	viewSet.each(function() {
		var id = $(this).attr("id");
		var view = id.substring(id.lastIndexOf("_")+1);
		icp.views.push(view);
		var viewName = icp.config.views[view] ? icp.config.views[view].name : view.toUpperCase();
		tabsHtml += "<td class=\"item\" id=\"viewbar_item_"+view+"\"><a href=\"javascript:void(0)\">"+viewName+"</a></td>";
		// Set the first content item in the view as the current.
		icp.currentItemInView[view] = icp.getItemId($(this).children(".icp_content").children(".icp_container:first"));
	});
	tabsContainer.prepend(tabsHtml);
	
	// Activate the default view
	this.logger.debug("+Activating the default view");
	var defaultView;
	var systemConfig = this.config.systems[this.config.system];
	if (typeof systemConfig !== "undefined") {
		defaultView = systemConfig.defaultView;
	} else {
		// Get the first view container
		var firstViewId = viewSet.eq(0).attr("id");
		defaultView = firstViewId.substring(firstViewId.lastIndexOf("_")+1);
	}
	this.logger.debug(" default view is " + defaultView);
	// Check if we need to jump to a certain text. This is indicated by a hash in the URL, e.g. ../foobar.xml#FHG_F400000253
	this.logger.debug(" URL is " + window.location.href)
	var activeItem, textElement;
	var hash = window.location.hash;
	var moved = false;
	if (hash) {
		this.logger.debug(" Found a hash in the URL: " + hash);
		moved = this.gotoTextItem(hash.substring(1), "overview");
	}
	if (!moved) {
		// Display the active item in the view
		this.displayItem(0, defaultView);
	}
		
	this.logger.debug("-Activating the default view");
	this.logger.debug("Leave initView()");
}

ICP.prototype.gotoTextItem = function(itemId, targetView) {
		this.logger.debug("Moving to text item: " + itemId);
		var location = this._findProductWithText(itemId, targetView);
		if (typeof location !== "undefined") {
			this.logger.debug(" Found text element.");
			activeItem = location.productContainer.attr('index');
			textElement = location.textElement;
			this.displayItem(activeItem, targetView);
			this.scrollIntoView(textElement.get(0));
			// Highlight the text
			this.selectInView(".icp_translationHighlight").removeClass("icp_translationHighlight");
			textElement.addClass("icp_translationHighlight");
			textElement.siblings(".icp_translationLengthExceeded").addClass("icp_translationHighlight");
			// Highlight the correct item in de index
			$("#icp_index li a").removeClass("active");
			$("#icp_index li:eq("+activeItem+") a").addClass("active");
			
			this.currentTextItem = itemId;
			return true;
		} else {
			return false;
		}
}

/*
	Find a text with a specified key attribute.
	Returns the textElement and the containing item.
*/
ICP.prototype._findProductWithText = function(textKey, view) {
	var targetView = view || this.currentView;
	var container = this.getViewContainer(targetView);
	var textElement = $("span[key='"+textKey+"']:first", container);
	if (textElement.length > 0) {
		// Get the item container for this text element
		var itemContainer = textElement.parents(".icp_container");
		return {
			"productContainer": itemContainer,
			"textElement": textElement
		}
	}
	return;
}

/*
	Loads lazy loadable images for the new item in view
*/
ICP.prototype.loadLazyImages = function() {
	var item = this.getItemInView();
	this.logger.debug("Enter lazyLoadImages() for " + item);
	ICP.instance.selectInView(".icp_lazyload").imageLoaderLoad({
			assetTypes: this.assetIndex
		,	ccrUrl : this.config.ccrGetUrl
		,	ccrIsSecure : this.config.ccrIsSecure
		,	ccrDisabled : this.config.ccrIsDisabled
		, ccrMagic : this.config.ccrMagic
		, ownerId : item
	});
	this.logger.debug("Leave lazyLoadImages()");
}

/*
	Update the view buttons to reflect the current view
*/
ICP.prototype.updateViewbar = function() {
	this.logger.debug("Enter updateViewbar()");
	// Make all tabs inactive
	$("#icp_viewbar td[id]").removeClass("active").addClass("inactive");
	// Activate current view tab
	$("#viewbar_item_"+this.currentView).removeClass("inactive").addClass("active");
	// Set border-collapse to make FireFox draw the borders correctly.
	// This does not work if the property is set in the CSS file (??)
	/*
	if ($.browser.mozilla) {
		$("#icp_viewbar table").css("border-collapse", "separate");
		window.setTimeout('$("#icp_viewbar table").css("border-collapse", "collapse")', 600);
	}
	*/
	this.logger.debug("Leave updateViewbar()");
}

/*
	Register a callback
	
	Parameters:
		view            A view name
		callbackName    Name of the callback. One of:
				"updateItemInView" - called when the current item is changed by calling displayItem()
		fn              The function to call. The id of the current and previous item will be passed as arguments.
*/
ICP.prototype.registerCallback = function(view, callbackName, fn) {
	if (typeof(this.callback[view]) === "undefined")
		this.callback[view] = {};
	this.callback[view][callbackName] = fn;
}

ICP.prototype.executeCallback = function(view, callbackName) {
	this.logger.debug("Enter executeCallback("+view+","+callbackName+")");
	if (typeof(this.callback[view]) !== "undefined" && this.callback[view][callbackName]) {
		// Convert the arguments object to an actual Array and remove the first two
		var args = Array.prototype.slice.call(arguments, 2);
		this.callback[view][callbackName].apply(null, args);
	}
	this.logger.debug("Leave executeCallback()");
}

/*
	Get a view container as a jQuery object.
	If view is not specified returns the current view's container.
*/
ICP.prototype.getViewContainer = function(view) {
	var theView = view || this.currentView;
	return $("#icp_view_"+theView);
}

/*
	Get a jQuery selector using the current item in view.
*/
ICP.prototype.getInViewSelector = function(selector, view) {
	var theView = view || this.currentView;
	return "#"+this.getItemInViewNormalized()+"_container_"+theView+" "+selector;
}

/*
	Get a jQuery selection using the current item in view.
*/
ICP.prototype.selectInView = function(selector, view) {
	return $(this.getInViewSelector(selector, view));
}

/*
	Get the item id from an item container element
	Item containers should have an id attribute of the form <id>_container_<view>, e.g. 7FF2PAS_00_container_website.
	
	Paramaters:
		elm   A JQuery object that represents an item container
*/
ICP.prototype.getItemId = function(elm) {
	var itemId;
	if ($.metadata) {	// Use metadata plugin
		itemId = elm.metadata().id;
	} else {
		var itemContainerId = elm.attr("id");
		if (typeof(itemContainerId) !== "undefined") {
			var a = itemContainerId.split(/_/);
			itemId = a.length > 3 ? a.splice(0,a.length - 2).join("_") : a[0];
		}
	}
	return itemId;
}

ICP.prototype.getItemIdNormalized = function(elm) {
	return this.getItemId(elm).replaceAll(/\//g, "_");
}

/*
	Returns the id of the currently visible item for a view.
	If view is not specified the curent view will be used.
*/
ICP.prototype.getItemInView = function(view) {
	var theView = view || this.currentView;
	return this.currentItemInView[theView];
}
ICP.prototype.getItemInViewNormalized = function(view) {
	return this.getItemInView(view).replace(/\//g, "_");
}

ICP.prototype.getLocale = function() {
	return this.locale;
}
ICP.prototype.getLanguage = function() {
	return this.locale.substring(0,2);
}
ICP.prototype.getCountry = function() {
	return this.locale.substring(3);
}

ICP.prototype.getAsset = function(id, type) {
	return this.assetIndex.getAsset(this.getItemInView(), id, type);
}

/*
	Ask the Scene7 server if it has a certain asset.
	
	asset is either a scene7 asset URL or just the scene7 asset name.
*/
ICP.prototype.scene7AssetExists = function(asset, onExistsCB, onNotExistsCB) {
	this.logger.debug("scene7AssetExists("+asset+")");
	if (!asset.match(/^http:\/\//)) {
		asset = this.config.scene7GetUrl + "/"+asset;
	}
	if (typeof(this.scene7ExistsCache[asset]) === "undefined") {
		var icp = this;
		catalogRecord = {};
		$.getScript(asset+"?req=exists,javascript", function() {
			icp.logger.debug("Result is " + catalogRecord.exists);
			icp.scene7ExistsCache[asset] = (catalogRecord.exists == 1);
			if (catalogRecord.exists == 1) {
				if (typeof(onExistsCB) == "function") {
					onExistsCB();
				}
			} else {
				if (typeof(onNotExistsCB) == "function") {
					onNotExistsCB();
				}
			}
		});
	} else {
		this.logger.debug("Result is " + this.scene7ExistsCache[asset] + " (from cache)");
		if (this.scene7ExistsCache[asset]) {
			if (typeof(onExistsCB) == "function") {
				onExistsCB();
			}
		} else {
			if (typeof(onNotExistsCB) == "function") {
				onNotExistsCB();
			}
		}
	}
}

ICP.prototype.scrollIntoView = function(elm) {
	var viewContainerId = this.getViewContainer().get(0).id;
	var offset = elm.offsetTop;
	while (elm.offsetParent != null && elm.offsetParent.id != viewContainerId) {
		elm = elm.offsetParent;
		offset += elm.offsetTop;
	}
	this.getViewContainer().children(".icp_content").scrollTop(offset - 8);	
}

/********************************************************
		Helper functions (event handling, etc.)
*********************************************************/

// Resizes the current view container's height so it will fit the window.
function icp_onresize_window() {
	ICP.instance.logger.debug("Enter icp_onresize_window()");
	var windowHeight = $.browser.msie ? $("body").get(0).clientHeight : window.innerHeight;
	// Because the .icp_view elements are positioned absolutely, they do not affect the body height.
	var container = ICP.instance.getViewContainer();
	var newHeight = windowHeight - parseInt(container.css("top")) - parseInt(container.css("margin-top")) - parseInt(container.css("margin-bottom"));
	container.children(".icp_content:eq(0)").height(newHeight - 4);
	// Resize the index
	var indexHeight = newHeight - 35 > 20 ? newHeight - 35 : 20;
	$("#icp_index ul").height(indexHeight);
	ICP.instance.logger.debug("Leave icp_onresize_window()");
}

function icp_init() {
	// Create one instance of ICP (singleton)
	ICP.instance = new ICP(ICPConfig.getConfig());
	ICP.instance.isInitializing = true;
	
	ICP.instance.logger.debug("Enter icp_init()");

	ICP.instance.config.ccrMagic = "GewilligGeweldig";
	// Store the assets
	if (typeof icp_asset_index !== "undefined") {
		ICP.instance.assetIndex = icp_asset_index;
	} else {
		ICP.instance.assetIndex = new AssetIndex();
	}
	
	// Set default image loader options
	// Attach logger to image loader
	$.imageLoader.defaultOptions.logger = new Logger("ImgLdr", ICP.instance.config.logLevel);;
	// Always abort current queue on new call
	$.imageLoader.defaultOptions.abortCurrent = true;

	// Bind the resize function to the resize event,
	// so the containers will resize automatically when
	// the window is resized.
	$(window).resize(icp_onresize_window);
	// Initialize the view.
	ICP.instance.initView();
	// Bind a click handler on the view tabs
	$("#icp_viewbar td[id]").click(function() {
		var id = $(this).attr("id");
		ICP.instance.displayView(id.substring(id.lastIndexOf("_")+1));
	});
	
	/*
		Index
	*/
	ICP.instance.logger.debug("+Initialize index");
	var icp_index = $("#icp_index");
	if (icp_index.length > 0) {
		icp_index.hover(
			function() { $(this).removeClass("icp_transparent"); },
			function() { $(this).addClass("icp_transparent"); }
		);
		// Make the index box collapsable
		var title = icp_index.children(".icp_title");
		title.prepend("<a href=\"javascript:void(0)\" class=\"icp_anchor\" style=\"float:left\">▲&#160;</a>");
		title.children("a").eq(0).click(function() {
			var ul = $(this).parent().next("ul");
			if (ul.is(":visible")) {
				$(this).html("▼&#160;");
			} else {
				$(this).html("▲&#160;");
			}
			ul.slideToggle();
		});
	
		icp_index.find("li a").click(function() {
			$(this).parent().siblings().children("a").removeClass("active");
			$(this).addClass("active");
			var pos = $(this).parent().prevAll("li").length;
			ICP.instance.displayItem(pos, "all");
		});
	}
	ICP.instance.logger.debug("-Initialize index");
	
	/*
		Translation errors summary
	*/
	var icp_errors = $("#icp_error_summary");
	if (icp_errors.length > 0) {
		// Make the error summary box expandable
		var title = icp_errors.children(".icp_title").eq(0);
		title.prepend("<a href=\"javascript:void(0)\" class=\"icp_anchor\" style=\"float:left\">▼&#160;</a>")
		title.children("a").eq(0).click(function() {
			var t = $(this).parent().next(".icp_errors").eq(0);
			if (t.data("prevHeight")) {
				t.animate({height: t.data("prevHeight")}, 700);
				t.removeData("prevHeight");
				$(this).html("▼&#160;");
			} else {
				t.data("prevHeight", t.height());
				t.animate({height: 300}, 700);
				$(this).html("▲&#160;");
			}
		});
		// Highlight translation errors in the summary box
		ICP.instance.logger.debug("+Highlight translation errors summary");
		icp_errors.find("li > .icp_translationLengthExceeded").addClass("icp_translationError");
		// When an error is clicked the corresponding element in the current view 
		// is scrolled into the window's visible area
		icp_errors.find("ul > li").click(function() {
			var id = $(this).attr("idref");
			var e = ICP.instance.getViewContainer().find("span[idref='"+id+"']");
			if (e.length > 0) {
				ICP.instance.scrollIntoView(e.get(0));
			}
		});
		ICP.instance.logger.debug("-Highlight translation errors summary");

		// Activate Show errors in context
		ICP.instance.logger.debug("+Activating 'Show errors' checkbox");
		$("#icp_show_errors_in_context")
			.each(function() {
				if (this.checked)
					this.checked = false;
			})
			.click(function() {
				// Show the errors in the overview tab only
				$("#icp_view_overview .icp_translationLengthExceeded").toggleClass("icp_translationError");
			})
			.click();	// Trigger initializing the view
		ICP.instance.logger.debug("-Activating 'Show errors' checkbox");
		
		// Mark items with errors in the item index box
		var item_index = $("#icp_index");
		if (item_index.length > 0) {
			icp_errors.find(".icp_errors .item_errors:not(:empty)").each(function() {
				var item_id_norm = $(this).attr("idref");
				item_index.find("a[id='"+item_id_norm+"']").addClass("icp_item_with_errors").append(" ◄").attr("title", "This item has translation errors");
			});
		}
	}
	
	// Activate Highlight translatable text
	ICP.instance.logger.debug("+Activating 'Highlight translations' checkbox");
	$("#icp_highlight_translation_texts")
		.click(function(e) {
			if (this.checked) {
				$(".icp_translationOk, .icp_translationMaxLength, .icp_translationLengthExceeded", "#icp_view_overview").addClass("icp_translationHighlight");
			} else {
				$(".icp_translationOk, .icp_translationMaxLength, .icp_translationLengthExceeded", "#icp_view_overview").removeClass("icp_translationHighlight");
			}
		})
		.each(function() {	// Reset the checkbox; may remain checked/unchecked on refresh in some browsers, e.g. FireFox.
			if (this.checked) {
				this.checked = false;
			}
		});
	ICP.instance.logger.debug("-Activating 'Highlight translations' checkbox");
		
	// Register the tooltip for all translation errors
	ICP.instance.logger.debug("+Register the tooltip for transl. errors");
	$(".icp_translationLengthExceeded").tooltip({
		showURL: false,
		bodyHandler: function(e) { return $(this).next(".icp_translationInfo").eq(0).html(); },
		track: false,
		fade: 250,
		id: "icp_tooltip",
		extraClass: "icp_tooltip_fixed"
	});
	ICP.instance.logger.debug("-Register the tooltip for transl. errors");

	/*
		Activate movie buttons
	*/
	ICP.instance.logger.debug("+Activating movie buttons");
	$("#icp_view_website .movieButton").click(function() {
		var player = new VideoPlayer("icp_product_video_player", {
											container: ICP.instance.selectInView("").get(0),
											styleClass: "icp_prd_vid_player_"+ICP.instance.currentView,
											playerUrl: ICP.instance.config.icpHost + ICP.instance.config.flowPlayerUrl
										});
		var metadata = $(this).metadata().movieData;
		var playerType = metadata.objectType == 'product' ? VideoPlayerType.VIEW_VIDEO_PRODUCT : VideoPlayerType.VIEW_VIDEO_FEATURE;
		
		player.load(playerType, ICP.instance.getLocale(), metadata.id,
				{
						assetType: metadata.assetType
					, assetLocale: metadata.locale
					, assetLangCode: metadata.languageCode
				}
		);
		// Scroll to the top of the item
		ICP.instance.getViewContainer().children(".icp_content").scrollTop(0);
		player.show();
	});
	ICP.instance.logger.debug("-Activating movie buttons");
	
	/*
		Display the build number
	*/
	$("#icp_title").tooltip({
		showURL: false,
		bodyHandler: function(e) { return "<span id=\"icp_build_number\">In Context Preview - build "+ICP.instance.config.build+"</span>" },
		track: false,
		fade: 250,
		id: "icp_tooltip"
	});

	/*
		Install checkReload timer
	*/
	ICP.instance.checkReloadTimer = window.setInterval("checkReload()", 2000);

	ICP.instance.isInitializing = false;
	ICP.instance.logger.debug("Leave icp_init()");
}

/*
	Check the window location for a change in the hash,
	so we can jump to the new text item.
	This solves an issue where the new target item is not displayed
	when a new URL is loaded in an existing window.
*/
function checkReload() {
	var curItem = ICP.instance.currentTextItem;
	var newItem = window.location.hash.substring(1);
	//ICP.instance.logger.debug("checkReload(): " + curItem + " - " + newItem);
	if (curItem !== newItem && newItem !== "") {
		if (!ICP.instance.gotoTextItem(newItem, "overview")) {
			ICP.instance.logger.warn(" Move failed.");
		}
		// Activate the window
		window.focus();
	}
}

$(document).ready(icp_init);
