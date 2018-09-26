function $t(id) { return document.getElementById(id); }
function showHideMenu(id) {
	var tmp = $t(id);
	$('.menublock').fadeOut('normal');
	tmp.style.display = "inline";
}
function hideMenu(id) {
	$(id).fadeOut('normal');
}
function globalNavOver(id) {
	tmp = $t(id);
	tmp.style.backgroundColor = "#0b5ed7";
	tmp.firstChild.style.color = "#ffffff";
	var expiryTimer = setTimeout("globalNavOut(" + id + ")",400);
	tmp.onmouseover = function() {
		clearTimeout(expiryTimer);
	}
}
function globalNavOut(id) {
	tmp = $t(id);
	tmp.firstChild.style.color = "#333";
	tmp.style.backgroundColor = "transparent";
}
function convertToNumber(strWidth){
    return strWidth.replace("px", "")-0;
}
jQuery(document).ready(function(){
	var liWidth = 0;
	jQuery('#p-body .topnav #globalnav > li').each(function(){
		liWidth = liWidth + convertToNumber(jQuery(this).css('width'));
	});
	jQuery('#p-body .topnav').css({'left': ((960-liWidth)/2) + 'px'});
});