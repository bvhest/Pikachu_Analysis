function icp_init_view_product_shop() {
	ICP.instance.logger.debug("Enter icp_init_view_product_shop()");
	$('#icp_content_shop dl.dr_productTabs').dltabs({
		activeClassName: 'active_tab',  inactiveClassName: 'inactive_tab'//, displayEffect: {animation:'fade', speed:'slow'}
	});
	
	// Because we can't check if feature images are empty in XSLT 1.0
	// there is always a div element present which may be empty.
	// Let's remove those.
	//$("div.imageLeft:not(:has(img))", "#icp_content_shop div.tabs").remove();

	// Register item in view callback
	ICP.instance.registerCallback("shop", "updateItemInView", icp_update_item_in_view_prd_shop);

	if (ICP.instance.currentView === "shop")
		icp_update_item_in_view_prd_shop(ICP.instance.getItemInView("shop"));

	ICP.instance.logger.debug("Leave icp_init_view_product_shop()");
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
function icp_update_item_in_view_prd_shop(itemId) {
	ICP.instance.logger.debug("Enter icp_update_item_in_view_prd_shop()");
	//icp_load_main_product_photo("shop");
	icp_load_carousel_viewer("shop");
	ICP.instance.logger.debug("Leave icp_update_item_in_view_prd_shop()");
}

$(document).ready(icp_init_view_product_shop);
