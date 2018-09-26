function icp_init_view_range_overview() {
	// Register tooltip for Feature and CSItem info
	$("td.icp_rng_ov_header:has(.icp_filter_info)").tooltip({
		showURL: false,
		bodyHandler: function(e) { return $(this).children(".icp_filter_info").eq(0).html(); },
		track: false,
		fade: 250,
		id: "icp_filter_info"
	});

	ICP.instance.registerCallback("overview", "updateItemInView", icp_update_item_in_view_rng_overview);
	icp_update_item_in_view_rng_overview(ICP.instance.getItemInView("overview"));
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
function icp_update_item_in_view_rng_overview(itemId) {
}

$(document).ready(icp_init_view_range_overview);
