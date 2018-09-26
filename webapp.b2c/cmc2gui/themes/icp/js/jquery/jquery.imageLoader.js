/*
	jquery.imageLoader.js
	
	version:   1.0
	author:    Freek Segers
	copyright: 2009 Philips Consumer Lifestyle
	date:      2009-05-14
	
	Loads images into selected containers "at runtime."
	
	The loading is queued to prevent threading problems in the browser, which may occur because the process
	uses a lot of asynchronous calls.
	
	Usage:
		$(".lazyLoadedImage").imageLoaderLoad(options);
		
		Mandatory options:
			assetTypes		contains the asset types information to use. This is an AssetIndex object (See example below.)
			ownerId				The id of the object that owns the images. (Usually a Product's CTN.)
		
		Optional options are:
			scene7Url			defaults to http://image.philips.com/is/image/PhilipsConsumer
			scene7Disabled	if true, all Scene7 calls will be emulated as returning non existent assets
			ccrUrl				defaults to http://www.p4c.philips.com/cgi-bin/dcbint/get
			ccrDisabled		if true, CCR will not be used.
			isSecureCcr		If true the CCR URL will be expanded with a checksum
			abortCurrent 	clears the queue before new images are added.
			placingPolicy	'append' means append the image to the selected element.
										'replace' means replace the selected element with tha image.
			missingPolicy	'remove' means remove the selected element if no image could be loaded.
										'keep' means keep the seletced element.
			maxNumImages	The maximum number of images to load.
			
	Example:
		HTML:
			<div class="lazyLoadedImage {imageData: {id:'42PFL9903H/12', docType:'GAL', width:500, height:500, index:'001'}}"/>
		
		SCRIPT:
			$(".lazyLoadedImage").imageLoaderLoad({
				assetTypes: productAssets,
				ownerId: "42PFL9903H/12",
				scene7Url: "http://image.philips.com/is/image/PhilipsConsumer",
				ccrUrl: "http://www.p4c.philips.com/cgi-bin/dcbint/get"
			});
		
		This will query Scene7 for the existence of 42PFL9903H_12-GAL-global. If it exists an img will be
		inserted into the div and src attribute equal to
			http://image.philips.com/is/images/PhilipsConsumer?wid=500&hei=500&$jpglarge$
			
			(if both width and height are less than 100, the $jpgsmall$ macro is used.)
			
		If Scene7 does not have the image, the assetTypes object will be used to get a suitable image
		for the specified width and/or height and load that image from CCR.
		The assetTypes object is of type AssetIndex which contains an index of available assets per owner,
		e.g. a Product.
*/

var catalogRecord;

