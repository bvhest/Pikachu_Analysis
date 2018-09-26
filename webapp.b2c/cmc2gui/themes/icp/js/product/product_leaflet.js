function icp_init_view_product_leaflet() {
	ICP.instance.logger.debug("Enter icp_init_view_product_leaflet()");
	// Register item in view callback
	ICP.instance.registerCallback("leaflet", "updateItemInView", icp_update_item_in_view_prd_leaflet);
	if (ICP.instance.currentView === "leaflet")
		icp_update_item_in_view_prd_leaflet(ICP.instance.getItemInView("leaflet"));
	ICP.instance.logger.debug("Leave icp_init_view_product_leaflet()");
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
function icp_update_item_in_view_prd_leaflet(itemId) {
	ICP.instance.logger.debug("Enter icp_update_item_in_view_prd_leaflet()");
	// Remove any embed elements that are displaying a leaflet PDF
	$("embed.icp_leaflet_frame").remove();
	// Check if there is a div for the leaflet PDF to load
	var pdfContainer = ICP.instance.selectInView("div.icp_leaflet_pdf");
	if (pdfContainer.length > 0) {
		var url = pdfContainer.metadata().src;
		$("<embed>").addClass("icp_leaflet_frame")
			.attr("width", "100%")
			.attr("height", "100%")
			.attr("type", "application/pdf")
			.attr("src", url)
			// Insert it into the main leaflet content container so FireFox will set the correct height
			.insertBefore(pdfContainer.parent());
		// Set the overflow visibility to hidden
		$("#icp_content_leaflet").css("overflow-y", "hidden");
	}
	else {
		$("#icp_content_leaflet").css("overflow-y", "auto");
		// Load the column only if it is in view
		if ($(".leaf_p2").is(":visible")) {
			var columns = ICP.instance.selectInView(".leaf_p2 .column", "leaflet");
			ICP.instance.selectInView(".leaf_p2 .highlights > *", "leaflet").columnLayoutAppendTo(columns);
			
			columns = ICP.instance.selectInView(".leaf_p3 .column", "leaflet");
			ICP.instance.selectInView(".leaf_p3 .specifications > *").columnLayoutAppendTo(columns);
		}
	}
	ICP.instance.logger.debug("Leave icp_update_item_in_view_prd_leaflet()");
}

$(document).ready(icp_init_view_product_leaflet);
