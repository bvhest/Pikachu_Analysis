/**
* @author Coen van der Maade
* @version $Id: global.js,v 1.31 2007/11/06 09:22:51 jkennedy Exp $
*/

/* Functionality to toggle on and off the checkboxes in the club_philips_my_email_preferences fragment */
function toggleOverallInterest() {
  var forms = document.getElementsByTagName("form");
  for (var i=0; i<forms.length; i++){
	if (forms[i].name == "mySubscriptions.form"){
		var form_name = "mySubscriptions.form";
	}
	else{
		var form_name = "registration";
	}
  }
  if (document[form_name].interestConsumerElectronics.checked ||
      document[form_name].interestHouseholdProducts.checked   ||
      document[form_name].interestPersonalCareMale.checked    ||
      document[form_name].interestPersonalCareFemale.checked  ||
      document[form_name].interestKitchenAppliances.checked)
      { (document[form_name].interestNonStreamium.checked = true);}
  else {
  (document[form_name].interestNonStreamium.checked = false);
  }    
}

function toggleInterestNonStreamium() {
  var forms = document.getElementsByTagName("form");
  for (var i=0; i<forms.length; i++){
	if (forms[i].name == "mySubscriptions.form"){
		var form_name = "mySubscriptions.form";
	}
	else{
		var form_name = "registration";
	}
  }
  state = document[form_name].interestNonStreamium.checked;
  document[form_name].interestConsumerElectronics.checked = state;
  document[form_name].interestHouseholdProducts.checked = state;
  document[form_name].interestPersonalCareMale.checked = state;
  document[form_name].interestPersonalCareFemale.checked = state;
  document[form_name].interestKitchenAppliances.checked = state;
}
/* End functionality to toggle on and off the checkboxes in the club_philips_my_email_preferences fragment */

function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if (pair[0] == variable) {
      return pair[1];
    }
  } 
  return "";
}


function updateLayout(){
	centerOnScreen();
	hideAllMenus();
	sZ(gE('nav'),1)
	sE(gE("container"));
	sE(gE("head"));
}

function centerOnScreen(){
	var containerDiv = gE('container');
	var headerDiv = gE('head');

	var x = getInnerWidth(self)/2 - 385;
	sX(containerDiv, x);
	sX(headerDiv, x);
}

function getInnerWidth(win) {
  var winWidth;
  if (document.compatMode == "CSS2Compat" || navigator.userAgent.indexOf('Gecko') != -1) {
    winWidth = parseInt(win.document.defaultView.getComputedStyle(document.documentElement, null).getPropertyValue("width"));
  }
  else if (document.compatMode == "CSS1Compat") {
    winWidth = win.document.documentElement.clientWidth;
  }
  else if (navigator.appName == 'Netscape') {
    winWidth = win.innerWidth;
  }
  else {
    winWidth = win.document.body.clientWidth;
  }
  return winWidth;
}

function getInnerHeight(win){
  var winHeight;

  if (document.compatMode == "CSS2Compat" || navigator.userAgent.indexOf('Gecko') != -1) {
	winHeight = parseInt(win.document.defaultView.getComputedStyle(document.documentElement, null).getPropertyValue("height"));
  }
  else if (document.compatMode == "CSS1Compat") {
    winHeight = win.document.documentElement.clientHeight;
  }
  else if (navigator.appName == 'Netscape') {

    winHeight = win.innerHeight;
  }
  else {
    winHeight = win.document.body.clientHeight;
  }
  return winHeight;
}


function getOffsetTop(anchorName, layerRef, deep) {
	if (document.layers){
		return layerRef.document.anchors[anchorName].y;
   }
	else {
      if (document.all) {
         var element = document.all[anchorName];
      }
      else {
         element = document.getElementById(anchorName);
      }
		var offsetTop = 0;

      do {
         offsetTop += element.offsetTop;
         element = element.offsetParent;
      } while (deep == true && element != document.body && element != null);
      return offsetTop;
	}
}

function getOffsetWidth(anchorName, layerRef, deep) {
	if (document.layers){
		return layerRef.document.anchors[anchorName].x;
   }
	else {
      if (document.all) {
         var element = document.all[anchorName];
      }
      else {
         element = document.getElementById(anchorName);
      }
		var offsetWidth = 0;

      do {
         offsetWidth += element.offsetWidth;
         element = element.offsetParent;
      } while (deep == true && element != document.body && element != null);
      return offsetWidth;
	}
}