(function($) {

	$.imageLoader = {
		defaultOptions: {
				scene7Url: "http://images.philips.com/is/image/PhilipsConsumer"
			, scene7Disabled: false
			,	ccrUrl: "http://www.p4c.philips.com/cgi-bin/dcbint/get"
			, ccrDisabled: false
			, isSecureCcr: false
			, logger: null
			, abortCurrent: false
			, placingPolicy: 'append'
			, missingPolicy: 'keep'
			, scalePolicy: 'fit proportional' // or 'reduce only'
			, maxNumImages: 0
		},
		_scene7Cache: {},
		_jobQueue: [],
		_isRunning: false
	};
	
	function log(logger, message) {
		if (logger) {
			logger.debug(message);
		}
	}
	
	/*
		Load a Scene7 image by checking if it exists first.
		This function *only* performs the query to Scene7 for the availability of the image.
		The result is stored in a cache and doLoasScene7Image is called to perform the actual loading.
	*/
	function loadScene7Image(param) {
		log(param.logger, "loadScene7Image(): " + [param.id, param.docType].join(", "));
		var locale;
		if (typeof param.assetTypes != "undefined") {
			asset = param.assetTypes.getAsset(param.ownerId, param.id, param.docType);
			locale = asset != null ? asset.locale : "global";
		} else {
			locale = 'global';
		}
		var index = param.index || (param.docType != 'GAL' && param.docType != 'IMS' ? "001" : "");
		var url = param.scene7Url + "/" + param.id.replace(/\//g, "_") + "-" + param.docType + "-" + locale + (index != '' ? "-" + index : "");
		if (typeof($.imageLoader._scene7Cache[url]) === "undefined") {
			log(param.logger, "loadScene7Image(): calling Scene7 exists");
			catalogRecord = {}; // Needs to be global!
			$.getScript(url+"?req=exists,javascript", function() {
				$.imageLoader._scene7Cache[url] = (!param.scene7Disabled && catalogRecord.exists == 1);
				doLoadScene7Image(url, param);
			});
		} else {
			doLoadScene7Image(url, param);
		}
	}
	
	/*
		Load a Scene7 image by checking if it exists first.
		This function assumes that Scene7 was called before to detemine the availability and thus the
		cache has this information. 
		
		typeArray contains a list of types to attempt, e.g. ['GAL','PWL',...]
		
		If the image is available it is loaded into the specified container.
		Otherwise an attempt is made to load an image from CCR.
	*/
	function doLoadScene7Image(url, param) {
		log(param.logger, "doLoadScene7Image(): " + [param.id, param.docType, url].join(", "));
		var w = param.width|0;
		var h = param.height|0;
		if ($.imageLoader._scene7Cache[url]) {
			log(param.logger, "doLoadScene7Image(): image exists [cached]");
			var p = [];
			// Add a Scene7 macro to the URL
			if (w != 0 && h != 0) {
				if (w < 100 && h < 100) {
					p.push("$jpgsmall$");
				} else {
					p.push("$jpglarge$");
				}
			}
			// Add width and height to the URL
			if (w != 0) {
				p.push("wid="+w);
			}
			if (h != 0) {
				p.push("hei="+h);
			}
			if (p.length > 0) {
				url += "?" + p.join("&");
			}
			
			var $oImg = $("<img>").attr("src", url);
			completeImage(param, $oImg[0]);
			if (param.placingPolicy === "replace") {
				param.target.replaceWith($oImg);
			} else {
				$oImg.appendTo(param.target);
				param.target.data("_il_state", "loaded");
			}
			handleLoadedState(param);
			
		} else {
			log(param.logger, "doLoadScene7Image(): Image does not exist [cached]");
			if (!param.ccrDisabled) {
				log(param.logger, "doLoadScene7Image(): Looking for a suitable asset. " + [param.ownerId, param.id, param.docType, w, h].join(", "));
				var asset = param.assetTypes.findAsset(param.ownerId, {code: param.id, type: param.docType, width: w, height: h});
				if (asset != null) {
					log(param.logger, "doLoadScene7Image(): Found asset - {code: " + asset.code + ", type:" + asset.type + "}");
					loadCCRImage(asset, param);
				} else {
					log(param.logger, "doLoadScene7Image(): Did not find asset");
					handleFailedState(param);
				}
			}
			else {
				handleFailedState(param);
			}
		}
	}
	
	function loadCCRImage(asset, param) {
		var objectId = unescapeIdForCCR(param.id, param.docType);
		var url = getCCRUrl(param, objectId, asset.type);
		log(param.logger, "loadCCRImage(): " + [objectId, param.docType, asset.type, url].join(", "));
		var width = param.width || 0;
		var height = param.height || 0;
		
		var oImg = new Image();
		$(oImg)
			.load(function() {
				log(param.logger, "loadCCRImage(): image loaded successfully");
				
				// Fix the width and height
				var ratio = this.width / this.height;
				var newWidth = newHeight = 0;
				
				log(param.logger, "loadCCRImage(): image width/height is " + this.width + "x" + this.height + ". Ratio is " + ratio);
				log(param.logger, "loadCCRImage(): specified width/height is " + width + "x" + height);
				if (width > 0 && (param.scalePolicy === 'fit proportional' && this.width != width || this.width > width)) {
					newWidth = width;
					newHeight = (newWidth / ratio) | 0;
					log(param.logger, "loadCCRImage(): scaling width to " + width + ". height is now " + newHeight);
				}
				if (height > 0) {
					if (newHeight > 0) {
						if (newHeight > height) {
							newHeight = height;
							newWidth = (newHeight * ratio) | 0;
						}
					}
					else if (this.height > height) {
						newHeight = height;
						newWidth = (newHeight * ratio) | 0;
					}
					log(param.logger, "loadCCRImage(): scaling height to " + height + ". width is now " + newWidth);
				}
				if (newHeight > 0 && newHeight != this.height) {
					this.height = newHeight;
				}
				if (newWidth > 0 && newWidth != this.width) {
					this.width = newWidth;
				}
				
				completeImage(param, oImg);
				
				if (param.placingPolicy === "replace") {
					param.target.replaceWith(this);
				} else {
					param.target.append(this);
					param.target.data("_il_state", "loaded");
				}
				handleLoadedState(param);
				
				// Center the image vertically (vertical-align: middle works only in table cells)
				var $this = $(this);
				var parentHeight = $this.parent().innerHeight();
				log(param.logger, "loadCCRImage(): parentHeight = " + parentHeight + ", image.height = " + this.height);
				if (parentHeight > this.height) {
					log(param.logger, "loadCCRImage(): applying margin to center image.");
					$this.css('margin-top', (($this.parents(":first").innerHeight() - this.height) / 2)|0);	// 'Cast' to int
				}
			})
			.error(function() {
				log(param.logger, "loadCCRImage(): image failed to load");
				handleFailedState(param);
			})
			.attr("src", url);
	}
	
	function handleLoadedState(param) {
		var currentJob = $.imageLoader._jobQueue[0];
		currentJob.numImagesLoaded++;
	}
	
	function handleFailedState(param) {
		if (param.missingPolicy === "remove") {
			param.target.remove();
		} else {
			param.target.data("_il_state", "failed");
		}
	}
	
	function findAndRemoveClosestType(variants, width, height) {
		var last, idx;
		for (var i = 0; i < variants.length; i++) {
			var dist = 0;
			if (width > 0)
				dist += Math.abs(width - variants[i].width);
			if (height > 0)
				dist += Math.abs(height - variants[i].height);
			if (typeof(last) === "undefined" || dist < last) {
				last = dist;
				idx = i;
			}
		}
		return variants.splice(idx,1)[0];
	}
	
	// Because some of the ids come from the Assets' Asset code attribute
	// slashes and dashed have beeen escaped to underscores.
	// CCR needs the original id.
	// This function attempts to restore the id that originate from CTNs.
	// This may not work in all cases.
	function unescapeIdForCCR(id, type) {
		if (type != 'FLP' && type != 'FIL' && type != 'FMB' && type != 'FDB')
			return id.replace(/_/g, "/");
		else
			return id;
	}
	
	function getCCRUrl(param, id, docType) {
		return CcrUtil.getCcrUrl(param, {"id": id, "docType": docType});
	//	var queryString = "id="+id+"&doctype=" + docType;
	//	var url = param.ccrUrl + "?" + queryString;
	//	if (param.ccrIsSecure) {
	//		url += "&grss=" + MD5(param.ccrMagic + queryString);
	//	}
	//	return url;
	}
	
	function completeImage(param, image) {
		if (param.styleClass) {
			$(image).addClass(param.styleClass);
		}
		if (param.imageId) {
			image.id = param.imageId;
		}
		$(image).attr("alt", param.id).attr("title", param.id);
	}
	
	function loadImage(param) {
		log(param.logger, "loadImage(): " + [param.id, param.docType].join(", "));
		if (param.docType) {
			loadScene7Image(param);
		} else {
			handleFailedState(param);
		}
	}
	
	function processQueue() {
		var queue = $.imageLoader._jobQueue;
		if (queue.length > 0) {
			var job = queue[0];
			if (typeof job.numImagesLoaded === "undefined") {
				job.numImagesLoaded = 0;
			}
			if (job.options.maxNumImages > 0 && job.numImagesLoaded >= job.options.maxNumImages) {
				// Abort the current job because we've loaded enough images
				log(job.options.logger, "processQueue() - Aborting because the maximum of " + job.options.maxNumImages + " were loaded");
				job.elements = [];
				queue.shift();	// Remove the job from the queue
				
				if (typeof job.options.callback === "function") {
					job.options.callback.apply();
				}
				window.setTimeout(processQueue, 0);
			}
			else if (job.elements.length > 0) {
				var $element = $(job.elements[0]);
				if ($element.parent().length == 0	// for Mozilla
							|| $element.parent()[0].nodeName === "#document-fragment") {		// for IE
					// Element was removed (either because loading failed or succeeded)
					// Remove element from the queue
					job.elements.shift();
					window.setTimeout(processQueue, 0);
				} else {
					if ($element.children("img").length > 0) {
						$element.data("_il_state", "loaded");
					}
					var state = $element.data("_il_state");
					if (state === "processing") {
						// Element is still being processed, try again in .5 seconds
						window.setTimeout(processQueue, 200);
					}
					else if (state === "loaded" || state === "failed") {
						// Remove element from the queue
						job.elements.shift();
						window.setTimeout(processQueue, 0);
					}
					else if (!state) {
						$element.data("_il_state", "processing");
						loadImage($.extend({target: $element}, job.options, $element.metadata().imageData));
						window.setTimeout(processQueue, 500);
					}
				}
			} else {
				// Remove the job form the queue
				// and process the next job
				queue.shift();
				if (typeof job.options.callback === "function") {
					job.options.callback.apply();
				}

				window.setTimeout(processQueue, 0);
			}
		} else {
			$.imageLoader._isRunning = false;
		}
	}
	
	function run() {
		if (!$.imageLoader._isRunning) {
			$.imageLoader._isRunning = true;
			window.setTimeout(processQueue, 200);
		}
	}
	
	// Prototype Methods
	$.fn.extend({
		imageLoaderLoad: function(options) {
			var options = $.extend({}, $.imageLoader.defaultOptions, options);

			log(options.logger, "Enter: imageLoaderLoad()");
			
			if (options.abortCurrent) {
				log(options.logger, "Aborting current procesing");
				$.imageLoader._jobQueue = [];
			}
			// Add this as a new job to the job queue
			$.imageLoader._jobQueue.push({
					options: options
				,	elements: this.filter(function () {	// Add only elements that were not processed before
											return typeof $(this).data("_il_state") === "undefined";
										}).get()
			});
			
			log(options.logger, "Calling run()");
			run();
			
			//this.each(function() {
				//var $this = $(this);
				// metadata: {id:'HR2084/90', docType:'GAL', width:500, height:500, index:'001'}
				//var metadata = $this.metadata();
				//loadImage($this, $.extend(metadata, options, {target: $this}));
			//});

			log(options.logger, "Leave: imageLoaderLoad()");

			return this;
		}
	});
})(jQuery);
