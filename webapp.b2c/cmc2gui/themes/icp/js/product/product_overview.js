function icp_init_view_product_overview() {
	ICP.instance.logger.debug("Enter icp_init_view_product_overview()");
	// Wrap the contents of each section, so we can hide it easily
	//ICP.instance.logger.debug("+Wrapping sections");
	//$("#icp_view_overview .icp_prd_ov_section").wrapInner("<div></div>");
	//ICP.instance.logger.debug("-Wrapping sections");
	
	// Add a title to every section based on the section class
	//ICP.instance.logger.debug("+Adding section titles");
	//$("#icp_view_overview .icp_prd_ov_section").each(function() {
	//	var clazz = $.grep($(this).attr("class").split(/\s+/), function(item) { return !item.match(/section/); });
	//	if (clazz.length > 0) {
	//		var sectionName = clazz[0].substring(clazz[0].lastIndexOf("_")+1).toUpperCase();
	//		$(this).prepend("<div class=\"title\">"+sectionName+"</div>");
	//		indexHtml += "<li idref=\""+clazz+"\"><a href=\"javascript:void(0)\">"+sectionName+"</a></li>";
	//	}
	//});
	//ICP.instance.logger.debug("-Adding section titles");
	
	// Create an index of the sections
	ICP.instance.logger.debug("+Creating section index");
	var indexHtml = "";
	$("#icp_view_overview .icp_container:first .icp_prd_ov_section").each(function() {
		var clazz = $.grep($(this).attr("class").split(/\s+/), function(item) { return !item.match(/section/); });
		if (clazz.length > 0) {
			var sectionName = clazz[0].substring(clazz[0].lastIndexOf("_")+1);
			indexHtml += "<a idref=\""+clazz+"\" href=\"javascript:void(0)\">"+sectionName.substring(0,1).toUpperCase()+sectionName.substring(1)+"</a>";
		}
	});
	ICP.instance.logger.debug(" Inserting section index");
	// Insert the section index
	$("#icp_content_overview").prepend("<div class=\"icp_section_index\">"+indexHtml+"<div>");
	// Make the index elements clickable
	ICP.instance.logger.debug(" making section index clickable");
	$("#icp_content_overview .icp_section_index a").click(function() {
		ICP.instance.selectInView("."+$(this).attr("idref")).get(0).scrollIntoView();
	});

	ICP.instance.logger.debug("-Creating section index");
	
	// Make the section title clickable to collapse the section
	ICP.instance.logger.debug("+Making section titles clickable");
	$("#icp_view_overview .icp_prd_ov_section .title").click(function() {
		$(this).siblings("div:last").slideToggle("slow");
	});
	ICP.instance.logger.debug("-Making section titles clickable");
	
	// Install tooltip for UnitOfMeasure
	ICP.instance.logger.debug("+Install tooltip for UnitOfMeasure");
	$("#icp_view_overview .icp_uom").tooltip({
		showURL: false,
		bodyHandler: function(e) { return $(this).next(".icp_fulluom").eq(0).html(); },
		track: false,
		fade: 250,
		id: "icp_tooltip"
	});
	ICP.instance.logger.debug("-Install tooltip for UnitOfMeasure");
	
	//ICP.instance.registerCallback("overview", "updateItemInView", icp_update_item_in_view_prd_overview);
	//if (ICP.instance.currentView === "overview")
	//	icp_update_item_in_view_prd_overview(ICP.instance.getItemInView("overview"));

	ICP.instance.logger.debug("Leave icp_init_view_product_overview()");
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
//function icp_update_item_in_view_prd_overview(itemId) {
//}

$(document).ready(icp_init_view_product_overview);