function testOut(){
	var out = ""
	for(x=0;x<testOut.arguments.length;x++){
		out += testOut.arguments[x] + ": ";
		out += eval(testOut.arguments[x]) + "\n ";
	}
	wH(gE("testdiv"), "<span style=\"color:green\">" + out + "</span>");
}

function getSessionIdFromURL(){
  var sessionid="";
  if (document.cookie.indexOf("jsessionid") == -1) {
    var re = new RegExp(/(;jsessionid=\w+)[;?].*/);
    var m = re.exec(document.location.href);
    if (m!=null && m.length>0){
      sessionid = m[1];
    }
  }
  return sessionid;
}

function getCatalogLocaleWhenCookiesDisabled(){
  var result = "";
  if (document.cookie.indexOf("jsessionid") == -1) {
    var re = new RegExp(/(country=\w+).*/);
    var m = re.exec (document.location.href);
    if (m!=null && m.length>0){ result +=m[1];}
    re = new RegExp(/(language=\w+).*/);
    m = re.exec (document.location.href);
    if (m!=null && m.length>0){result +="&"+m[1];}
    re = new RegExp(/(catalogType=\w+).*/);
    m = re.exec (document.location.href);
    if (m!=null && m.length>0){result +="&"+m[1];}
  }
  return result;
}

function openNewWindow(url){
	window.open(url);
}
/* Check if there is a shopping cart then open a new popup window with the given URL*/
/* TODO: Check is this function is used because check is not necessary because of popup basket stays available in originale window.*/
function checkCartStatus(url){
	if(document.getElementById("leaveDomain")){
		if(!confirm(document.getElementById("leaveDomain").innerHTML)){
			return;
		}
		 openNewWindow(url); 
	}
	 openNewWindow(url); 
}


/* 
	Check if the language or country changes. 
*/
function checkForCountryLanguageSwitch(open_link){
	/*	If the to link contains 'setLocale' the country/language dropdown is used so the country or language changes
		return false because the function setlocale in the lib_global.js will call the switchHandler again and then the empty
		basket popup will show. So we don't have to show it now
	*/
	if(open_link.match("setlocale")!= null){
		return false;
	}
	/* 
		Compare the country and language parameters in the present URL with the country and language parameters in the target URL.
		If they are the same return false otherwise return true.
		Get the country and language from the target URL.
	 */
	if(open_link.indexOf("?")!=-1){
		/* Get the country and language from the target URL. */
		var toQuery = open_link.split("?");
		var toQueryParams = toQuery[1].split("&");
		for (var i = 0; i < toQueryParams.length; i++){
			var pos = toQueryParams[i].indexOf('=');
			var toLanguage;
			var toCountry
			if (pos != -1 && (toQueryParams[i].match("language") || toQueryParams[i].match("country"))){
				if (toQueryParams[i].substring(0,pos) == "language"){toLanguage = toQueryParams[i].substring(pos+1);}
				if (toQueryParams[i].substring(0,pos) == "country"){toCountry = toQueryParams[i].substring(pos+1);}
			}
			/* 
				If no language and country available in the query param try to get them using _page.getlocale() from lib_global.js
				Added to also support the CPEP site (since CPEP doesn't have a country and language in the query params.)
			*/
			else if(toLanguage == null || toCountry == null){
				var locale = _page.getlocale();
				var pos = locale.indexOf('_');
				toCountry = locale.substring(0, pos).toUpperCase();
				toLanguage = locale.substring(pos+1);
			}
		}
		/* Get the country and language from the current URL. */
		var orgQuery = location.search.substring(1);
		var orgQueryParams = orgQuery.split("&");
		for (var i = 0; i < orgQueryParams.length; i++){
			var pos = orgQueryParams[i].indexOf('=');
			var orgLanguage;
			var orgCountry;
			if (pos != -1 && (orgQueryParams[i].match("language") || orgQueryParams[i].match("country"))){
				if (orgQueryParams[i].substring(0,pos) == "language"){orgLanguage = orgQueryParams[i].substring(pos+1);}
				if (orgQueryParams[i].substring(0,pos) == "country"){orgCountry = orgQueryParams[i].substring(pos+1);}
			}
			/* 
				If no language and country available in the query param try to get them from the cookie	(catalogLocale)
				Added to also support the CPEP site (since CPEP doesn't have a country and language in the query params.)
			*/
			else if(orgLanguage == null || orgCountry == null){
				var start = document.cookie.indexOf("catalogLocale=");
				if(start!=-1){
					start += 14;
					var end = start +5;
					locale=document.cookie.substring(start,end);
					var pos = locale.indexOf('_');
					orgCountry = locale.substring(0, pos).toUpperCase();
					orgLanguage = locale.substring(pos+1);
				}
			}
		}
		/* Compare the language and country. */
		if(toLanguage != null && orgLanguage != null && toCountry  != null && orgCountry != null){
			if (toLanguage != orgLanguage || toCountry != orgCountry){
				return true;
			}
			else {
				return false;
			}
		}
	}
	/*
		When the target URL does not contain 'setLocale' and does not have any parameters we return false.
		There might be extra checks (for new links) added in the future.
	*/
	else{
		return false;
	}
}

