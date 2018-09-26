/*
	Load the product photos for the referenced product list.
*/
function icp_load_referenced_product_photos(view) {
	// Only if the current view is the specified view
	if (ICP.instance.currentView == view) {
		// Process all dynamic_product_photo divs without an img inside
		ICP.instance.selectInView("div.dynamic_product_photo").each(function() {
			// The idref attribute contains the product CTN
			var ctn = $(this).attr("idref");
			if (ctn && $(this).children("img").length == 0) {
				$(this).empty();
				
				var img = new Image();
				var ctnNorm = ctn.replace(/\//,"_");
				var width = this.style.width;
				if (width != "") width = width.replace(/px$/,"");
				var height = this.style.height;
				if (height != "") height = height.replace(/px$/,"");
				
				if (!width && !height) {
					height = 70;
				}
				var container = $(this);
				// Load the image from Scene7 or CCR
				ICP.instance.scene7AssetExists(ctnNorm+"-GAL-global",
					function() {			// The asset exists -> load from Scene7
						ICP.instance.logger.debug("Loading image from Scene7...");
						var imgUrl = "http://images.philips.com/is/image/PhilipsConsumer/"+ctnNorm+"-GAL-global?";
						if (width)
							imgUrl += "wid="+width+"&";
						if (height)
							imgUrl += "hei="+height+"&";
						if (width > 100 || height > 100 || (!width && !height))
							imgUrl += "$jpglarge$";
						else
							imgUrl += "$jpgsmall$";
						
						ICP.instance.logger.debug("URL is " + imgUrl);
						$(img)
							.load(function() {
								ICP.instance.logger.debug("Image loaded sucessfuly. Appending to container.");
								container.append(this);
							})
							.error(function() {
								ICP.instance.logger.debug("Image failed to load.");
								container.html("Failed to load image " + this.src);
							})
							.attr("src", imgUrl);
					},
					function() {			// The asset does not exist -> load from CCR
						ICP.instance.logger.debug("Loading image from CCR...");
						params = {};
						params.ctn = ctn;
						// These are the doc types in the GAL imageset
						params.types = ['PWS','RTS','TLS','TRS','UWS','_FS','FTS','DPS','UPS'];
						params.typeIndex = 0;
						params.maxNrOfImages = 1;
						params.width = width;
						params.height = height;
						params.container = container;
						params.container.empty();
						
						icp_load_imageset_ccr(params);
					}
				);
			}
		});
	}
}
