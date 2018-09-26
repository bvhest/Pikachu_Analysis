var locale;
function icp_init_view_range_shop() {
	var viewContainer = ICP.instance.getViewContainer("shop");
	viewContainer.find(".basefeature div.arrow").hover(
		function() {$(this).siblings("div.additional").fadeIn(500)},
		function() {$(this).siblings("div.additional").fadeOut(500)}
	);
	viewContainer.find('.extendbox .head .compare').mouseover(function(){
		if (compareCnt > 0) {
			compareOver();
		}
	});
	viewContainer.find('.compareOverlay').mouseout(function(){
		compareOver();
	});
	
	viewContainer.find('a.load-local').cluetip({sticky: false, fx: { open: 'fadeIn', openSpeed: '500' }, cursor: 'pointer', local: true, arrows: true, dropShadow: false, showTitle: false, width: 210 });

	ICP.instance.registerCallback("shop", "updateItemInView", icp_update_item_in_view_rng_shop);
	icp_update_item_in_view_rng_shop(ICP.instance.getItemInView("shop"));
}

// This function is called when an item in the index is clicked and
// the current item in view was changed
function icp_update_item_in_view_rng_shop(itemId) {
}

var compareStr = "";
var compareCnt = 0;
var maxItemsMsg = "You are limited to 3 products for comparison.";
function updateCompare(id,tmp) {
	if (id.checked) {
		if (compareCnt == 3) {
			alert(maxItemsMsg);
			id.checked = false;
		} else {
			compareCnt++;
			compareStr = compareStr + "id" + compareCnt + "=" + tmp + ";";
			ICP.instance.selectInView('.compareOverlay').append($(id).parent().parent().clone().prepend('<div class="remove"><a href="#" onclick="deleteCompare(\'' + id.name + '\'); return false;">&#160;</a></div>'));
		}
	} else {
		var tmp2;
		for (i=1; i<=compareCnt; i++) {
			tmp2 = "id" + i + "=" + tmp + ";";
			compareStr = compareStr.replace(tmp2,"");
			ICP.instance.selectInView('.compareOverlay input[name="' + id.name + '"]').parent().parent().remove();
		}
		compareCnt--;
	}
	ICP.instance.selectInView(".num_selected").html(compareCnt);
}
function deleteCompare(idname) {
	ICP.instance.selectInView('form input[name="' + idname + '"]').click();
	if (compareCnt == 0) { compareOut(); }
}
function compareLink(obj) {
}
function compareOver() {
	ICP.instance.selectInView('.compareOverlay').fadeIn(500);
	var expiryTimer = setTimeout("compareOut()",3000);
	ICP.instance.selectInView('.compareOverlay').mouseover(function() {
		clearTimeout(expiryTimer);
	});
}
function compareOut() {
	ICP.instance.selectInView('.compareOverlay').fadeOut(500);
}

$(document).ready(icp_init_view_range_shop);