/* Check of given URL goes outside the /consumer domain or not. */
function checkIfExternalLink(open_link){
	/* First check if the link stays in the total philips domain */
	/* _page.setlocale and /ConsumerLanding.go are special links used by the consumersite */
	if (open_link.match("philips.com") || open_link.match("_page.setlocale") || open_link.match("/ConsumerLanding.go") || open_link.match("/Group.go") || open_link.match("/ClubPhilips.go")){
		/* Next check if the link stays in the consumer or entertainment domain */
		/* gdc1.ce and added for testing purposes and can be either extended or removed in the future */
		if (open_link.match("consumer") || open_link.match("entertainment") || open_link.match("gdc1.ce") || open_link.match("nlyehvsce5ws") 
		|| open_link.match("_page.setlocale") || open_link.match("/ConsumerLanding.go") || open_link.match("/Group.go") || open_link.match("/ClubPhilips.go")){
			
			return false;
		}
		
		return true;
	}else{
	
		return true;
	}
}

/* Explicitly empty the shopping cart.*/
function emptyCart(){
	var form = document.getElementById('emptyBasket');
	if (form != null){
	 form.submit();
	}
}

/*	Override of the GBM switchHandler */ 
function EplatformSwitchhandler(open_link, target, language_switch){
	/* 
		EPlatform code, checks if the shopping cart has items, if the link is external and if the target is not a new window.
		If all those are true it shows a confirm box warning the user his cart will be emptied if he continues.
	 */
	if(document.getElementById("shoppingCartActive") && document.getElementById("leaveDomain") && (target == "" || target =="_self")){
		/* Check if the target link is an external link. */
		if(checkIfExternalLink(open_link)){
			var message = "leaveDomain";
		}
		/* 
			Check if the country or the language changes when moving to target link. 
			If there is already a message available use that one.
		*/
		if (checkForCountryLanguageSwitch(open_link) && message !="leaveDomain") {
			var message = "shoppingCartActive";
		}	
		/* If message not empty show pop-up. */
		if (message && message != ""){
			if(!confirm(document.getElementById(message).innerHTML)){
				return false;
			}
		/* When popup is confirmed empty the shopping cart.. */	
		emptyCart();
		}
	}
	/* GBM code from the original switchHandler */
	// Check if there is a language switch
	if(language_switch=="" || typeof(language_switch)=="undefined"){
		open_page = true;
	}else{
		// Check if person wants to switch language
		if(confirm(_page.text["confirmation2"].replace("{LANGUAGE}", language_switch))){
			open_page = true;
		}else{
			open_page = false;
		}
	}
	if(open_page){
		if(target=="" || typeof(target)=="undefined"){
			// Open in same window if no extra parameters are send
			target = "_self";
			extra = "";
		}else if(target=="popup"){
			target = "_blank";
			extra = "height=500,width=700,toolbar=yes,scrollbars=yes";
		}else{
			extra="";
		}
		w=window.open(open_link, target, extra);
	
		if(target=="popup"){
			//Center popup window
			var intwidt;
			var intheight;
			intwidth=screen.availWidth;
			intheight=screen.availHeight;
			intwidth=parseInt(intwidth);
			intheight=parseInt(intheight);
			if(intwidth>0&&intheight>0){
				w.moveTo(((intwidth-popup_width) / 2), ((intheight - popup_height) / 2));
				w.focus();
			}
		}
	}else{
		// Don't follow link
		//return false;
	}
	/* END OF: GBM code from the original switchHandler */
	return false;
}	

/*	END OF: Overrides the GBM switchHandler to add a check if the cart is empty before moving another localation, 
 *	if it is not, gives the option of clearing the cart to continue or cancelling the request.
*/ 

//function search(){
//	var form = document.getElementById("searchform");
//	var inputs = form.getElementsByTagName("input");
//	for (var i=0; i<inputs.length; i++){
//		if (inputs[i].name == "q"){
//			search_value = inputs[i].value;
//		}
//		else if (inputs[i].name == "s"){
//			search_division = inputs[i].value;
//		}
//	}
//	/*var search_division = document.getElementById("s").value;*/
//	/* encode the search value as it might contain special characters, which don't work in IE */
//	var encoded_search_value = encodeURI(search_value);
//	query = "q=";
//	query += encoded_search_value;
//	query += "&s=";
//	query += search_division;
//	query += "&l=";
//	if (getQueryVariable("country") != "" || getQueryVariable("language") !=""){	
//		query += getQueryVariable("country").toLowerCase() + "_" + getQueryVariable("language").toLowerCase();
//	}
//	else{
//		query += "global";
//	}
//	query += "&language=";
//	query += getQueryVariable("language").toLowerCase();
//	query += "&country=";
//	query += getQueryVariable("country").toUpperCase();
//	query += "&catalogType=";
//	query += getQueryVariable("catalogType");
//	
//	window.location= "/consumer/search/search_results.jsp?" + query;
//}
//_page.searchHandler = search

		
// take an array and resort it so that the supplied split point is the
// first item in the array, with the items before the split point
// added behind
// mode determines what to return - 0 returns concat array, -1 returns
// slice before the splitpoint, and 1 returns the after slice
function resort(array, splitpoint, mode){
	var start = array.slice(splitpoint);
	var finish = array.slice(0, splitpoint);
	var returnable = mode == 0 ? start.concat(finish):mode > 0 ? start:finish;
	return returnable;
}
// takes an array of (months or years), and writes them out as a string
// of options, whose value and code is identical
function writeOptions(array, selected){
	var optionsString = "";
	for(var index = 0; index < array.length; index++ ){
		optionsString+="<option ";
		if( array[index] == selected ){
			optionsString+="selected "
		}
		optionsString+="value=\""+array[index]+"\" >"+array[index]+"</option>";
	}
	return optionsString;
}

//This was added for the Brazil "pop-up" banners that were included for CPEP rel 3
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_showHideLayers() { //v6.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}

function processSubmitBanner(id,url,myForm) {

     if (myForm == 'banner1') {

         document.forms.banner1.serviceId.value=id;   
   	     document.forms.banner1.serviceUrl.value=url; 		   		
   	     document.forms.banner1.submit();
     }
     if (myForm == 'banner2') {

         document.forms.banner2.serviceId.value=id;   
   	     document.forms.banner2.serviceUrl.value=url; 		   		
   	     document.forms.banner2.submit();
     }

   	
}


/*	THE CODE BELOW USE JQURY JAVASCRIPT LIBRARY !!!!!!

	Check www.jquery.com for the latest version to download and to see 
	documentation on how to use.
*/
 
/* 
	Iterates through elements (with the class/id pattern passed as param) 
	and returns the value of the tallest (height) element.
	This can then be used (by the following function) to set ALL of the 
	specified elements to the same height so we don`t have layout issues.
*/
function getHighestElement(Element) {
	var j = jQuery.noConflict();
	var tallestElement = 0;
	j(Element).each(function(i) {
		var currElemHeight = j(this).height();
		if(currElemHeight > tallestElement){
			tallestElement = currElemHeight;
		}
	})
	return tallestElement;
}
/*
	This function uses the above funtion to get the highest pixel value for
	the passed element. It then sets ALL of those elements in the page to the 
	same height.
*/
function setHighestDiv(Element) {
	var j = jQuery.noConflict();
	var heightToSet = getHighestElement(Element);
	//console.log(heightToSet);
	j(Element).each(function(i) {
		j(this).height(heightToSet);
	})
}

// Used to hide the popup layer on the product detail page
function pceHideMe(layer) { 
	if($.browser.msie || $.browser.safari) {
		$( function() { $(layer).hide(); } ); 
	} else {
		$(layer).fadeOut("slow");
	}
	
}
// Below: functions used in series page
function showallseries(obj1,obj2)
{
 var objdetail1 = document.getElementById(obj1);
 var objdetail2 = document.getElementById(obj2);
  objdetail2.style.display = 'block';
  objdetail1.style.display = 'none';
}
function pcePopuplyr(arg1,arg2,arg3,arg4) {
	pageToLoad = "/consumer/common/fragments/pLayer_glossary.jsp?categoryid="+arg3+"&featureid="+arg4;
	
	/*
		if glassary-popuplayer exists, clear content and load new.
	*/
	var glossaryLayer = $("#glossary-popuplayer");
	if($(glossaryLayer).length > 0) {
		glossaryLayer.remove();
	}
	$("body").append("<div id='glossary-popuplayer'></div>");
	$("#glossary-popuplayer").load(pageToLoad,
		{	"titletext":arg1,
			"imageurl":arg2,
			"bodytext":arg3
		})	
	if($.browser.safari) {
		$( function() { $("#glossary-popuplayer").show(); } ); 
	} else {
		$("#glossary-popuplayer").fadeIn(50);
	}
    centerPosition('#glossary-popuplayer')
}
function centerPosition(objlyr)
{
	var j = jQuery.noConflict();
	var screenCenter = screen.width / 2;
	var centerPos = screenCenter -  (j(objlyr).width()/ 2);
   	j(objlyr).css({left:centerPos, top:200});
   	window.scrollTo(0,0);
}
function closeit() {
	pceHideMe('#glossary-popuplayer');
	$("#glossary-popuplayer").remove();
}
// Above: functions used in series page

/* 
* 	Positions the where to buy button
*  	Takes the current width of the page and the button and calculates where it should sit on the right hand side.
*  	Also, moves the button down in the page if there is a header banner in the page.
*/ 

var alreadyPositioned = false;
function positionWhereToBuy() {
	if(!alreadyPositioned) {
		var j = jQuery.noConflict();
		var minimumBuyWidth = 170;
		var where2buyTop = 100;
		var pageStartPos = $("#p-body-content").offset({scroll:false}).left;
		var pagewidth = j("#p-body-content").width();
		var where2buyButtonWidth = j(".where2buy").width();
		if(where2buyButtonWidth < minimumBuyWidth) {
			where2buyButtonWidth = minimumBuyWidth;
			j(".where2buy").width(minimumBuyWidth);
		}
		var where2buyLeft = (pageStartPos + pagewidth) - (where2buyButtonWidth + 15);
		if(j(".headerItem").size() > 0 ) { where2buyTop = 152 }
		j(".where2buy>dd").css({width:where2buyButtonWidth});
		j(".where2buy").fadeIn(100).css({left:where2buyLeft, top:where2buyTop});
		
		// if price is in page, position it!
		if(j("#productsummary p.sugRetailPrice").is("p")) {
			positionPrice(where2buyLeft, where2buyTop);
		}
		alreadyPositioned = true;
	}
}

function positionPrice(where2buyLeft, where2buyTop) {
	var j = jQuery.noConflict();
	var priceWidth = j("#productsummary p.sugRetailPrice").width();
	var posLeft = where2buyLeft - (priceWidth + 15);
	if(j.browser.mozilla || j.browser.safari) {
		var posTop = where2buyTop-8;
	} else {
		var posTop = where2buyTop + 3;
	}
	j("#productsummary p.sugRetailPrice").show().fadeIn(3000).css({left:posLeft, top:posTop});
}

// closes the movie window
function closeMovie() {
	$("#movieLayer").fadeOut("slow");
	$("#movieLayer").remove();
}

// closes the 360view window
function close360view() {
	$("#viewLayer360").fadeOut("slow");
	$("#viewLayer360").remove();
}

// position where to buy for product detail page
function positionPdpWhereToBuy() {
	if(!alreadyPositioned) {
		var j = jQuery.noConflict();
		var minimumBuyWidth = 170;
		var where2buyTop = 100;
		var pageStartPos = $("#p-body-content").offset({scroll:false}).left;
		var pagewidth = j("#p-body-content").width();
		var where2buyButtonWidth = j(".pdpwhere2buy").width();
		if(where2buyButtonWidth < minimumBuyWidth) {
			where2buyButtonWidth = minimumBuyWidth;
			j(".pdpwhere2buy").width(minimumBuyWidth);
		}
		var where2buyLeft = (pageStartPos + pagewidth) - (where2buyButtonWidth + 15);
		if(j(".headerItem").size() > 0 ) { where2buyTop = 152 }
		j(".pdpwhere2buy>dd").css({width:where2buyButtonWidth});
		j(".pdpwhere2buy").fadeIn(100).css({left:where2buyLeft, top:where2buyTop});
		
		// if price is in page, position it!
		if(j("#productsummary p.sugRetailPrice").is("p")) {
			positionPrice(where2buyLeft, where2buyTop);
		}
		alreadyPositioned = true;
	}
}
// closes the Buy layer window
function closeBuy() {
	$("#buyLayer").fadeOut("slow");
	$("#buyLayer").remove();
}

// checking the PDP bottom active
var pdpactvBuybutton = false;
function chkbuybtn(optn) {
	if (optn=='1') {
		pdpactvBuybutton = true;
	}
	else {
		pdpactvBuybutton = false;
	}
	return;
}

// checking the Decision page bottom alignment
var dpBuyPositioned = false;
var divelemtopposition, pdtlyrid, pdtlyrhght
function dpBuylyrpositon(optn,postnval,lyrid) {
	if (optn=='1') {
		dpBuyPositioned = true;
		divelemtopposition=postnval;
		pdtlyrid = lyrid.id
		pdtlyrhght = lyrid.offsetHeight
	}
	else {
		dpBuyPositioned = false;
		divelemtopposition=postnval;
	}
	return;
}

//sets page output preference for this session to HTML, suppresses flash version check and closes popup layer
function stopFlashDetection() {
	$.post("/consumer/common/fragments/page_output_preference.jsp",  { pageOutputPreference: "FLASH", offerFlashUpgrade: "false" });
	layer="#flashcheck"
	if($.browser.msie || $.browser.safari) {
		$( function() { $(layer).hide(); } ); 
	} else {
		$(layer).fadeOut("slow");
	}
}

//enables future flash version checks in this session and opens flash update page
function goFlashUrl()
{
	window.open('http://www.adobe.com/go/getflashplayer','','');	
	layer="#flashcheck"
	if($.browser.msie || $.browser.safari) {
		$( function() { $(layer).hide(); } ); 
	} else {
		$(layer).fadeOut("slow");
	}
	$.post("/consumer/common/fragments/page_output_preference.jsp",  { pageOutputPreference: "FLASH", offerFlashUpgrade: "true"});
}

//enables future flash version checks in this session
function setOutputPreferenceFlash() {
	$.post("/consumer/common/fragments/page_output_preference.jsp",  { pageOutputPreference: "FLASH", offerFlashUpgrade: "true" });		
}

//disables future flash version checks in this session
function setOutputPreferenceHtml() {
	$.post("/consumer/common/fragments/page_output_preference.jsp",  { pageOutputPreference: "HTML", offerFlashUpgrade: "false" });	
}

// function to create window that movies - or other elements - can be passed into.
// used as a default window to pass the product details movies into
function createVideoContainer(closeCaption) {	
    $("#tabscontent").prepend("<div id='videoPlayerContainer'><p class='closeVideoPlayer' onclick='destroyVideoContainer()'><a href='javascript:void(0)'>"+closeCaption+"</a></p><div id='p-videoPlayerContent'></div></div>");
}
// removes the video window from the DOM completely.
function destroyVideoContainer() {VideoPlayer.destroy("icp_product_video_player");}
// load the passed movie into the window
function loadMovie( jspToLoad, closeCaption, itemType, productid, featureid, language, country, catalogType, assetId ) {
    if( $("#videoPlayerContainer").length > 0 ) return false;
    createVideoContainer(closeCaption);
    $("#p-videoPlayerContent").load(jspToLoad, {"itemType":itemType, "productid":productid, "featureid":featureid, "language":language, "country":country, "catalogType":catalogType, "assetId":assetId } );
    $("#videoPlayerContainer").show();
    setPlayerPos(featureid);
    scrollTo(0,0);
}
function setPlayerPos(featureid) {
	if( featureid != "") {
		$("#videoPlayerContainer").css({marginTop:10});
	}
}
// load the galleryViewer, passing the value of the image clicked on (in the carouselViewer), so that 
// it will default to that value. function openGalleryViewer() passes these params.
function loadGallery(jspToLoad, scene7AssetId, initialAssetIndex, productid ) {
	if( $("#videoPlayerContainer").length > 0 )
		return false; 
  createVideoContainer("close");
  $("#p-videoPlayerContent").load(jspToLoad, {"scene7AssetId":scene7AssetId, "initialAssetIndex":initialAssetIndex, "productid":productid } );
  $("#videoPlayerContainer").show();
}

                                                                                                                                                                                                                              
