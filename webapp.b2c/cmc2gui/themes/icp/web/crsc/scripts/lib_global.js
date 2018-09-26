/*!
  * Global library Philips Internet
  * Check www.crsc.philips.com/crsc/scripts/lib_global.js for latest version
  * Version: 4.5.1
  * Build: 2
  * Date: February 18, 2009
  */

var _page;

function icp_init_view_product_website_global() {
/*
  ****************************
  *****     Global variables   *****
  ****************************
 */
_page = {
	// Locales
	topNav: [],									// Defined in locale files 
	text: [],									// Defined in locale files 
	link: [],									// Defined in locale files
	// Leftnav
	leftNav: [],  								// Store left menu values 
	leftNavItem: "",							// Current Active left menu item 
	leftNavOnload: true,						// Load leftnav onload of page
	breadCrumbItem: "",							// Current Active breadcrumb item 
	leftmenuarray: [],							// Array to store menu items
	flyoutarray: [],							// Array to store fly out items
	// Stockquotes
	values: {									// Stock quote values 
		aex:"",
		nyse:""
	},								
	locales: {},								// Stock quote values 
	showStockQuotes: false,						// Don't show stockquotes by default
	// Styles
	hideGlobalStyle: false,						// Show or hide global stylesheet
	activateActiveX: false,						// Activate active-x objects onload of page, windows IE only
	// Microsite
	showLocales: true, 							// Boolean to show the Locale selector 
	useGlobalStyle: false,						// Extra setting to allow global stylesheets in Microsite
	// Extranet
	topNavType: "",								// External extranet navigation type
	pageWidth: "800",							// Default 800x600 in extranet
	topNavXN: [],								// Defined in extranet locale files 
	supportLinks: [], 							// Multiple supportlinks in header
	customLogo: [],								// Custom logo attributes
	// Global
	area: "",									// Page area has to be defined in HTML code when creating the header
	disableBodyWrapperOutput: false,			// Allows to disable the bodywrapper html output
	showSearch: true,							// Only show stockquotes on country landing pages
	showSearchAsYouType: true,					// default show Search As You Type in the header search box
	hideFlashSectionBanner: false,				// default show flash section banner
	disableReplaceSpecialCase: false,			// default load replace speciale case on page load
	showSBFlashSectionBanner: "",				// default, don't show specialized business flash section banner
	altLocaleFlag: "",							// allow alternative locale flag (Country C)
	altLocaleText: "",							// allow alternative locale text (Country C)
	selectedLocale: "",							// allow other selected locale in localelist (Country C)
	GlobalLanguageSwitch:"",					// allow for internet header/footer links a global language switch
	loadBrowserInfo: false, 					// Tmp added
	browserInfo: [],							// Tmp added
	arrCaseMapping: [],							// Casemapping execeptions
	arrLCase: [],								// Lowercase execeptions
	arrUCase: [],								// Uppercase execeptions
	siteLevel: "", 								// Current locale site level
	siteLevelList: {							// Based on countries
		"3":["us","de","cn","gb","fr","it","br","nl","es","ru","jp","in","kr","be","se","global","ar","at","au","ca","ch","cz","dk","hk","mx","nz","pl","pt","ru","tr","tw"],
		"2":["bg","ce","cl","fi","gr","hu","ie","my","me","no","pk","ph","ro","sg","sk","th","ua","za","co","pe"],
		"1":["kz","id","uy","by","hr","lv","lt","si","uz","vn","yu","ve","ee","il"]
	},
	// Third party settings 
	loadSIFR: true,								// false, allows siteowner to disable GMM SIFR (script + config)
	loadSIFRScript: false, 						// true, allows siteowner to load the base SIFR script file for all locales without any respects to the locales
	loadSIFRConfig: true,						// false, allow siteowner to disable GMM SIFR config loading
	disabledLocalesSIFR: ["zh","ko","he","ja","cs","sk","pl","ro","ru","bg","el","th","tr","hu"],
	loadESurvey: true,
	loadOmniture: true,
	// Rescale fontsize
	articleCSSFontsizeDefault: "100",
	articleCSSFontsizeCurrent: '',
	// Settings for Special section 
	sectionMain: [],
	sectionSpecial: [],
	// Settings for rich content popup 
	popupHideHeader: false, 					// Allow disabled popup header
	popupHideFooter: false, 					// Allow disabled popup footer
	popupAutoFitWindowToContent: true,
	popupHeight: 1,
	popupWidth: 1,
	// Settings for statistics 
	statsCollector: { 							// Statistics collector
		Locale: "",								// Default value can be overruled
		PageName: ""							// Default value can be overruled0
	},
	browser: new BrowserDetect()				// Store browser properties for internal usage
},

/*
****************************
***** General settings *****
****************************
*/

// Initiate menu array
menuArray = ['about','consumer','medical','lighting'],
// Top navigation properties (old style)
topmenu_dd_spacer = 6,		// Vertical space between the topmenu buttons and the corresponding dropdowns
currSection = "", 			// The section which is currently active (clicked)
menuDown = "",				// The section which is currently highlighted (mouseover)
dropDown = 0,
hideMenu = 0,
buttonOff = 0,
section = '',
menu_hide_delay = 600, 		// Delay of hiding all drop-down menus on a mouseout of the top-menu
dropdown_show_delay = 200,	// Delay of showing the drop-down menu on a mouseover
// Miscellanous
browser = _page.browser,	// Keep another variable for compatibility
useIframe = (_page.browser.isIE5up &&  !_page.browser.isIE7up && (!_page.browser.isIE5x || _page.browser.isIE55)), // Boolean to set use of iframe behind layers, only IE 5.5 and IE 6.0
isMacIE = (_page.browser.isIE && _page.browser.isMac? true: false),
tabTables = [],				// Tabbed table array
arrLoad = [],				// Onload array
arrDOMLoad = [],			// DOM Onload array
// Stockquotes
m_iRotatorIndex = 1,		// Stockquotes rotator index 
// 1KB API shortcuts
d = document,						
l = d.layers,
op = navigator.userAgent.indexOf('Opera') !== -1,
px = 'px';
// Don't remove the end semi-colon above!!!!

// Extend _page object with properties
_page.crsc_server = get_crsc_server();  											// Get location of the Global library file. Used to determine where the files need to be included from.
_page.crsc_nav_server = get_crsc_nav_server(); 										// Force location of the nav directory to the any production / staging CRSC server.
_page.consumer_nav_server = (window.location.protocol === "https:"? "https:": "http:") + "//www.consumer.philips.com";
_page.leftNavOnload = (_page.browser.isNS && !_page.browser.isNS7up? false: true);	// Disable for Netscape version lower than 7
// Default sIFR settings (resources)
_page.sIFR = {
	"swf": {
		"GillSansLight": 	{"src": _page.crsc_server + "/crsc/images/sifr_gillsanslight_3.436.swf"}
	},	
	"js": {
		"core": 			{"src": _page.crsc_server + "/crsc/scripts/sifr-3.436.js"},
		"config": 			{"src": _page.crsc_server + "/crsc/scripts/sifr-config-3.436.js"} 
	}
}
// Allow overiding of url prefix for external scripts
_page.externalUrlPrefix = {
	"metrixLab": "http://invitation.opinionbar.com",
	"stockQuotes": "http://www.stockquotes.philips.com"
}

//Temp list till this is updated in Locale files
_page.countries = {};
_page.languages = {};
_page.countries = {
	"ar":"Argentina",
	"au":"Australia",
	"at":"Austria",
	"be":"Belgium",
	"bg":"Bulgaria",
	"br":"Brazil",
	"ca":"Canada",
	"ce":"Central America",
	"cl":"Chile",
	"cn":"China",
	"co":"Colombia",
	"hr":"Croatia",
	"cu":"Cuba",
	"cy":"Cyprus",
	"cz":"Czech Republic",
	"dk":"Denmark",
	"ee":"Estonia",
	"eg":"Egypt",
	"fi":"Finland",
	"fr":"France",
	"de":"Germany",
	"gr":"Greece",
	"hk":"Hong Kong",
	"hu":"Hungary",
	"is":"Iceland",
	"in":"India",
	"id":"Bahasa Indonesia",
	"ir":"Iran",
	"iq":"Iraq",
	"ie":"Ireland",
	"il":"Israel",
	"it":"Italy",
	"jp":"Japan",
	"kr":"Korea",
	"lt":"Lithuania",
	"lu":"Luxembourg",
	"lv":"Latvia",
	"my":"Malaysia",
	"mx":"Mexico",
	"me":"Middle East and Africa",
	"ma":"Morocco",
	"nl":"Netherlands",
	"nz":"New Zealand",
	"no":"Norway",
	"om":"Oman",
	"pk":"Pakistan",
	"pe":"Peru",
	"ph":"Philippines",
	"pl":"Poland",
	"pt":"Portugal",
	"ro":"Romania",
	"ru":"Russian Federation",
	"sa":"Saudi Arabia",
	"sg":"Singapore",
	"sk":"Slovakia",
	"si":"Slovenia",
	"za":"South Africa",
	"es":"Spain",
	"se":"Sweden",
	"ch":"Switzerland",
	"tw":"Taiwan",
	"th":"Thailand",
	"tn":"Tunisia",
	"tr":"Turkey",
	"ua":"Ukraine",
	"ae":"United Arab Emirates",
	"gb":"United Kingdom",
	"us":"United States",
	"uy":"Uruguay",
	"ve":"Venezuela"
}
_page.languages = {
	"bg":"\u0411\u044A\u043B\u0433\u0430\u0440\u0441\u043A\u0438",
	"cs":"\u010Ce\u0161tina",
	"da":"Dansk",
	"de":"Deutsch",
	"el":"\u0395\u03BB\u03BB\u03B7\u03BD\u03B9\u03BA\u03AE",
	"en":"English",
	"es":"Espa\u00F1ol",
	"et":"Eesti keel",
	"fi":"Suomeksi",
	"fr":"Fran\u00E7ais",
	"he":"\u05E2\u05D1\u05E8\u05D9\u05EA",
	"hr":"Croatian",
	"hu":"Magyar",
	"id":"Indonesian",
	"it":"Italiano",
	"ja":"\u65E5\u672C",
	"ka":"Georgian",
	"ko":"\uD55C\uAD6D\uC5B4",
	"lt":"Lietuvi\u0173",
	"lv":"Lietuvi\u0173",
	"my":"Burmese",
	"nl":"Nederlands",
	"no":"Norsk",
	"pl":"Polski",
	"pt":"Portugu\u00EAs",
	"ro":"Rom\u00E2n\u0103",
	"ru":"\u0420\u0443\u0441\u0441\u043A\u0438\u0439",
	"sk":"Sloven\u010Dina",
	"sv":"Svenska",
	"th":"\u0E44\u0E17\u0E22",
	"tr":"T\u00FCrk\u00E7e",
	"zh":"\u4E2D\u6587",
	"za":"Chuang"
}
//End Temp list

// Update stockquotes	
_page.updateStockQuote = function() {
	var stockQuotes, sStockValue, sStockPrice, sStockExchange, current_language, new_language;
	if(_page.values["aex"]!=""){
		// Only show if data is available
		if( m_iRotatorIndex == 1 ){
			m_sStockQuoteTargetURL = "http://www.stockquotes.philips.com/asp/ir/philips_newdesign.aspx?market=0"; 
			sStockValue = "EUR";
			sStockPrice = _page.values["aex"];
			sStockExchange = "AEX";
		}
		else if( m_iRotatorIndex == 2 ){
			m_sStockQuoteTargetURL = "http://www.stockquotes.philips.com/asp/ir/philips_newdesign.aspx?market=1"; 
			sStockValue = "US$";
			sStockPrice = _page.values["nyse"];
			sStockExchange = "NYSE";
		}
		// Check if alert should be shown that language is not English
		current_language = _page.locale.substring(3,5);
		if(current_language!="en" && _page.locale!="global"){
			// Get translated version of English
			new_language=_page.text["lang_en"];
		} else{
			new_language = "";
		}
		if(!(_page.browser.isMac && _page.browser.isIE5x)){
			//Don't show stockquotes on Mac/IE5
			stockQuotes = gE("p-stockquotes");
			if(stockQuotes) {
				stockQuotes.innerHTML = "<nobr><b>" + sStockExchange + "</b>&nbsp;|&nbsp;<a href=\""+m_sStockQuoteTargetURL+"\" onclick=\"return _page.switchHandler('"+m_sStockQuoteTargetURL+"', '', '"+new_language+"')\">" + sStockValue +"</a>&nbsp;"+sStockPrice+"</nobr>";
			}
		}
		m_iRotatorIndex++;		
		if(m_iRotatorIndex > 2){
			m_iRotatorIndex = 1;
		}
		setTimeout("_page.updateStockQuote()",6000);
	}	
};

// This function will open the standard search application. This function can be overruled.
_page.searchHandler = function (searchform_id) {
	var elWarning, elQuery, evtClick, evtKeydown,
	showWarning = function () {
		elWarning = elWarning || gE('p-header-warning-search');
		elQuery = elQuery || gE('p-searchquery');
		if (elWarning && elQuery) {
			dE(elWarning);
			_page.Events.cancel(); // avoid any bubbling of click events
			evtClick = _page.Events.add(document,"click",hideWarning);
			evtKeydown = _page.Events.add(elQuery,"keydown",hideWarning);
		}	
	},
	hideWarning = function () {
		elWarning = elWarning || gE('p-header-warning-search');
		if(elWarning) {
			nE(elWarning);
			_page.Events.removeSafe(evtClick);
			_page.Events.removeSafe(evtKeydown);
		}		
	};
	return function () {
		var sMsg, elParent, elSearch, strMatch;
		// Create and show warning element
		sMsg = _page.text["search_input"] || "";
		if (!elWarning && sMsg !== "") {
			elWarning = document.createElement("div");
			elWarning.id = "p-header-warning-search";
			//elWarning.innerHTML = "<b></b><strong class=\"p-content\">"+sMsg+"</strong><b></b>";
			elWarning.innerHTML = "<div><strong class=\"p-content\">"+sMsg+"</strong></div>";
			elParent = gE('p-header-search');
			if(elParent) {
				elParent.appendChild(elWarning);
			}
		}
		elSearch = gE("searchform");
		if (elSearch) {
			strMatch  = trim(elSearch.q.value);
			if (trim(_page.text["searchlabel"]) === strMatch || strMatch === "") {	
				showWarning();
				elSearch.q.focus();
			} else {
				// Set new form attributess
				elSearch.action = "http://www.search.philips.com/search/search";
				elSearch.method = "GET"
				elSearch.acceptCharset = "UTF-8";		
				// Submit form
				elSearch.submit();
			}
		}
	}
}();

_page.switchHandler = function (open_link, target, language_switch) {
	// This function will open the links clicked in the header and footer. This function can be overruled.
	// Check if there is a language switch
	var open_page = false, extra, w, intwidth, intheight;
	if(language_switch=="" || typeof(language_switch)=="undefined"){
		open_page = true;
	} else {
		// Check if person wants to switch language
		if(confirm(_page.text["confirmation2"].replace("{LANGUAGE}", language_switch))){
			open_page = true;
		} else {
			open_page = false;
		}
	}
	if(open_page){
		if(target == "" || typeof(target) == "undefined") {
			// Open in same window if no extra parameters are send
			target = "_self";
			extra = "";
		} else if(target == "popup") {
			target = "_blank";
			extra = "height=500,width=700,toolbar=yes,scrollbars=yes";
		} else {
			extra="";
		}
		w=window.open(open_link, target, extra);		
		if(target=="popup"){
			//Center popup window
			intwidth = parseInt(screen.availWidth);
			intheight = parseInt(screen.availHeight)
			if(intwidth>0&&intheight>0){
				w.moveTo(((intwidth-popup_width) / 2), ((intheight - popup_height) / 2));
				w.focus();
			}
		}
	} 
	// Return false to make sure links in a href are not followed
	return false;
};

_page.setlocale = function (locale, url) {
	// Set cookie with user locale
	// Check if currently on philips.com domain
	var newLink, current_url, x, y, expires, new_str, str;
	newLink = escape(url || getLocaleURL(locale));
	current_url = escape(window.location);
	x = current_url.indexOf("philips.com/"); 
	y = current_url.indexOf("philips.com%3A"); // allow philips with port
	if(x!=-1 || y!=-1 ){
		// Set cookie when on philips.com domain
		expires = new Date();
		expires.setFullYear(expires.getFullYear()+1);
		new_str = "Philips=userlocale=" + locale + ";expires="+expires.toGMTString()+";path=/;domain=philips.com";
		document.cookie = new_str;
		// Redirect to site using the switchHandler function
		_page.switchHandler(unescape(newLink), "");
	} else{
		//create unique code to protect caching
		str = Math.round(Math.random()*100000).toString();
		// Set cookie on philips.com domain
		document.write("<script language=\"Javascript\" type=\"text/javascript\" src=\"http://www.crsc.philips.com/cookie/setcookie.asp?LocaleID="+locale+"&URL="+newLink+"&random="+str+"\"></script>");
	}
};

_page.changelocale = function (locale, url) {
	var strCheckLocale, newLink, blnRedirect;
	// Check if new country selected
	strCheckLocale = (_page.selectedLocale!=""?_page.selectedLocale:_page.locale);
	// Redirect to site with new Locale	
	newLink = url || getLocaleURL(locale);
	if(locale == "") {
		// No Locale selected
		alert(_page.text["alert2"]);
	} else if(locale == strCheckLocale) {
		// User is switching to the Locale that he is already using
		alert(_page.text["alert1"]);
	} else {
		blnRedirect = false;
		if(locale!="others") {
			// Check if the user want to save this Locale
			// The function will also redirect the user
			if(confirm(_page.text["confirmation1"])) {
				// Set locale
				_page.switchHandler("Javascript:_page.setlocale('"+locale+"','"+newLink+"');", "");
			} else {
				blnRedirect = true;
			}
		} else {
			blnRedirect = true;
		}
		if(blnRedirect) {
			// Redirect to site using the switchHandler function
			_page.switchHandler(newLink, "");
		}
	}
};

_page.getlocale = function () {
	var current_url, x, strCookie, start, end, return_cookie;
	// Check if currently on philips.com domain
	current_url = escape(window.location);
	x = current_url.indexOf("philips.com/");
	if(x!=-1){
		strCookie = unescape(document.cookie);
		start = strCookie.indexOf("userlocale=");
		if(start!=-1){
			start += 11;
			end = start +5;
			if(strCookie.substring(start,end)=="globa"){
				return_cookie="global";
			} else{
				return_cookie=strCookie.substring(start,end);
			}
			return return_cookie;
		} else{
			return "";
		}
	} else{
		// Currently not available
		return "N/A";
	}
};

/* Helper functions */
_page.write = function (str, last_item) {
	document.write(str);
};
/* end helper functions */

_page.writeHeader = function (area) {
	var crsc, homepages, header, strLocaleText, strLocaleFlag, headerLS, strButHeader, strSearchSection, linkRegister, linkLogin, 
	f_createLink, htmlLinks, isHomepage, shopText, shopURL;
	// Settings
	_page.headerType = "internet";
	_page.siteLevel = _page.siteLevel || _page.getSiteLevelByLocale(_page.topNavLocale || _page.locale); 	
    _page.area = area;
	// Needed for header check (phased launch)
	_page.newHeaderNav = new RegExp((_page.topNavLocale || _page.locale),"i").test("gb_en,us_en,in_en,de_de,fr_fr,it_it,es_es,nl_nl,be_nl,be_fr,ru_ru,se_sv,jp_ja,kr_ko,cn_zh,br_pt,global,ca_en,ca_fr,at_de,ch_de,ch_fr,no_no,fi_fi,dk_da,tr_tr,ua_ru,pl_pl,au_en,mx_es,gr_el,hu_hu,cz_cs,za_en,bg_bg,my_en,nz_en,ph_en,pk_en,me_en,sg_en,ro_ro,sk_sk,th_th,ar_es,cl_es,ie_en,hk_en,hk_zh,tw_zh,pt_pt,ce_es,pe_es,co_es"); 
    crsc = _page.crsc_server;
	// Include stylesheets
	_page.hideGlobalStyle = false;
	include_stylesheets();
	// Include Locale redirect files
	if (area === "about" || area === "consumer" || area === "lighting" || area === "medical") {
		locales_redirect = "homepages_" + area;
	} else{
		locales_redirect = "homepages";
	}
	// Include homepages file
	homepages = "	<script type=\"text/javascript\" src=\"" + crsc + "/crsc/locales/" + locales_redirect + "\"></script>\n"
	document.write(homepages);
	// Build header
	isHomepage = (_page.getMetaElementByName("PHILIPS.METRICS.PAGENAME").content === "landing"? true: false);
    header="";
	header+="			<div id=\"p-header\">\n";
	header+="				<div id=\"p-header-wrapper\">\n";
	header+="					<a href=\"" + _page.link["home"] + "\" onclick=\"return _page.switchHandler('" + _page.link["home"] + "', '')\"><img alt=\"Philips\" src=\"" + crsc + "/crsc/images/mainlogo_full_" + _page.locale + ".gif\"  id=\"p-mainlogo\" /></a>";	
	// Language selector
	strLocaleText = _page.locale === "global"? "Choose country / language" :""; 	// In case of global change text
	strLocaleText = _page.siteLevel === 1? "Others": strLocaleText; 					// In case of level 1 set others label and flag
	strLocaleFlag = _page.siteLevel === 1? "global": "";
	headerLS = new _page.ls('2', {localeText: strLocaleText, localeFlag: strLocaleFlag});
	header+= 						headerLS.html;		
	header+="						<div id=\"p-header-features\"  >\n";
	// Search	
	if (_page.showSearch) {
		strButHeader = _page.direction === 'ltr'? "but_go.gif": "but_go_rtl.gif";
		strSearchSection = (area === "" || (area !== "consumer" && area !== "lighting" && area !== "medical" && area !== "about") ? "all" : area );
		header+="					<div id=\"p-header-search\">\n";
		header+="						<form id=\"searchform\" name=\"searchform\" action=\"javascript:_page.searchHandler();\">\n";	
		header+="							<fieldset>\n";
		header+="								<label for=\"p-searchquery\">" + (_page.text["searchlabel"] || "Search") + "</label>\n";	
		header+="								<input type=\"text\" size=\"15\" id=\"p-searchquery\" name=\"q\" class=\"p-searchfield\" value=\""+_page.text["searchlabel"]+"\" onfocus=\"this.value='';\" /><input type=\"image\" alt=\""+(_page.text["search_button"]  || "Search")+"\" class=\"p-searchsubmit\" src=\""+crsc+"/crsc/images/"+strButHeader+"\" />";
		header+="								<input type=\"hidden\" name=\"s\" value=\"" + strSearchSection + "\" />\n";
		header+="								<input type=\"hidden\" name=\"l\" value=\"" + _page.locale + "\" />\n";
		header+="								<input type=\"hidden\" name=\"h\" value=\"" + strSearchSection + "\" />\n";
		header+="							</fieldset>\n";
		header+="						</form>\n";
		header+="						<div id=\"p-search-sayt\"></div>\n";
		header+="					</div>\n";
		if ((strSearchSection === "consumer" || strSearchSection === "lighting" || strSearchSection === "all") && _page.showSearchAsYouType) {
			_page.headerSayT = new _page.Sayt("p-searchquery","p-search-sayt",{
				locale: _page.locale, 
				section: strSearchSection,
				remoteUrl: "http://www.search.philips.com/search/jsp/var_suggest.jsp",
				doSubmit: _page.searchHandler
			});
		}
	}
	// My Philips links
	if (isHomepage || area === "consumer" || area === "support") {
		linkRegister = _page.link["consumer_register"] || "";
		linkLogin = _page.link["consumer_login"] || "";
		f_createLink = _page.html_helper.topnav.createLink;
		htmlLinks = _page.text["consumer_register"] || "";
		htmlLinks = htmlLinks.replace("{REGISTER_PRODUCT}", f_createLink({href: linkRegister, name: _page.text["register_product"]}));
		htmlLinks = htmlLinks.replace("{LOGIN}", f_createLink({href: linkLogin, name: _page.text["login"]}));
		header+="					<div id=\"p-header-myphilips\">" + htmlLinks + "</div>\n";
	} 
	header+="					</div>\n";
	header+="				</div>\n";
	// Header navigation
	shopText = _page.text["ayft_tab_shop"] || "" ;
	shopURL = _page.link["ayft_tab_shop"] || "http://www.shop.philips.com";
	if (shopText !== "") {
		_page.topNav["shop"] = [[shopText, shopURL]]; // Optional shop
	}
	_page.headerNav = new _page.topNav2("p-navigator", {
		type: _page.topNavType,
		activeId: area,
		locale: _page.topNavLocale,
		compatMode: _page.topNavCompatMode,
		onBeforeBodyOpen: _page.topNavOnBeforeBodyOpen,
		onBodyClose: _page.topNavOnBodyClose
	});
	_page.headerNav.setSectionActiveId("consumer", _page.topNavConsumerActiveId);
	if (_page.topNavType !== "inbody") {
		header+="			<div id=\"p-headernav\">\n";
		header+="				<div id=\"p-headernav-wrapper\">\n";
		header+="					<div id=\"p-headernav-innerwrapper\">\n";
		header+=						_page.headerNav.html;
		header+="					</div>\n";
		header+="				</div>\n";
		header+="			</div>\n";
	} else {
		header+="				<div id=\"p-headernav-wrapper\">\n";
		header+="					<div id=\"p-headernav-innerwrapper\" >\n";
		header+= 						_page.headerNav.html;
		header+="					</div>\n";
		header+="				</div>\n";
	}
	header+="			</div>\n";
	// Second row: Body
	if (!_page.disableBodyWrapperOutput) {
		header+="			<div id=\"p-body\">\n";
		header+="				<div id=\"p-body-wrapper\">\n";
		header+="					<div id=\"p-body-innerwrapper\" class=\"p-clearfix\">\n";
		header+="						<div id=\"p-body-content\">\n";
	}
    _page.write(header, false);
	includeSIFR(); // Include SIFR
	if (_page.loadBrowserInfo) _page.setBrowserInfo();
	if (_page.activateActiveX) includeActiveXFix();
	addDOMOnLoadEvent(processTables);
	if (!_page.disableReplaceSpecialCase) addOnLoadEvent(_page.checkSpecialCase);
};

_page.writeFooter = function () {
    var language_switch, privacy_footer, strSitemapLink, strSitemapText, footer, txtBP;
	language_switch = _page.GlobalLanguageSwitch;
	privacy_footer = _page.text["footer"];
	privacy_footer = privacy_footer.replace("{BR}", "<br />");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{PRIVACY}", "<a href=\"" + _page.link["privacy"] + "\" onclick=\"return _page.switchHandler('" + _page.link["privacy"] + "','','" + language_switch + "')\">" + _page.text["privacy"] + "</a>");
	privacy_footer = privacy_footer.replace("{OWNER}", "<a href=\"" + _page.link["owner"] + "\" onclick=\"return _page.switchHandler('" + _page.link["owner"] + "','','" + language_switch + "')\">" + _page.text["owner"] + "</a>");
	privacy_footer = privacy_footer.replace("{TERMS}", "<a href=\"" + _page.link["terms"] + "\" onclick=\"return _page.switchHandler('" + _page.link["terms"] + "','','" + language_switch + "')\">" + _page.text["terms"] + "</a>");
	strSitemapLink = _page.link["sitemap"];
	strSitemapText = _page.text["sitemap"];
	if (_page.link["sitemap_" + _page.area + "_navdata"]) {
		strSitemapLink = (_page.link["sitemap_" + _page.area + "_navdata"] !== "http://"?_page.link["sitemap_" + _page.area]: strSitemapLink);
	}
	privacy_footer = privacy_footer.replace("{SITEMAP}", "<a href=\"" + strSitemapLink + "\" onclick=\"return _page.switchHandler('" + strSitemapLink + "','','" + language_switch + "')\">" + strSitemapText + "</a>");
	privacy_footer = privacy_footer.replace("{CAREERS}","<a href=\"" + _page.link["careers"] + "\" onclick=\"return _page.switchHandler('" + _page.link["careers"] + "','','" + language_switch + "')\">" + _page.text["careers"] + "</a>");
	footer = '';
	if (!_page.disableBodyWrapperOutput) {
		footer+="						</div>\n";
		footer+="					</div>\n";
		footer+="					<div id=\"p-body-bottomwrapper\"></div>\n";
		footer+="				</div>\n";
		footer+="			</div>\n";
	}
	footer+="			<div id=\"p-footer\">\n";
	footer+="				<div id=\"p-footer-wrapper\">\n";
	footer+=" 					<div id=\"p-stockquotes\"></div>\n";
	footer+=" 					<div id=\"p-footertext\">" + privacy_footer + "</div>\n";
	txtBP = (_page.locale === "cn_zh" || _page.locale === "ca_fr" || _page.locale === "fr_fr" || _page.locale === "kr_ko"? (_page.text["brandpromise"] || ""): "");
	footer+=		(txtBP !== ""? "<div id=\"p-footer-brandpromise\">* " + txtBP + "</div>": "");  // nobr added due to IE 5
	footer+="				</div>\n";
	footer+="			</div>\n";	
	_page.write(footer, false);	
	addDOMOnLoadEvent(initSectionBanner);
	// Set analytics tools
	includeOmniture();
	// Include stockquotes file, when needed
	if (_page.showStockQuotes) includeStockquotes();
	// Make sure the ESurvey will not affect the site performance
	_page.eSurvey.include();
	onloadHandler();
};

_page.writeMicroHeader = function () {
	var header, arrow_name, headerLS, crsc;
	crsc = _page.crsc_server;
	// Include extra stylesheets (now locale file is loaded)
	_page.headerType = "microsite";
	if(_page.useGlobalStyle == true) {
		// allow use of global styles by external setting: _page.useGlobalStyle == true
		_page.hideGlobalStyle = false;
	} else {
		// default disable global styles
		_page.hideGlobalStyle = true; 
	}	
	include_stylesheets();
	// Build header
	header="";
	header+="	   <table id=\"p-container\" cellspacing=\"0\" border=\"0\">\n";
	// First row
	header+="			<tr>\n";
	header+="				<td id=\"p-topcontainertd\">\n";
	header+="					<table id=\"p-topcontainer\" cellspacing=\"0\" border=\"0\">\n";
	header+="						<tr>\n";
	header+="							<td id=\"p-mainlogo-micro\"><a href=\""+_page.link["home"]+"\" onclick=\"return _page.switchHandler('"+_page.link["home"]+"', '')\"><img alt=\"Philips\" src=\""+crsc+"/crsc/images/mainlogo.gif\" /></a></td>\n";
	header+="							<td id=\"p-topright\">\n";
	header+="								<table id=\"p-topright-container\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">\n";
	header+="									<tr>\n";
	/* Philips Home link */
	arrow_name = _page.direction=='ltr'?"arrow_header.gif":"arrow_header_rtl.gif";
	header+="										<td id=\"p-support-links\"><a href=\""+_page.link["home"]+"\" onclick=\"return _page.switchHandler('"+_page.link["home"]+"', '')\"><img alt=\"\" src=\""+crsc+"/crsc/images/"+arrow_name+"\" class=\"p-sectionarrow\" />\n";
	header+= _page.text["home_site"]+"</a></td>\n";
	/* Locale selector */
	if(_page.showLocales) {
		header+="									<td id=\"p-localeselect\">\n";
		headerLS = new _page.ls('1');
		header+= headerLS.html;
		header+="									</td>\n";
	}
	header+="									</tr>\n";
	header+="								</table>\n";
	header+="							</td>\n";
	header+="						</tr>\n";
	header+="					</table>\n";
	header+="				</td>\n";
	header+="			</tr>\n";
	header+="			<tr>\n";
	header+="				<td id=\"p-bodycontainer-td\">\n";
	header+="					<table id=\"p-bodycontainer-table\" cellspacing=\"0\">\n";
	header+="						<tr>\n";
	header+="							<td>\n";
	_page.write(header, false);
	if(_page.activateActiveX) includeActiveXFix();
	addOnLoadEvent(processTables);
};

_page.writeMicroFooter = function() {
	var privacy_footer, footer;
   	privacy_footer = _page.text["footer"];	
	privacy_footer = privacy_footer.replace("{BR}", "<br />");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{PRIVACY}", "<a href=\""+_page.link["privacy"]+"\" onclick=\"return _page.switchHandler('"+_page.link["privacy"]+"', '')\">"+_page.text["privacy"]+"</a>");
	privacy_footer = privacy_footer.replace("{OWNER}", "<a href=\""+_page.link["owner"]+"\" onclick=\"return _page.switchHandler('"+_page.link["owner"]+"', '')\">"+_page.text["owner"]+"</a>");
	privacy_footer = privacy_footer.replace("{TERMS}", "<a href=\""+_page.link["terms"]+"\" onclick=\"return _page.switchHandler('"+_page.link["terms"]+"', '')\">"+_page.text["terms"]+"</a>");
	privacy_footer = privacy_footer.replace("| {SITEMAP}","");
	privacy_footer = privacy_footer.replace("{CAREERS} | ","");
	footer="";
	footer+="							</td>\n";
	footer+="						</tr>\n";
	footer+="					</table>\n";	
	footer+="				</td>\n";
	footer+="			</tr>\n";
	footer+="			<tr>\n";
	footer+="				<td id=\"p-footer\">\n";
	footer+="					<table id=\"p-footertable\">\n";
	footer+="						<tr>\n";
	footer+="							<td id=\"p-footerleft\">\n";
	footer+= (_page.showStockQuotes?"<div id=\"p-stockquotes\">&nbsp;</div>\n":"&nbsp;");
	footer+="							</td>\n";
	footer+="							<td id=\"p-footertext\">\n";
	footer+="		<!-- footer text -->\n";
	footer+=" 								"+privacy_footer+"\n";
	footer+="		<!-- end footer text -->\n";
	footer+="							</td>\n";
	footer+="							<td id=\"p-footerright\">\n";
	footer+="								&nbsp;\n";
	footer+="							</td>\n";
	footer+="						</tr>\n";
	footer+="					</table>\n";
	footer+="				</td>\n";
	footer+="			</tr>\n";
	footer+="		</table>\n";
	_page.write(footer, true);
	document.body.style.direction=_page.direction; 	// Set dynamically page direction
	if(_page.showLocales) document.onload = updateLocales(_page.area); // Update locale files when they should be shown
	initSectionBanner();
	includeOmniture();
	onloadHandler();
};

_page.writeExtranetHeader = function () {
	var crsc, header;
	// Include extra stylesheets
	_page.hideGlobalStyle = false;
	_page.headerType = "extranet";
	include_stylesheets();
	// Build Extranet header
	crsc = _page.crsc_server;
    header="";
	header+="	   <table id=\"p-container\" cellspacing=\"0\">\n";
	header+="			<tr>\n";
	header+="				<td id=\"p-topcontainertd\">\n";
	header+="					<table id=\"p-topcontainer\">\n";
	header+="						<tr>\n";
	header+="							<td id=\"p-mainlogo-extra\"><a href=\""+_page.link["home"]+"\" onclick=\"return _page.switchHandler('"+_page.link["home"]+"', '')\"><img alt=\"Philips\" src=\""+crsc+"/crsc/images/mainlogo.gif\" /></a></td>\n";
	if(_page.showSearch){
		header+="							<td class=\"p-extranet-search\" align=\"right\">\n";
		header+="								<form id=\"searchform\" name=\"searchform\" action=\""+_page.searchaction+"\">\n";
		header+="									<table cellspacing=\"0\">";
		header+="										<tr>\n";
		header+="											<td>"+_page.text["searchlabel"]+"&nbsp;</td>\n";
		header+="											<td><input type=\"text\" size=\"20\" name=\"searchtext\" class=\"p-searchfield\" /></td>\n";
		header+="											<td>\n";
		if (_page.direction=='ltr'){
			header+="											<input class=\"p-locale-submit\" type=\"image\" alt=\"Submit\" src=\""+crsc+"/crsc/images/but_go.gif\" />\n";
		}
		else{
			header+="											<input class=\"p-locale-submit\" type=\"image\" alt=\"Submit\" src=\""+crsc+"/crsc/images/but_go_rtl.gif\" />\n";
		}
		header+="											</td>\n";
		header+="										</tr>\n";
		header+="									</table>\n";
		header+="								</form>\n";
		header+="							</td>\n";
	}
	header+="						</tr>\n";
	header+="					</table>\n";
	header+="				</td>\n";
	header+="			</tr>\n";
	header+="			<tr>\n";
	header+="				<td class=\"p-extranet-extraspace\">\n";
	header+="				</td>\n";
	header+="			</tr>\n";
	header+="			<tr>\n";
	header+="				<td id=\"p-bodycontainer-td\">\n";
	header+="					<table id=\"p-bodycontainer-table\" cellspacing=\"0\">\n";
	header+="						<tr>\n";
	header+="							<td class=\"p-extranet-topline\">\n";
	_page.write(header, false);
	if(_page.activateActiveX) includeActiveXFix();
	addOnLoadEvent(processTables);
};

_page.writeExtranetFooter = function() {
	var privacy_footer, footer;
   	privacy_footer = _page.text["footer"];	
	privacy_footer = privacy_footer.replace("{BR}", "<br />");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{PRIVACY}", "<a href=\""+_page.link["privacy"]+"\" onclick=\"return _page.switchHandler('"+_page.link["privacy"]+"', '')\">"+_page.text["privacy"]+"</a>");
	privacy_footer = privacy_footer.replace("{OWNER}", "<a href=\""+_page.link["owner"]+"\" onclick=\"return _page.switchHandler('"+_page.link["owner"]+"', '')\">"+_page.text["owner"]+"</a>");
	privacy_footer = privacy_footer.replace("{TERMS}", "<a href=\""+_page.link["terms"]+"\" onclick=\"return _page.switchHandler('"+_page.link["terms"]+"', '')\">"+_page.text["terms"]+"</a>");
	privacy_footer = privacy_footer.replace("| {SITEMAP}", "");
	privacy_footer = privacy_footer.replace("{CAREERS} | ","");
 	footer = "";
	footer += "							</td>\n";
	footer += "						</tr>\n";
	footer += "					</table>\n";	
	footer += "				</td>\n";
	footer += "			</tr>\n";
	footer += "			<tr>\n";
	footer += "				<td id=\"p-footer\">\n";
	footer += "					<table id=\"p-footertable\">\n";
	footer += "						<tr>\n";
	footer+="							<td id=\"p-footerleft\">\n";
	footer+= (_page.showStockQuotes?"<div id=\"p-stockquotes\">&nbsp;</div>\n":"&nbsp;");
	footer+="							</td>\n";
	footer += "							<td id=\"p-footertext\">\n";
	footer += "		<!-- footer text -->\n";
	footer += " 								"+privacy_footer+"\n";
	footer += "		<!-- end footer text -->\n";
	footer += "							</td>\n";
	footer += "							<td id=\"p-footerright\">\n";
	footer += "								&nbsp;\n";
	footer += "							</td>\n";
	footer += "						</tr>\n";
	footer += "					</table>\n";
	footer += "				</td>\n";
	footer += "			</tr>\n";
	footer += "		</table>\n";
	_page.write(footer,false)
	document.body.style.direction=_page.direction; 	// Set dynamically page direction
	onloadHandler();
};

_page.writeExternalExtranetHeader = function (area) {
	var crsc, strWidth, arrow_name, searchHTML, authorHTML, supportLinksHTML, supportText, supportLink, header, customLogoSrc, customLogoHref, customLogoAlt, butImage, butImageAlt, butLink, butText, strID, counter, i, topNavID, id;
	// Include stylesheets
	_page.hideGlobalStyle = true;
	_page.headerType = "external_extranet";
	include_stylesheets();
	// Settings
	crsc = _page.crsc_server;
	strWidth = _page.pageWidth;
	arrow_name = _page.direction=='ltr'?"arrow_orange.gif":"arrow_orange_rtl.gif";
	// Generate Search form HTML
	searchHTML="";
	searchHTML+="										<table id=\"p-search-form\" cellspacing=\"0\" border=\"0\">";
	searchHTML+="											<tr>\n";
	searchHTML+="												<form id=\"searchform\" name=\"searchform\" action=\""+_page.searchaction+"\">\n";
	searchHTML+="													<td><nobr>"+_page.text["searchlabel"]+"&nbsp;</nobr></td>\n";
	searchHTML+="													<td><input type=\"text\" size=\"20\" name=\"searchtext\" class=\"p-searchfield\" /></td>\n";
	searchHTML+="													<td>\n";
	if (_page.direction=='ltr'){
		searchHTML+="												<input class=\"p-locale-submit\" type=\"image\" alt=\"Submit\" src=\""+crsc+"/crsc/images/but_go.gif\" />\n";
	} else{
		searchHTML+="												<input class=\"p-locale-submit\" type=\"image\" alt=\"Submit\" src=\""+crsc+"/crsc/images/but_go_rtl.gif\" />\n";
	}
	searchHTML+="													</td>\n";
	searchHTML+="												</form>\n";
	searchHTML+="											</tr>\n";
	searchHTML+="										</table>\n";
	// Generate Author name HTML
	authorHTML="";
	authorHTML+=" 										<table id=\"p-author-name\" cellspacing=\"0\" border=\"0\"><tr>\n";
	authorHTML+="											<td><nobr>"+_page.text["authorname"]+"</nobr></td>\n";
	authorHTML+="										</tr></table>\n";
	// Generate Support Links
	supportLinksHTML= "";
	if(_page.supportLinks.length != 0) {
		supportLinksHTML+= "						<table id=\"p-support-links\" cellspacing=\"0\" border=\"0\"><tr>\n";
		for(i=0;i<_page.supportLinks.length;i++) {
			supportText = _page.supportLinks[i][0];
			supportLink = _page.supportLinks[i][1];
			supportLinksHTML+=" 							<td><a href=\""+supportLink+"\" onclick=\"return _page.switchHandler('"+supportLink+"','')\"><img alt=\"\" src=\""+crsc+"/crsc/images/"+arrow_name+"\" class=\"p-sectionarrow\" />"+supportText+"</a></td>\n";
		}
		supportLinksHTML+="							</tr></table>\n";
	}	
	// Generate Header HTML
	header="";
	header+="	   <table id=\"p-container\" cellspacing=\"0\" border=\"0\">\n";
	header+="			<tr>\n";
	header+="				<td id=\"p-topcontainertd\">\n";
	header+="					<table id=\"p-topcontainer-"+strWidth+"\" cellspacing=\"0\">\n";
	header+="						<tr>\n";
	header+="							<td id=\"p-mainlogo-extra\"><a href=\""+_page.link["home"]+"\" onclick=\"return _page.switchHandler('"+_page.link["home"]+"', '')\"><img alt=\"Philips\" src=\""+crsc+"/crsc/images/mainlogo.gif\" /></a></td>\n";
	header+="							<td id=\"p-top-middle\">\n";
	header+="								<table id=\"p-top-options\" border=\"0\" cellspacing=\"0\"><tr>";
	// Show option boxes in top header
	if (_page.showAuthor && _page.authorPosition == "top") {
		header+="								<td>"+authorHTML+"</td>";
	} 
	if (_page.showSearch && _page.searchPosition == "top") {
		header+="								<td>"+searchHTML+"</td>";
	} 
	if(_page.showSupportLinks) {
		header+="								<td>"+supportLinksHTML+"</td>";
	} 
	header+="								</tr></table>";
	header+="							</td>\n";	
	// Define custom logo
	if(_page.customLogo[0]) customLogoSrc = _page.customLogo[0] || "";
	if(_page.customLogo[1]) customLogoHref = _page.customLogo[1] || "";
	if(_page.customLogo[2]) customLogoAlt = _page.customLogo[2] || "";
	header+="							<td id=\"p-customlogo\"><a href=\""+customLogoHref+"\" onclick=\"return _page.switchHandler('"+customLogoHref+"', '')\"><img alt=\""+customLogoAlt+"\" src=\""+customLogoSrc+"\" /></a></td>\n";
	header+="						</tr>\n";
	header+="					</table>\n";
	header+="				</td>\n";
	header+="			</tr>\n";
	// Hide top navigation if type = hidden
	if(_page.topNavType != "hidden") {
		header+="		<tr>\n";
		header+="			<td id=\"p-headcontainer-td\">\n";
		header+="				<table id=\"p-headcontainer-table-"+strWidth+"\" cellspacing=\"0\" border=\"0\">\n";
		header+="					<tr>\n";
		header+="						<td>\n";
		header+="		<!-- main navigation bar -->\n";
		header+="							<table class=\"p-tight\" id=\"p-mainnavcontainer\" cellspacing=\"0\" border=\"0\" width=\"100%\">\n";
		header+="								<tr>\n";
		// Disable left/right corner when using internet dropdown buttons
		if(_page.topNavType != "internet") {
			if (_page.direction=='ltr'){
				header+="								<td id=\"p-mainnav-leftcorner\" class=\"p-mainnav-leftcorner\"><img alt=\"\" src=\""+crsc+"/crsc/images/t.gif\" width=\"1\" /></td>\n";
			} else{
				header+="								<td id=\"p-mainnav-rightcorner\" class=\"p-mainnav-rightcorner\"><img alt=\"\" src=\""+crsc+"/crsc/images/t.gif\" width=\"1\" /></td>\n";
			}
		}
		// Start main nav LEFT
		header+="									<td id=\"p-mainnav-left\">\n";
		// Start creating top-menu buttons
		if(_page.topNavType == "internet") {
			// Dropdown menubar - internet style
			header+="									<table cellspacing=\"0\" border=\"0\">\n";
			header+="										<tr>\n";
			header+="											<td id=\"p-mainnav-dropdowns\">\n";
			header+="												<table class=\"p-tight\"  id=\"p-mainnav\" cellspacing=\"0\" border=\"0\">\n";
			header+="													<tr>\n";
			// Reset initialized menuArray
			menuArray = new Array();
			i=1;
			for(topNavID in _page.topNavXN) {
				menuArray[i]=topNavID;
				i++;
			}
			// Set current area
			if(typeof(area)!="undefined") {
				_page.area = area;
	    		currSection = _page.area;
			}
			// create button and divider html
			for(counter=1;counter< menuArray.length;counter++) {
				strID = menuArray[counter];
				header+="													<td class=\"navbutton\" id=\""+strID+"button\" onmouseover=\"sectionOn('"+strID+"', event)\" onmouseout=\"sectionOff('"+strID+"')\" onclick=\"Javascript:_page.switchHandler('"+_page.topNavXN[strID][0][1]+"', '')\"><div>"+_page.topNavXN[strID][0][0]+"</div></td>\n";
				header+="													<td id=\"p-mainnav-sep1\" class=\"mainnavsep\" onmouseover=\"hideAllMenus()\"><img alt=\"\" src=\""+crsc+"/crsc/images/navsep.gif\" /></td>\n";
			}
			header+="													</tr>\n";
			header+="												</table>\n";
			header+="											</td>\n";
			header+="										</tr>\n";
			header+="									</table>\n";
		} else if(_page.topNavType == "icons") {
			// Menubar with icons
			header+="									<table id=\"p-mainnav-icons\" cellspacing=\"0\" border=\"0\">\n";
			header+=" 										<tr>\n";
			for(id in _page.topNavXN) {
				butText = _page.topNavXN[id][0] || "";
				butLink = _page.topNavXN[id][1] || "";
				butImage = _page.topNavXN[id][2] || "";
				butImageAlt = _page.topNavXN[id][3] || "";
				header+="										<td class=\"p-iconbutton\" id=\"button"+"_"+id+"\" onclick=\"Javascript:_page.switchHandler('"+butLink+"', '')\"><a href=\""+butLink+"\">";
				if(typeof(butImage)!="undefined") {
					header+="									<img src=\""+butImage+"\" ";
					if(typeof(butImageAlt)!="undefined") {
						header+="								alt=\""+butImageAlt+"\" ";
					} else {
						header+="								alt=\"\" ";
					}
					header+="									/>";
				}
				header+="										"+butText+"</a></td>\n";
				header+="										<td class=\"p-iconbutton-sep\">&nbsp;</td>";
			}
			header+="										</tr>\n";
			header+="									</table>\n";
		} else {
			// Customised top navigation
			header+="									<table id=\"p-mainnav-custom\" cellspacing=\"0\" border=\"0\" >\n";
			header+="										<tr>\n";
			header+="											<td>"+_page.topNavHTML+"</td>\n";
			header+="										</tr>\n";
			header+="									</table>\n";
		}
		header+="									</td>\n";
		header+="									<td id=\"p-mainnav-right\">\n";
		// Include right column in menubar
		if(_page.showSearch || _page.showAuthor) {
			// Show quick search
			if(_page.showSearch && _page.searchPosition == "menu") {
				header+= 								searchHTML;	
			// Show author info	
			} else if (_page.showAuthor && _page.authorPosition == "menu") {
				header+= 								authorHTML;
			}
		}
		header+="									</td>\n";
		// End top-menu buttons
		if (_page.direction=='ltr'){
			header+="								<td id=\"p-mainnav-rightcorner\" class=\"p-mainnav-rightcorner\"><img alt=\"\" src=\""+crsc+"/crsc/images/t.gif\" width=\"1\" /></td>\n";
		} else{
			header+="								<td id=\"p-mainnav-leftcorner\" class=\"p-mainnav-leftcorner\"><img alt=\"\" src=\""+crsc+"/crsc/images/t.gif\" width=\"1\" /></td>\n";
		}
		header+="								</tr>\n";
		header+="							</table>\n";
		header+="		<!-- end main navigation bar -->\n";
		header+="						</td>\n";
		header+="					</tr>\n";
		header+="				</table>\n";
		header+="			</td>\n";
		header+="		</tr>\n";
	}
	header+="			<tr>\n";
	header+="				<td id=\"p-bodycontainer-td\">\n";
	header+="					<table id=\"p-bodycontainer-table-"+strWidth+"\" cellspacing=\"0\" border=\"0\">\n";
	header+="						<tr>\n";
	header+="							<td>\n";
	_page.write(header, false);
	if(_page.activateActiveX) includeActiveXFix();
	addOnLoadEvent(processTables);
};

_page.writeExternalExtranetFooter = function() {
	var privacy_footer, footer, strID, counter;
   	privacy_footer = _page.text["footer"];	
	privacy_footer = privacy_footer.replace("{BR}", "<br />");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{PRIVACY}", "<a href=\""+_page.link["privacy"]+"\" onclick=\"return _page.switchHandler('"+_page.link["privacy"]+"', '')\">"+_page.text["privacy"]+"</a>");
	privacy_footer = privacy_footer.replace("{OWNER}", "<a href=\""+_page.link["owner"]+"\" onclick=\"return _page.switchHandler('"+_page.link["owner"]+"', '')\">"+_page.text["owner"]+"</a>");
	privacy_footer = privacy_footer.replace("{TERMS}", "<a href=\""+_page.link["terms"]+"\" onclick=\"return _page.switchHandler('"+_page.link["terms"]+"', '')\">"+_page.text["terms"]+"</a>");
	privacy_footer = privacy_footer.replace("| {SITEMAP}", "");
	privacy_footer = privacy_footer.replace("{CAREERS} | ","");
	footer = '';
	footer +="							</td>\n";
	footer +="						</tr>\n";
	footer +="					</table>\n";	
	footer +="				</td>\n";
	footer +="			</tr>\n";
	footer +="			<tr>\n";
	footer +="				<td id=\"p-footer\">\n";
	footer +="					<table id=\"p-footertable-"+_page.pageWidth+"\">\n";
	footer +="						<tr>\n";
	footer+="							<td id=\"p-footerleft\">\n";
	footer+= (_page.showStockQuotes?"<div id=\"p-stockquotes\">&nbsp;</div>\n":"&nbsp;");
	footer+="							</td>\n";
	footer +="							<td id=\"p-footertext\">\n";
	footer +="		<!-- footer text -->\n";
	footer +=" 								"+privacy_footer+"\n";
	footer +="		<!-- end footer text -->\n";
	footer +="							</td>\n";
	footer +="							<td id=\"p-footerright\">\n";
	footer +="								&nbsp;\n";
	footer +="							</td>\n";
	footer +="						</tr>\n";
	footer +="					</table>\n";
	footer +="				</td>\n";
	footer +="			</tr>\n";
	footer +="		</table>\n";
	if(	_page.topNavType == "internet") {
		// create dropdown items
		for(counter=1;counter< menuArray.length;counter++) {
			strID = menuArray[counter];
			footer += createTopNavMenu(strID);
		}
		// Set selected area
		if(_page.area!="") sectionButtonOn(_page.area);
		// Set general settings
		document.onmouseover = hideAllMenus;
	}	
	_page.write(footer,false);
	document.body.style.direction=_page.direction; 	// Set dynamically page direction
	onloadHandler();
};

_page.getstringlength = function(lbl){
	//Function to calculate length of a string where special chars are included (&....;)
	var i=0, l=lbl.length, count=0, cc;
	for (cc=0; cc<l; cc++) {
		if (lbl.slice(i,i+1)=='&') {
			if ((lbl.indexOf(';',i) > i) && ((lbl.indexOf('&',i+1)==-1) || (lbl.indexOf('&',i+1)>lbl.indexOf(';',i)))) {
				i=lbl.indexOf(';',i)+1;
			} else {
				i++;
			}
		} else {
				i++;
		}
		if(i<=l){
			count++;
		}
	}
	return count;
};

// Write breadcrumb
_page.writeBreadCrumb = function (active_item) {
	var strNavTrail='',max_length = 94, total_length = 0, spacing_length = 3, parent_ids, strSectionMainName, strSectionMainLink, strSectionSpecialName, strSectionSpecialLink, area_string, i, j;
	_page.breadCrumbItem = active_item;		
	// Initalize array of breadcrumb ID's
	parent_ids = active_item.split("_");
	for (i=0; i<parent_ids.length; i++) {
		parent_ids[i]=(i>0?parent_ids[i-1]+"_"+parent_ids[i]:parent_ids[i]);
	}
	// Reduce length when font size is enlarged
	if(_page.locale.substring(3,5)=="zh" || _page.locale.substring(3,5)=="ja" || _page.locale.substring(3,5)=="ko"){
		max_length = max_length - 40; // Used to be 15
	}
	if(_page.locale.substring(3,5)=="th"){
		max_length = max_length - 10;
	}
	if(_page.locale.substring(3,5)=="ru"){
		max_length = max_length - 5;
	}
	// Get length of youarehere
	youarehere_length = _page.getstringlength(_page.text["youarehere"]);
	// Get length of home
	home_length = _page.getstringlength(_page.text["home_breadcrumb"]);
	// Reduce max length for 'you are here' and 'home' texts
	max_length = max_length - youarehere_length - home_length -2;
	strNavTrail+='<table class="p-breadcrumb-table" cellspacing="0">\n';
	strNavTrail+='	<tr>\n';
	strNavTrail+='		<td id="p-youarehere">'+_page.text["youarehere"]+':</td>\n';
	strNavTrail+='		<td id="p-home"><a href="'+_page.link["home"]+'">'+_page.text["home_breadcrumb"]+'</a></td>\n';
	// Set special section vars
	strSectionMainName = (typeof _page.sectionMain[0]!="undefined"?_page.sectionMain[0]:'')
	strSectionMainLink = (typeof _page.sectionMain[1]!="undefined"?_page.sectionMain[1]:'')
	strSectionSpecialName = (typeof _page.sectionSpecial[0]!="undefined"?_page.sectionSpecial[0]:'')
	strSectionSpecialLink = (typeof _page.sectionSpecial[1]!="undefined"?_page.sectionSpecial[1]:'')
	// Reduce max lenght for section
	area_string='';
	if(_page.area!="" && strSectionSpecialName==""){
		if(_page.headerType == "external_extranet") {
			firstElement = (typeof(_page.topNavXN[_page.area])!="undefined"?_page.topNavXN[_page.area][0][0]:"");
		} else{
			firstElement = (typeof(_page.topNav[_page.area])!="undefined"?_page.topNav[_page.area][0][0]:"");
		}
		// Only show section when section is available
		if(active_item!="") {
			if(firstElement!="") {
				//Show translated section contents
				strNavTrail+='		<td class="p-microarrow"><a href="'+_page.locales[_page.locale]+'">'+firstElement+'</a></td>\n';
				area_string = firstElement;
			} else {
				strNavTrail+='		<td class="p-microarrow">'+_page.area+'</td>\n';
				area_string = _page.area;
			}
		} else {
			if(firstElement!=""){
				//Show translated section contents
				strNavTrail+='		<td class="p-microarrow">'+firstElement+'</td>\n';
				area_string = firstElement;
			}else{
				// Include text that is used in _page.area (other site)
				strNavTrail+='		<td class="p-microarrow">'+_page.area+'</td>\n';
				area_string = _page.area;
			}
		}
	} else if(strSectionSpecialName!="") {
		// Show special section items
		if(strSectionMainName!="")		strNavTrail+='		<td class="p-microarrow">'+(strSectionMainLink!=""?'<a href="'+strSectionMainLink+'">'+strSectionMainName+'</a>':strSectionMainName)+'</td>\n';
		if(strSectionSpecialName!="")	strNavTrail+='		<td class="p-microarrow">'+(strSectionSpecialLink!="" && active_item!=""?'<a href="'+strSectionSpecialLink+'">'+strSectionSpecialName+'</a>':strSectionSpecialName)+'</td>\n';
		area_string = strSectionMainName+strSectionSpecialName;
	}
	// reduce max length
	if(area_string!="") {
		max_length = max_length - _page.getstringlength(area_string);
	}
	if(active_item!=""){
		// Check if all items fit on 1 row			
		for (i=0; i<parent_ids.length; i++) {
			total_length += _page.leftNav[parent_ids[i]].text.length;
		}
		counter = 0;
		if(total_length>max_length){
			while(total_length>max_length){
				total_length = total_length - _page.leftNav[parent_ids[counter]].text.length - spacing_length;
				i = i - 1;
				counter += 1;
			}
		}
		start_item = parent_ids.length - i;
		if(start_item!=0){
			strNavTrail+='		<td class="p-microarrow">...</td>\n';
		}
		for (j=start_item; j<parent_ids.length; j++) {
			if(j!=(parent_ids.length-1)){
				strNavTrail+='<td class="p-microarrow"><a href="'+_page.leftNav[parent_ids[j]].link+'">'+_page.leftNav[parent_ids[j]].text+'</a></td>\n';
			}else{
				strNavTrail+='<td class="p-microarrow">'+_page.leftNav[parent_ids[j]].text+'</td>\n';
			}
		}
	}
	strNavTrail+='</tr>\n';
	strNavTrail+='</table>\n';
	document.write(strNavTrail);
};

/* 
**********************************************
*******       Locale selector layer functions      ******
**********************************************
*/
_page.arrLS =[];
_page.ls = function(type, params) {
	params = params || {};
		this.options = {
			keepActive:(typeof(params.keepActive)!="undefined"?params.keepActive:false),
			localeFlag:(params.localeFlag?params.localeFlag:_page.altLocaleFlag || _page.locale),
			localeText: (params.localeText?params.localeText:_page.altLocaleText),
			collapseDirection: (params.collapseDirection?params.collapseDirection:'auto'),
			showRows: (params.showRows?params.showRows:9), 										// Default rows 9
			listHeight: (params.listHeight?params.listHeight:275), 								// Default height defined in styles, may be overruled for faillover
			data: (params.data?params.data:_page.getLocalesArray),								// Requires an array of locales, input can be array or function
			remoteUrl:(params.remoteUrl?params.remoteUrl:""),
			remoteOptions: params.remoteOptions || {},
			removeLocaleList: params.removeLocaleList || []
		}
	this.type = type;	
	// Override remote options, set default output and oncomplete function when not defined by parameters			
	this.options.remoteOptions.onComplete = (this.options.remoteOptions.onComplete?this.options.remoteOptions.onComplete:this._remoteComplete.bindArgs(this));
	// Other declarations
	this.arrIndex = _page.arrLS.length;
	this.id = "ls_"+ this.arrIndex;
	this.timer = "";
	this.rows = this.options.showRows;
	this.move = this.options.collapseDirection;
	this.switchOverflow = (_page.browser.isMac && _page.browser.isGecko?true:false);
	this.localeArray = [];
	this.dataLoaded = false;
	this.elList = null;
	this.listActive = false;
	_page.arrLS[this.arrIndex] = this;	// Add to LS array
	this._init();
}
_page.ls.prototype = {
	_init:function() {
		this._build();
	},
	_load:function(renderImages) {
		this._getData();
		if(this.dataLoaded == true) {
			this._update();
			this._visible(true);
			if(renderImages)this._renderImages();
			this._resize();
			this._position();
			this._hidden(true);
		}
	},
	_remoteComplete:function() {
		// This method is based at the current www.crsc.philips.com/crsc/locales/locale_section url 
		this.localeArray = processLocales();	
		if(this._localesTmp)
			_page.locales = this._localesTmp;
		this.dataLoaded = true;
		this._show();			
	},
	_getData:function() {
		var id;
		if(this.dataLoaded == false) {
			if(this.options.remoteUrl!="") {
				// Create local backup of current loaded _page.locales and reset _page.loaces
				this._localesTmp = {};	
				for(id in _page.locales)
					this._localesTmp[id] = _page.locales[id];
				_page.locales = {};
				_page.loadJSFile(this.options.remoteUrl,function(){var filled=false;for(id in _page.locales){filled=true;break;}return filled}, this.options.remoteOptions.onComplete);
			} else {
				this.localeArray = typeof(this.options.data)=="function"?this.options.data():this.options.data;
				this.dataLoaded = true;
			}
		}
	},
	_mClick:function() {
		clearTimeout(this.timer);
		if(!this.options.keepActive) this._show();
	},
	_mOver:function() {
		clearTimeout(this.timer);
		if(!this.options.keepActive) this.timer=setTimeout('_page.arrLS['+this.arrIndex+']._show()','1000');
	},
	_mClose:function() {
		clearTimeout(this.timer);
		if(!this.options.keepActive) this.timer=setTimeout('_page.arrLS['+this.arrIndex+']._hide()','500');
	},
	_show:function() {
		var objLSBody, objFlag, objIframe;
		if(this.listActive == false)
			this._load(true);
		if(this.elList) {						
			objLSBody = gE('p-ls-body-'+this.arrIndex);
			if(objLSBody && this.switchOverflow) { objLSBody.style.overflow = "auto"; }
			if(this.type == '1') {
				objFlag = gE('p-flag-'+this.arrIndex);
				if(objFlag) applyStyle(objFlag,'p-flag-on');
			}
			if(useIframe) {
				objIframe = gE('p-lsIF-'+this.arrIndex);
				if(objIframe) sE(objIframe);
			}
			this._visible();
			this.listActive = true;
		}
	},
	_hide:function() {
		var objLSBody, objFlag, objIframe;
		if(this.elList) {
			objLSBody = gE('p-ls-body-'+this.arrIndex);
			if(objLSBody && this.switchOverflow) objLSBody.style.overflow = "hidden";
			if(this.type == '1') {
				objFlag = gE('p-flag-'+this.arrIndex);
				if(objFlag) applyStyle(objFlag,'p-flag');
			}
			if(useIframe) {
				objIframe = gE('p-lsIF-'+this.arrIndex);
				if(objIframe) hE(objIframe);
			}
			this._hidden();
			this.listActive = false;
		}
	},
	_build:function() {
		var strFlagLocale, strCountry, strLanguage, strFlagSource, strLocaleText, strHTML, crsc, strArrowName, classClick;
		// Get alternative locale flag
		strFlagLocale = this.options.localeFlag;
		strCountry = strFlagLocale.split("_")[0];
		strLanguage = strFlagLocale.split("_")[1] || "en";
		strFlagSource = "flag_"+strCountry+".gif";
		if(this.options.localeText=="") 			
			this.options.localeText = (_page.countries[strCountry] || "Global") +" / "+ _page.languages[strLanguage];
		strLocaleText = this.options.localeText;
		strHTML = "";
		strHTML += "<div class=\"p-ls-wrapper-"+this.type+"\" id=\"p-ls-"+this.arrIndex+"\" >";
		crsc = _page.crsc_server;
		// Add onclick / mouse over HTML
		strArrowName = (_page.direction == 'ltr'?"arrow_bottom_right.gif":"arrow_bottom_left.gif");
		classClick = (this.options.keepActive!=true?"p-click":"");
		if(this.type == "1") {
			strHTML+="<div class=\"p-ls-hover-container-1 "+classClick+"\" id=\"p-ls-hover-"+this.arrIndex+"\" onmouseover=\"_page.arrLS["+this.arrIndex+"]._mOver()\" onmouseout=\"_page.arrLS["+this.arrIndex+"]._mClose()\" onclick=\"_page.arrLS["+this.arrIndex+"]._mClick()\"><nobr><img alt=\""+strLocaleText+"\" src=\""+crsc+"/crsc/images/" + strFlagSource + "\" id=\"p-flag-"+this.arrIndex+"\" class=\"p-flag\" />&nbsp;<img alt=\"Show locale list\" src=\""+crsc+"/crsc/images/"+strArrowName+"\" id=\"p-arrow-bottom-right-"+this.arrIndex+"\" class=\"p-arrow-bottom-right\" /></nobr></div>\n";
		} else if(this.type == "2") {
			strHTML+="<div class=\"p-ls-hover-container-2 "+classClick+"\" onmouseover=\"_page.arrLS["+this.arrIndex+"]._mOver()\" onmouseout=\"_page.arrLS["+this.arrIndex+"]._mClose()\" onclick=\"_page.arrLS["+this.arrIndex+"]._mClick()\"><table class=\"p-ls-hover\" id=\"p-ls-hover-"+this.arrIndex+"\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr><td class=\"p-ls-hover-left\"><img alt=\""+strLocaleText+"\" src=\""+crsc+"/crsc/images/" + strFlagSource + "\" id=\"p-flag-"+this.arrIndex+"\" class=\"p-flag\" /></td><td class=\"p-ls-hover-center\"><span id=\"p-ls-header-text-"+this.arrIndex+"\">"+strLocaleText+"</span></td><td class=\"p-ls-hover-right\"><img alt=\"Show locale list\" src=\""+crsc+"/crsc/images/"+strArrowName+"\" id=\"p-arrow-bottom-right-"+this.arrIndex+"\"/></td></tr></table></div>\n";
		}
		strHTML+="</div>";
		this.html = strHTML;
	},
	_renderImages:function() {
		if(this.imagesRendered) return;
		var arrLocales, strLocale, strCurCountry, objLink, strNewClass, i;
		arrLocales = this.localeArray;
		for(i=0;i < arrLocales.length;i++) {
			strLocale = arrLocales[i][0];
			strCurCountry = (strLocale.indexOf("_")==-1?strLocale:strLocale.substring(0,2));
			objLink = gE("p-ls-list-"+this.arrIndex+"-flag-" + strCurCountry);
			strNewClass = "p-flag-" + strCurCountry;	
			if(objLink)
				applyStyle(objLink,strNewClass);
		}
		this.imagesRendered = false;	
	},
	_removeLocales:function() {
		// Remove locale element from array if needs to be removed
		var arrLocales, strLocale, i;
		if(this.options.removeLocaleList.length == 0) return;
		arrLocales = this.localeArray;
		for(i=0;i < arrLocales.length;i++) {
			strLocale = arrLocales[i][0];
			if(hasElement(this.options.removeLocaleList,strLocale)) arrLocales.splice(i,1);
		}	
	},
	_update:function() {	
		if(this.updated) return;
		var arrLocales, crsc, strCurCountry = '', strLastCountry = '', strLocale = '', strHTMLBody = '', overFlow, arrLocalesMax, objFlagDimensions, elContainer, strHTMLHeader, i;
		this._setAutoMovement();
		this._removeLocales();
		arrLocales = this.localeArray;
		// Build body HTML and locales from array
		crsc = _page.crsc_server;
		overFlow = (this.switchOverflow?"style=\"overflow:hidden\"":"");
		strHTMLBody += "<div id=\"p-ls-body-"+this.arrIndex+"\" class=\"p-ls-body\" "+overFlow+">\n";
		strHTMLBody += "<table class=\"p-ls-list\" cellspacing=\"0\" border=\"0\">\n";
		arrLocalesMax = arrLocales.length;
		for( i=0;i < arrLocalesMax;i++) {
			strLocale = arrLocales[i][0];
			strCurCountry = (strLocale.indexOf("_")==-1?strLocale:strLocale.substring(0,2));
			if (strCurCountry != strLastCountry) {
				// Set flag dimensions;
				objFlagDimensions = {width:'17',height:'13'};
				if(strCurCountry=="global" || strCurCountry=="me_en" || strCurCountry=="ce_es"|| strCurCountry=="others")
					objFlagDimensions = {width:'14',height:'14'};
				strHTMLBody +=
				(i!=0?"</ul></td></tr>\n":"")+
				"<tr><td class=\"p-ls-list-left\"><a id=\"p-ls-list-"+this.arrIndex+"-flag-"+strCurCountry+"\" href=\""+arrLocales[i][3]+"\" onclick=\"_page.changelocale('"+strLocale+"');return false;\" /></td><td  class=\"p-ls-list-right\"><ul class=\"p-ls-localelist\">\n";
			}
			// Set country / language
			strHTMLBody += "<li><a href=\""+arrLocales[i][3]+"\" onclick=\"_page.changelocale('"+strLocale+"','"+arrLocales[i][3]+"');return false;\">"+arrLocales[i][4]+"</a></li>";
			strLastCountry = strCurCountry;	
		}
		strHTMLBody += "</ul></td></tr>\n";
		strHTMLBody += "</table>\n";
		strHTMLBody += "</div>\n";
		// Add Dropdown HTML, cannot initiated earlier because of the movement detection
		strHTML = "";
		strHTML+="					<div id=\"p-ls-container-"+this.arrIndex+"\" class=\"p-ls-container-"+this.move+"\" onmouseover=\"_page.arrLS["+this.arrIndex+"]._mOver()\" onmouseout=\"_page.arrLS["+this.arrIndex+"]._mClose()\">\n";
		if(this.type == "1") {
			strHTMLHeader = "<div id=\"p-ls-header-"+this.arrIndex+"\" class=\"p-ls-header\"><table cellspacing=\"0\" class=\"p-ls-header-table\"><tr><td><span id=\"p-ls-header-text-"+this.arrIndex+"\">"+this.options.localeText+"</span></td></tr></table></div>\n";
			strHTML+= strHTMLHeader + strHTMLBody;	// Header used which overlaps the topmenu
		} else if(this.type == "2") {
			strHTML+= strHTMLBody;
		}
		// Add IFRAME html
		if(useIframe) {
			strHTML+="		<iframe frameborder=0 id=\"p-lsIF-"+this.arrIndex+"\" src=\""+crsc + "/crsc/images/t.gif\" scroll=none style=\"FILTER:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0);visibility:hidden;height:0;position:absolute;width:0px;top:0px;z-index:0;\"></iframe>";
		}
		strHTML+="</div>";
		elContainer = gE('p-ls-'+this.arrIndex);
		if(elContainer) elContainer.innerHTML += strHTML;
		this.elList = gE("p-ls-container-"+this.arrIndex);
		this.updated = true;
	},
	_resize:function() {
		if(this.resized) return;
		var intMaxRows, objDD, arrRows, intHeight=0, intVisibleRows=0, objCellLeft, objCellRight, objList, objLS, objIframe, i;
		// Set dynamich height of dropdown by defined max rows;
		intMaxRows = this.rows;
		objDD = document.getElementById('p-ls-body-'+this.arrIndex);
		arrRows = objDD.getElementsByTagName('tr');
		for(i=0; i < arrRows.length; i++) {
			objCellLeft = arrRows[i].childNodes[0];
			objCellRight = arrRows[i].childNodes[1];
			if(i < intMaxRows) {	// Count visible height
				intHeight += objCellRight.offsetHeight;
				intVisibleRows++;
			}
			if(!arrRows[i+1]) {	// Remove bottom border
				applyStyle(objCellLeft,getStyle(objCellLeft)+" p-nobottomborder");
				applyStyle(objCellRight,getStyle(objCellRight)+" p-nobottomborder");
			}
		}
		intHeight = (intHeight == 0? this.options.listHeight:intHeight );  // Set failover height, if it can't be determined due to display:none in parent elements
		if(_page.browser.isSafari) intHeight = intHeight + intVisibleRows; // Safari doesn't include the borders in the height
		// Overflow is needed
		if(arrRows.length > intMaxRows) {
			if(!_page.browser.isIE5x) intHeight--;  // Decrease 1px for border, except for border box model applicable browsers
			if(_page.browser.isSafari) intHeight = intHeight - 2;
		// Extend the width if there's no overflow / scrollbar, not applicable for Safari	
		} else {
			if(!_page.browser.isSafari){
				objList = objDD.getElementsByTagName("table")[0];
				sW(objList,objDD.offsetWidth-2); // - 2  due to border
			}
			if(_page.browser.isIE5x) intHeight++; // increase 1px for border only for border box model applicable browsers
		} 
		sH(objDD,intHeight); 
		if (useIframe) {
			objLS = this.elList;
			objIframe = gE('p-lsIF-'+this.arrIndex);
			sH(objIframe,(objLS.offsetHeight));
			sW(objIframe,(objLS.offsetWidth));
		}
		this.resized = true;
	},
	_setAutoMovement:function() {
		if(this.options.collapseDirection != "auto") return;
		var scrollPosTop, screenHeight, scrollPosBottom, objRef, objLS, bottomPosContainer, topPosContainer;
		scrollPosTop = getScrollPosTop();  				// Positon top in scrolled browser window
		screenHeight = getScreenHeight();				// Available height browser window
		scrollPosBottom = scrollPosTop + screenHeight;	// Positon bottom in scrolled browser window	
		objRef = gE('p-ls-hover-'+this.arrIndex);
		objLS = this.elList;
		bottomPosContainer = findPosY(objRef) + (objLS?objLS.offsetHeight:this.options.listHeight);
		topPosContainer = findPosY(objRef) - (objLS?objLS.offsetHeight:this.options.listHeight);
		this.move = (bottomPosContainer > scrollPosBottom && topPosContainer > scrollPosTop?"up":"down");
	},
	_position:function () {
		this._setAutoMovement();
		var elLS, elHover, elContainer, elHeader, elBody
		elLS = this.elList;
		elHover = gE('p-ls-hover-'+this.arrIndex);
		elContainer = gE('p-ls-container-'+this.arrIndex);
		elHeader = gE('p-ls-header-'+this.arrIndex);
		elBody = gE('p-ls-body-'+this.arrIndex);
		if(this.move == "up") {
			if(this.type == "1") {
				if(elHeader && elBody) elHeader.parentNode.insertBefore(elBody,elHeader);
			}
			applyStyle(elLS,"p-ls-container-up");
		} else if(this.move == "down") {
			if(this.type == "1") {
				if(elHeader && elBody) elHeader.parentNode.insertBefore(elHeader,elBody);
				if(elHover && elContainer) elHover.parentNode.insertBefore(elContainer,elHover);
			}		
			applyStyle(elLS,"p-ls-container-down");
		}
	},
	_visible: function(visibility) {
		if(this.elList) {
			if(visibility) hE(this.elList);
			this.elList.style.display = "block";
		}	
	},
	_hidden: function(visibility) {
		if(this.elList) {
			if(visibility) sE(this.elList);
			this.elList.style.display = "none";
		}	
	}
}

_page.localesProcessed = false;
_page.localesArray = [];	
// Build locale sorted array, used for i.e. locale selector list
_page.getLocalesArray = function() {
	if(_page.localesProcessed == false) {
		_page.localesArray = processLocales();
		if(_page.localesArray.length > 0)
			_page.localesProcessed = true;
	}	
	return _page.localesArray;
}


/* Add Stylesheet injection to your site */
_page.stylesheetArray = [];	// Private array
// Constructor 
_page.stylesheet = function(css) {
	this.id = "p-style-injection-"+_page.stylesheetArray.length;
	this.css = css;
	this.index = _page.stylesheetArray.length;
	_page.stylesheetArray[_page.stylesheetArray.length] = this;
}
// Methods
_page.stylesheet.prototype = {
	add:function(css) {
		if(css) this.css = css;
		if(document.createStyleSheet){
			// Create stylesheet if necessary
			if(!this.ref) this.ref = document.createStyleSheet();
			// Update rules in stylesheet
			this.ref.cssText = this.css;
			this.ref.title = this.id;
		} else {					
			// Add new link object to header
			this.ref = document.createElement('link');
			this.ref.id = this.id;
			this.ref.rel = "stylesheet";
			this.ref.type = "text/css";
			this.ref.title = this.id;
			this.ref.href = "data:text/css,"+escape(this.css);
			document.getElementsByTagName("head")[0].appendChild(this.ref);
			this.ref.disabled = false; // Make sure the browser enables the stylesheet
		}
	},
	update:function(css) {
		if(document.createStyleSheet){
			this.remove();
			this.add(css);
		} else {			
			this.ref.id = this.ref.id+"_remove";
			this.add(css);
			// Remove existing link object from header , after 1 second, inorder to prevent flickering css changes
			setTimeout("new function(){_page.stylesheetArray["+this.index+"].remove('"+this.id+"_remove')}",1000);
		}
	},
	remove:function(id) {
		var intSSRules, obj;
		if(document.createStyleSheet){
			// Try to clear the stylesheet
			intSSRules = this.ref.rules.length;
			while(intSSRules--) 
				this.ref.removeRule(intSSRules);						
		} else {
			// Remove the stylesheet
			obj = (id?gE(id):this.ref);
			_page.discardElement(obj);
		}	
	}
};

/* ESurvey helper functions */
_page.eSurvey = {
	include:function() {
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded",_page.eSurvey.load, false); // DomContentLoaded used inorder to prevent looping loading requests in the statusbar FF
		} else {
			addOnLoadEvent(_page.eSurvey.load);
		};
	},
	load:function() {
		var objBody, objScript;
		if (window.location.protocol != "https:" && !isMacIE && _page.loadESurvey == true) {
			objBody = document.getElementsByTagName('body').item(0);
			objScript = document.createElement('script');
			objScript.src = _page.externalUrlPrefix.metrixLab + "/popups/p07086_demo/overlay.js";
			objScript.type = 'text/javascript';
			objBody.appendChild(objScript);	
		};
	}
}

// Move the element to the garbage bin for proper garbage collection
_page.discardElement = function (el) {
	 var garbageBin = document.getElementById('p-ieleakgarbagebin'); 
	 if (!garbageBin) { 
		 garbageBin = document.createElement('DIV'); 
		 garbageBin.id = 'p-ieleakgarbagebin'; 
		 garbageBin.style.display = 'none'; 
		 document.body.appendChild(garbageBin); 
	 } 
	 garbageBin.appendChild(el); 
	 garbageBin.innerHTML = '';
}

//	CLASS : Events	
_page.Events = {
	__listeners:[],
	// Add event 
	add: function (el, type, fn) {
		if (el.addEventListener) {
			el.addEventListener(type, fn, false);
		} else if (el.attachEvent) {
			el.attachEvent('on' + type, fn);
		}	
		var event = {
			el: el,
			type: type,
			fn: fn
		};
		_page.Events.__listeners.push(event);
		return event;
	},
	// Remove event
	remove: function (el, type, fn) {			
		if (el.removeEventListener) {
			el.removeEventListener(type, fn, false);
		}	
		else if (el.detachEvent) {
			el.detachEvent('on' + type, fn);
		}	
	},
	// Remove SAFELY event to avoid mem leaks, only applicable if you have stored the element
	removeSafe: function (event) {
		if (!event) return;	
		var el = event.el, i,
			type = event.type,
			fn = event.fn;
		_page.Events.remove(el, type, fn);
		for (i = 0; i < this.__listeners.length; i += 1) {
			if (this.__listeners[i] === event) {
				_page.Events.__listeners.splice(i, 1);
				break;
			}
		}
	},
	// Remove All events 
	removeAll: function () {
		 while (_page.Events.__listeners.length > 0) {
			_page.Events.removeSafe(_page.Events.__listeners[0]);
		}	
	},
	// Cancel event
	cancel: function (e) {
		if (!e) {
			e = window.event || {};
		}	
		if (e.stopPropagation) {
			e.stopPropagation();
		}	
		if (e.preventDefault) {
			e.preventDefault();
		}
		e.cancelBubble = true;
		e.cancel = true;
		e.returnValue = false;
		return false;
	},
	// Get target 
	getTarget: function (e) {
		var targ;
		if (!e) {
			e = window.event;
		}	
		if (e.target) {
			targ = e.target;
		} else if (e.srcElement) {
			targ = e.srcElement;
		}	
		if (targ.nodeType === 3) { // defeat Safari bug
			targ = targ.parentNode;
		}	
		return targ;
	}
}
_page.Events.add(window, 'unload', _page.Events.removeAll);

/* CLASS: TABBED NAVIGATION  */
_page.tabs = function (_id, params) {
	params = params || {};
	this.options = {
		activeId:				(params.activeId? params.activeId: ""),
		animationOptions: 		(params.animationOptions? params.animationOptions: null),
		remoteOptions: 			(params.remoteOptions? params.remoteOptions: null),
		processAfterAnimation: 	(typeof params.processAfterAnimation !== "undefined"? params.processAfterAnimation: false),
		useIframeType:			(params.useIframeType? params.useIframeType: null),
		onBeforeBodyOpen: 		(params.onBeforeBodyOpen? params.onBeforeBodyOpen: null),
		onBodyClose:			(params.onBodyClose? params.onBodyClose: null),
		onTabSwitch:			(params.onTabSwitch? params.onTabSwitch: null)
	};
	this.id = _id;
	this.items = [];
	this.activeId = (typeof(this.options.activeId) !== "undefined"? this.options.activeId: "");
	this.openId = '';
	this.bodyActive = false;
	switch (this.options.useIframeType) {
		case "1":
			this.iframeId = "p-navigator-iframe"; 		// Full Iframe - IE 
			break;
		case "2":
			this.iframeId = "p-navigator-iframe-body"; 	// Partial Iframe - Linux 
			break;
		default:
			this.iframeId = "";
	}
	this.effectClose = null;
	this.effectOpen = null;
	this.init();
};

_page.tabs.prototype = {
	init: function () {
		var tabList, tabChilds, i, elTab, tabId, iframe, tabClose, createTabIframes;
		tabList = gE(this.id + "-tabs");
		if (!tabList) return;
		tabChilds = tabList.getElementsByTagName("li");
		for (i = 0; i < tabChilds.length; i += 1) {
			elTab = tabChilds[i];
			tabId = elTab.id.split("-")[2];
			this.items[this.items.length] = tabId;
			elTab.onclick = this.open.bindArgs(this, [tabId], true);
			if (tabId === this.options.activeId) {
				applyStyle(elTab, "p-active");
			}
			if (this.options.useIframeType === "2") {
				var tabAnchor = elTab.firstChild;
				if (tabAnchor) {
					var iframe = this.createIframe("p-tab-" + tabId + "-iframe", "p-tab-iframe", tabAnchor);
					if (iframe) {
						dE(iframe);
					}
				}
			}
		}
		if (this.iframeId !== "") { 
			this.createIframe(this.iframeId, "", gE(this.id));
		}			
		tabClose = gE(this.id + "-close");
		if (tabClose) {
			tabClose.onclick = this.close.bindArgs(this, null, true);
		}	
	},
	createIframe: function (id, className, elParent) {
		if (elParent) {
			var iframe = document.createElement("iframe");
			iframe.id = id;
			iframe.frameBorder = "0";
			iframe.scroll = "none";
			iframe.src = "javascript:false;";
			applyStyle(iframe, className);
			elParent.appendChild(iframe);
			return iframe;
		}
	},
	toggle: function (_id) {
		var id, elTab, elContent, i;
		this.lastOpenId = this.openId;
		this.openId = _id || "";
		if (this.bodyActive === false && this.openId === "") return;	// tabs and body not active
		this.onTabSwitch();
		for(i = 0;i < this.items.length;i += 1) {
			id = this.items[i];
			elTab = gE("p-tab-" + id);
			elContent = gE("p-content-" + id);
			if (id === this.openId) {			// do active one
				applyStyle(elTab, (this.activeId === id? "p-open-active": "p-open"));		
				elContent.style.display = "block";
				elTab.onclick = this.close.bindArgs(this, null, true);
			} else if (this.openId === "") {	// close		
				applyStyle(elTab, (this.activeId === id? "p-active": ""));						
				elContent.style.display = "none";
				elTab.onclick = this.open.bindArgs(this, [id], true);
			} else {						// do the rest except the active one
				applyStyle(elTab, (this.activeId === id? "p-closed-active": "p-closed"));
				elContent.style.display = "none";
				if (id === this.lastOpenId) {
					elTab.onclick = this.open.bindArgs(this, [id], true);
				}
			}
		}
		if (this.openId === "") {
			this.closeBodyAnimated();
		} else if(this.openId !== "" && !this.bodyActive) {
			this.openBodyAnimated();
		}	
		if (this.bodyActive) {
			if (this.options.processAfterAnimation && this.effectOpen && this.effectOpen.running) {
				this.effectOpen.onComplete = this.getContent.bindArgs(this, [_id]);
			} else {			
				this.getContent(_id);
			}
		}
	},
	open: function (_id, _event) {
		if (_event)
			_page.Events.cancel(_event);	
		this.toggle(_id);
	},
	close: function (_event) {
		if (_event)
			_page.Events.cancel(_event);
		this.toggle();
	},
	closeBody: function () {
		var elBody = gE(this.id + "-body-wrapper");
		if (elBody) nE(elBody);
		if (this.iframeId !== "") nE(gE(this.iframeId));
		this.onBodyClose();
	},
	closeBodyAnimated: function () {
		var fxRunningClose, pane;
		this.bodyActive = false;
		if (this.effectOpen) this.effectOpen.stop();
		fxRunningClose = (this.effectClose? this.effectClose.running: false);
		if (this.options.animationOptions !== null && !fxRunningClose && this.options.animationOptions.close) {
			pane = document.getElementById(this.id + '-body');
			this.effectClose = new _page.animationMgr(pane, this.options.animationOptions.close);
			this.effectClose.start(this.options.animationOptions.close.start);
			this.effectClose.onComplete = this.closeBody.bindArgs(this);
		} else {
			this.closeBody();
		}
	},
	openBody: function () {
		var elBody = gE(this.id + "-body-wrapper");
		if (elBody) dE(elBody);
		if (this.iframeId !== "") dE(gE(this.iframeId));
	},
	openBodyAnimated: function () {
		this.onBeforeBodyOpen();
		this.bodyActive = true;
		if (this.options.animationOptions !== null && this.options.animationOptions.open) {
			if (this.effectClose) this.effectClose.stop();
			var pane = document.getElementById(this.id + '-body');				
			this.effectOpen = new _page.animationMgr(pane, this.options.animationOptions.open);
			this.effectOpen.start(this.options.animationOptions.open.start);
		}	
		this.openBody();
	},
	getContent: function (_id, _url) {
		var that,
			remoteOptions = this.options.remoteOptions[_id] || this.options.remoteOptions["*"];	
		if (!remoteOptions.loaded && remoteOptions.url !== "") {
			that = this;
			window.setTimeout(function () {
				_page.loadJSFile(remoteOptions.url, remoteOptions.validateContent, that.onRemoteComplete.bindArgs(that, [_id]), remoteOptions.charset);
			}, 100);
			this.showLoader();
		} else if (remoteOptions.onComplete) {
			this.onRemoteComplete(_id);
		}
	},
	onRemoteComplete: function (_id) {
		var remoteOptions = this.options.remoteOptions[_id] || this.options.remoteOptions["*"];	
		remoteOptions.loaded = true;
		_page.startEvent(remoteOptions, 'onComplete', ["p-content-" + _id]);
	},
	showLoader: function () {
		var elBody, elLoader;
		elBody = gE("p-navigator-body");  
		elLoader = document.createElement("div");
		elLoader.id = "p-navigator-body-loading";
		elBody.appendChild(elLoader);
		elLoader.innerHTML = "<img src=\"" + _page.crsc_server + "/crsc/images/loading_ring_fullframe.gif\" alt=\"Loading...\" />";
	},
	hideLoader: function () {
		var elLoader = gE("p-navigator-body-loading");
		if (elLoader) _page.discardElement(elLoader);
	},
	fadeIn: function () {
		var elBody, elLoader;
		elBody = gE("p-navigator-body");
		elLoader = document.createElement("div");
		elLoader.id = "p-navigator-body-fade";
		elBody.appendChild(elLoader);
		objFade = new _page.animationMgr(elLoader, {duration:500, transition:_page.transition.linear, onComplete:function(elRemove){
				_page.discardElement(elRemove);
			}.bindArgs(null, [elLoader])
		});
		objFade.start({'opacity': [1, 0]});
	},
	onBeforeBodyOpen:	function () {_page.startEvent(this.options, 'onBeforeBodyOpen', [this.openId]);},
	onBodyClose: 		function () {_page.startEvent(this.options, 'onBodyClose', [this.openId]);},
	onTabSwitch: 		function () {_page.startEvent(this.options, 'onTabSwitch', [this.openId]);}
};

/* CLASS: TOP NAVIGATION 2 */
_page.topNav2 = function (id, params) {
	params = params || {};
	params.type = params.type || "";
	this._id = id;
	this._tabId = "p-"+this._id.split("-")[1];
	this.options = {
		type: 				(typeof params.type != "undefined"? params.type: "standard"),
		transparency: 		(typeof params.transparency != "undefined"? params.transparency: (params.type === "inbody"? (_page.browser.isMac || _page.browser.platform === "linux" ? false: true): false)), // By Default ony enable transparency for inbody navigation type
		locale: 			(typeof params.locale != "undefined"? params.locale: _page.locale),
		onload: 			(typeof params.onload != "undefined"? params.onload: true),
		animation: 			(typeof params.animation != "undefined"? params.animation: ( _page.browser.platform === "linux"? false: true)), // Disable animation for Linux
		activeId: 			(typeof params.activeId != "undefined"? params.activeId: ""),
		compatMode:			(typeof params.compatMode != "undefined"? params.compatMode: this.requireCompatMode()),
		onBeforeBodyOpen: 	(typeof params.onBeforeBodyOpen != "undefined"? params.onBeforeBodyOpen: null),
		onBodyClose: 		(typeof params.onBodyClose != "undefined"? params.onBodyClose: null)
	};
	// Shop has an empty array since it optional per locale
	this.navSections = {
		"3": {"consumer": ["Consumer products", "http://www.consumer.philips.com"], "shop": [], "medical": ["Healthcare", "http://www.healthcare.philips.com"], "lighting": ["Lighting", "http://www.lighting.philips.com"], "support": ["Contact and Support", "http://www.philips.com/support"], "about": ["Company and press", "http://www.philips.com/about"]},
		"2": {"consumer": ["Consumer products", "http://www.consumer.philips.com"], "shop":[], "medical": ["Healthcare", "http://www.healthcare.philips.com"], "lighting": ["Lighting", "http://www.lighting.philips.com"],"support":["Contact and Support","http://www.philips.com/support"], "about": ["Company and press", "http://www.philips.com/about"]},
		"1": {"about": ["About Philips", "http://www.philips.com"], "contact": ["Contact Philips", "http://www.philips.com"]}
	};	
	this.siteLevel = _page.getSiteLevelByLocale(this.options.locale);
	this.textFadeRequired = true;
	this.processed = {};
	var arrLocale = this.options.locale.split("_"); 
	this.country = arrLocale[0] || "";
	this.language = arrLocale[1] || "en";
	this.init();
};
_page.topNav2.prototype = {
	init: function () {
		this.html = this.htmlBlock();	 							// Load html
		if (this.options.onload && !this.options.compatMode) {		// Initialize tabs
			_page.onContentReady(this.initTabs.bindArgs(this, [this._tabId]));	
		}
	},
	requireCompatMode: function () {
		try {(function () {}.bindArgs(window))();return false;} catch (e) {compat = false;return true;};
	},
	initTabs: function (tabId) {
		var _tabId = tabId || this._tabId;
		var tabParams = {
			activeId: this.options.activeId,
			animationOptions: (
				this.options.animation? {
					open: {
						id: "",
						start: {'height': [1, (!_page.newHeaderNav? 335: 449)]}, 	// 1 = necessary for IE 5.5 to avoid flickering 
						duration: 900,
						transition: _page.transition.expo.easeOut,
						onStart: this.setAnimationText.bindArgs(this, [this.textFadeRequired])	// Make sure the content is hidden for the text fade
					},
					close: {
						id: "",
						start: {'height': [(!_page.newHeaderNav? 335: 449), 1]}, // 1 = necessary for IE 5.5 to avoid flickering
						duration: 500,
						transition: _page.transition.expo.easeOut
					}
				}: null
			),
			remoteOptions: {		
				"consumer": (
					_page.newHeaderNav && this.options.locale !== "global"? { 	
						// Consumer tab
						url: _page.consumer_nav_server + "/nav/consumer/nav_consumer_" + this.options.locale + ".js",
						onComplete: this.processContent.bindArgs(this),
						loaded: false,
						validateContent: function () {return typeof _page.headerNav.content === 'object'},
						charset: "utf-8"		
					}: null
				),
				"*": {	// Other tabs
					url: _page.crsc_nav_server+"/nav/nav_" + this.options.locale + ".js",
					onComplete: this.processContent.bindArgs(this),
					loaded: false,
					validateContent: function () {return typeof headernav ==='object'},
					charset: "utf-8"
				}
			},
			processAfterAnimation: true,
			useIframeType: (_page.browser.platform === "linux" || useIframe? ( _page.browser.platform === "linux" && this.options.type === "inbody"? "2": "1"): null ),
			onTabSwitch: this.hideContent.bindArgs(this),
			onBeforeBodyOpen: this.options.onBeforeBodyOpen,
			onBodyClose: this.options.onBodyClose
		};
		tabParams.remoteOptions["shop"] = tabParams.remoteOptions["consumer"];
		this.tabs = new _page.tabs(_tabId, tabParams);
		window.setTimeout(this.autoOpenTab.bindArgs(this), 10);
	},
	closeAllTabs: function () {
		if (this.tabs) {
			this.tabs.close();
		}
	},
	setAnimationText: function (fadeRequired) {
		this.textFadeRequired = (typeof fadeRequired !== "undefined"? fadeRequired: this.textFadeRequired);
	},
	autoOpenTab: function () {
		var params = this.getHashParams(),
			openId = params[1] || "",
			openSubId = params[2] || "";			
		if (openId !== "" && this.isValidSection(openId)) {
			this.setSectionActiveId(openId, openSubId);
			this.tabs.open(openId);
		}
	},
	isValidSection: function (section) {
		return (this.navSections[this.siteLevel][section]? true: false);
	},
	setSectionActiveId: function (section, subId) {
		var section = section || "", subId = subId || "";
		if (this.navSections[this.siteLevel][section] && subId !== "") {
			this.navSections[this.siteLevel][section][2] = subId;
		}	
	},
	getSectionActiveId: function (section) {
		section = section || "";
		var obj = this.navSections[this.siteLevel][section] || [];
		return (obj[2] || "");
	},
	getHashParams: function (sHash) {  
		try {sHash = sHash || window.location.hash; } catch (e) { sHash = sHash || ""; }
		return (sHash.match(/headernav\/([^\/]*)\/?([^\/]*)/i) || []);
	},
	hideContent: function () {
		var i, elTabAnchor, id,
			elContent = gE("p-content-"+this.tabs.openId);
		if (elContent) {
			hE(elContent);		
		}
		if (this.tabs.bodyActive) {		//Clear all highlighted tabs
			for (i = 0;i < this.tabs.items.length; i += 1) {
				id = this.tabs.items[i];
				elTabAnchor = gE("p-tab-" + id);	
				applyStyle(elTabAnchor, (this.options.activeId === this.tabs.openId? "p-closed-active": "p-closed"));
			 } 
		}
	},
	showContent: function () {
		var elContent, objFade, that = this, tabAnchor;
		elContent = gE("p-content-" + this.tabs.openId);
		if (elContent) {
			this.tabs.hideLoader();
			sE(elContent);
			if (this.textFadeRequired && !_page.browser.isMac && this.options.animation) {
				if (_page.newHeaderNav) {
					this.tabs.fadeIn();
				} else { // Backwards compatible transparency fade
					objFade = new _page.animationMgr(elContent, {duration: 500, transition: _page.transition.linear});	
					objFade.start({'opacity': [0, 1]});
				}
				this.textFadeRequired = false;
			}
			tabAnchor = gE('p-tab-' + this.tabs.openId);
			applyStyle(tabAnchor, (this.options.activeId === this.tabs.openId? "p-body-open-active": "p-body-open"));
			// Omniture tracking asynchronously
			if (_page.metrics && _page.metrics.trackAjax && this.tabs.openId === "consumer") {
				window.setTimeout(function () {
					_page.metrics.trackAjax({
						"division": "CP",
						"section": "main",
						"pagename": "consumer_landing_page",
						"country": that.country,
						"language": that.language,
						"catalogtype": ""
					})
				}, 500);
			}
		}
	},
	processContent: function (_id) {
		var _obj, section, obj, countryRanking, sFeedKey, elGrid, maxLimit, showMore, lastCol, colMax, promotionCount, popularCount, promotionShow, popularShow, paramsLS, lsConsumer, html, oSearch,
			_helper = _page.html_helper.topnav,
			elParent = gE(_id);
		if (!elParent) {
			return;
		}	
		section = _id.split("-")[2] || "";
		_obj = (_page.newHeaderNav && ((section === "consumer" && this.options.locale !== "global") || section === "shop") ? this.content: headernav) || {};
		if (!this.processed[section] && this.tabs.bodyActive) {
			// Process html per specific country ranking and section
			// Available grid helper functions
			// - Creating a grid: 			-	_helper.buildGrid(classname)		>	returns grid object
			// - Adding columns to the grid:	-	grid.addCols(1 or more classnames)	>	creates col array, returns grid object
			// - Adding elements to columns: 	-	grid.col[index].appendElement 	>	function is error proof, object may be null
			// - Remove empty columsn of grid:   	 -	grid.removeEmptyCols()
			obj = _obj[section];
			this.processed[section] = _helper.buildAltMessageGrid(elParent, obj);	// Create alt message if necessary
			if (!this.processed[section]) {
				this.processed[section] = true;
				countryRanking = this.siteLevel;
				sFeedKey = obj? countryRanking + "_" + section: "";
				switch(sFeedKey) {
				case "3_consumer": case "2_consumer":
					if (_page.newHeaderNav && this.options.locale !== "global") {
						this.consumerCatalog = _helper.consumerCatalog().init({
							source: obj.catalog,
							elParent: elParent,
							activeItem: this.getSectionActiveId("consumer"),
							country: this.country,
							language: this.language
						});
						_helper.buildBottomLinks(elParent, obj.links);
					} else {				
						if (this.options.locale === "global") {
							elGrid = _helper.buildGrid(elParent, 'p-grid-3').addCols("p-column-1", "p-divider", "p-column-2", "p-column-3");
							elGrid.col[0].appendElement(_helper.createHeader('h4', obj.language_selector));
							lsConsumer = new _page.ls('2', {
								remoteUrl: _page.crsc_server+"/crsc/locales/homepages_consumer",
								localeFlag: "global",
								localeText: "Choose country / language",
								showRows: 10,
								listHeight: 309, // 228 / Set list height if can't determined dynamically
								keepActive: true,
								removeLocaleList: ["global", "others"]
							});
							elGrid.col[0].innerHTML += lsConsumer.html;
							window.setTimeout(lsConsumer._show.bindArgs(lsConsumer), 500);
							elGrid.col[2].appendElement(_helper.createHeader('h4', obj.new_products));
							_helper.buildList(elGrid.col[2],obj.new_products, "product", true);
							elGrid.col[3].appendElement(_helper.createHeader('h4', {name: "&nbsp;"}));// dummy spacer
							_helper.buildList(elGrid.col[3],obj.new_products, "product");
						} else {
							maxLimit = (countryRanking === 3? null: 2); // Level 3: don't cut off items, other levels: cut off items
							showMore = (countryRanking === 3? 2: null); // Level3: showmore link >= 2 items , other levels: default behaviour
							elGrid = _helper.buildGrid(elParent, 'p-grid-2').addCols("p-column-1", "p-column-2", "p-divider", "p-column-3");
							elGrid.col[0].appendElement(_helper.createHeader('h4', obj.catalog));
							_helper.buildCategoryList(elGrid.col[0], obj.catalog, true, maxLimit, showMore);
							elGrid.col[1].appendElement(_helper.createHeader('h4', {name: '&nbsp;'})); // Spacer
							_helper.buildCategoryList(elGrid.col[1], obj.catalog, true, maxLimit, showMore);
							// PRIO 1: show consumer categories
							lastCol = elGrid.col[3];
							if (obj.catalog.start < obj.catalog.categories.length) {
								// Remove divider in case of category items in last column  
								lastCol = elGrid.col[2];
								applyStyle(elGrid.col[2], "p-column-3");
								_page.discardElement(elGrid.lastChild) // tmp IE 5 fix
								elGrid.col.splice(3, 1); 			   // tmp IE 5 fix
							}
							_helper.buildCategoryList(lastCol, obj.catalog, false, maxLimit, showMore);
							// PRIO 2: Promotion
							colMax = 3;
							promotionCount = (!obj.promotion || !obj.promotion.items.length? 0: obj.promotion.items.length);
							popularCount = (!obj.most_popular || !obj.most_popular.items.length? 0: obj.most_popular.items.length);
							promotionShow = (promotionCount>colMax? colMax: promotionCount);
							popularShow = (popularCount === 0? 0: colMax-promotionShow);		
							if (promotionShow !== 0) {
								obj.promotion.max = promotionShow;
								lastCol.appendElement(_helper.createHeader('h4', obj.promotion));
								_helper.buildList(lastCol, obj.promotion, "product");
								if (_helper.contentHeightOverflow(lastCol)) {	// remove whole block	
									_page.discardElement(lastCol.lastChild);
									_page.discardElement(lastCol.lastChild);
								}
							}
							// PRIO 3: Most popular
							if (popularShow !== 0) {
								if (promotionShow !== 0) lastCol.appendElement(_helper.createHRule());
								obj.most_popular.max = popularShow;
								lastCol.appendElement(_helper.createHeader('h4', obj.most_popular));
								_helper.buildList(lastCol, obj.most_popular, "product");
								lastCol.appendElement(_helper.buildMultipleButtons(obj.buttons));
								if (_helper.contentHeightOverflow(lastCol)) {	// remove whole block 	
									if (promotionShow !== 0) _page.discardElement(lastCol.lastChild);
									_page.discardElement(lastCol.lastChild);
									_page.discardElement(lastCol.lastChild);
									if (obj.buttons) _page.discardElement(lastCol.lastChild);
								}
							}
						}
						elGrid.removeEmptyCols();
					}
					break;
				case "3_shop": case "2_shop": 
					html = "";
					elGrid = _helper.buildGrid(elParent, 'p-grid-6').addCols("p-column-1", "p-column-2");
					if	(obj.online_store) {
						elGrid.col[0].appendElement(_helper.createHeader('h4', obj.online_store));
						html = "<div class=\"p-banner\">";
						html += _helper.createLink({name: (_helper.createImage(obj.online_store.banner)), href: obj.online_store.banner.href});
						html += "</div>";
						elGrid.col[0].innerHTML  += html;
					}
					if (obj.local_store) {
						elGrid.col[1].appendElement(_helper.createHeader('h4', obj.local_store));
						html = "<div class=\"p-banner\">";
						html += _helper.createLink({name: (_helper.createImage(obj.local_store.banner)), href: obj.local_store.banner.href});
						if (obj.local_store.search) {
							oSearch = obj.local_store.search;
							html += "<form id=\"p-shop-localstore-form\" name=\"shop_localstore_form\" method=\"POST\" action=\"" + (oSearch.targetURL || "") + "\">\n";	
							html += "	<fieldset>\n";
							html += "		<label for=\"p-shopquery\">" + (oSearch.submitValue || "Search")+"</label>\n";	
							html += "		<input type=\"text\" size=\"30\" id=\"p-shopquery\" name=\"searchAddress\" class=\"p-keyword\" onclick=\"this.value='';\" value=\"" + (oSearch.inputValue || "") + "\" />\n";
							html += "		<input type=\"hidden\" name=\"country\" value=\"" + this.country + "\" />\n";
							html += "		<input type=\"hidden\" name=\"language\" value=\"" + this.language + "\" />\n";
							html += "		<input type=\"hidden\" name=\"catalogType\" value=\"CONSUMER\" />\n";
							html += 		_helper.buildButton({name: (oSearch.submitValue || "Search"), type: "action", eId: "p-shop-localstore-submit", evtOnClick: "document.shop_localstore_form.submit()" });
							html += "	</fieldset>\n";
							html += "</form>\n";
						}
						html += "</div>";
						elGrid.col[1].innerHTML += html;
					}	
					elGrid.removeEmptyCols();
					break;
				case "3_medical": case "2_medical":	
					if (obj.country && obj.product) {
						// No web presence for selected locale
						paramsLS = {type: '2', params: {remoteUrl: _page.crsc_server + "/crsc/locales/homepages_medical", showRows: (_page.newHeaderNav? 8: 5)}};
						_helper.buildNoWebPresenceGrid(elParent, obj, paramsLS);
					} else {
						elGrid = _helper.buildGrid(elParent, 'p-grid-2').addCols("p-column-1", "p-column-2", "p-divider", "p-column-3");
						elGrid.col[0].appendElement(_helper.createHeader('h4', obj.professional));
						_helper.buildCategoryList(elGrid.col[0], obj.professional, true);
						_helper.buildCategoryList(elGrid.col[1], obj.professional, false);
						elGrid.col[1].appendElement(_helper.createHeader('h4', obj.personal));
						_helper.buildCategoryList(elGrid.col[1], obj.personal, false);
						elGrid.col[3].appendElement(_helper.createHeader('h4', obj.articles));
						obj.articles = obj.articles || [];
						obj.articles.max = (_page.newHeaderNav? 2 :null);
						_helper.buildList(elGrid.col[3], obj.articles, "article");
						elGrid.removeEmptyCols();
					}
					_helper.buildBottomLinks(elParent,obj.links);
					break;
				case "3_lighting": case "2_lighting":
					if (obj.country && obj.product) {
						// No web presence for selected locale
						paramsLS = {type: '2', params: {remoteUrl: _page.crsc_server + "/crsc/locales/homepages_lighting", showRows: (_page.newHeaderNav? 8: 5)}};
						_helper.buildNoWebPresenceGrid(elParent, obj, paramsLS);
					} else {
						// Has web presence for selected locale	
						elGrid = _helper.buildGrid(elParent, 'p-grid-2').addCols("p-column-1", "p-column-2", "p-divider", "p-column-3");
						elGrid.col[0].appendElement(_helper.createHeader('h4', obj.professional));
						_helper.buildCategoryList(elGrid.col[0], obj.professional, true);
						_helper.buildCategoryList(elGrid.col[1], obj.professional, false);
						elGrid.col[1].appendElement(_helper.createHeader('h4', obj.consumer));
						_helper.buildCategoryList(elGrid.col[1],obj.consumer, false);
						elGrid.col[3].appendElement(_helper.createHeader('h4', obj.articles));
						obj.articles = obj.articles || [];
						obj.articles.max = (_page.newHeaderNav? 2: null);
						_helper.buildList(elGrid.col[3], obj.articles, "article");
						elGrid.removeEmptyCols();
					}
					_helper.buildBottomLinks(elParent, obj.links);
					break;
				case "3_support": case "2_support":
					if (this.options.locale === "global") {
						elGrid = _helper.buildGrid(elParent, 'p-grid-3').addCols("p-column-1", "p-divider", "p-column-2");
						elGrid.col[0].appendElement(_helper.createHeader('h4', obj.language_selector || {"name": "Consumer Support"}));
						elGrid.col[0].innerHTML += (obj.language_selector && obj.language_selector.description? obj.language_selector: "<div class=\"p-description\"><p>For Consumer Products we have extensive support information like:</p><br /><ul><li>Frequently asked questions</li><li>Manuals</li><li>Software</li><li>Tutorials</li><li>Warranty information</li></ul><br /><p>This information is specific for the country where you live.</p><br /><p>Please select your country in the selection box below and then proceed with the required support.</p><br /><br /></div>");
						lsConsumer = new _page.ls('2', {
							remoteUrl: _page.crsc_server + "/crsc/locales/homepages_semi",
							localeFlag: "global",
							localeText: "Choose country / language",
							showRows: (_page.newHeaderNav? 10: 7),
							listHeight: 228, // Set list height if can't determined dynamically
							collapseDirection: "up",
							removeLocaleList: ["global", "others"]
						});
						elGrid.col[0].innerHTML += lsConsumer.html;
						elGrid.col[2].appendElement(_helper.createHeader('h4', obj.professional));
						_helper.buildCategoryList(elGrid.col[2], obj.professional);
						elGrid.col[2].appendElement(_helper.createHeader('h4', obj.all));
						_helper.buildCategoryList(elGrid.col[2], obj.all);
					} else {
						elGrid = _helper.buildGrid(elParent, 'p-grid-1').addCols("p-column-1", "p-column-2", "p-column-3");
						elGrid.col[0].appendElement(_helper.createHeader('h4', obj.consumer));
						_helper.buildCategoryList(elGrid.col[0], obj.consumer, true, 2);
						_helper.buildCategoryList(elGrid.col[1], obj.consumer, false, 2);
						elGrid.col[2].appendElement(_helper.createHeader('h4', obj.professional));
						_helper.buildCategoryList(elGrid.col[2], obj.professional);
						elGrid.col[2].appendElement(_helper.createHeader('h4', obj.all));
						_helper.buildCategoryList(elGrid.col[2], obj.all);
					}
					elGrid.removeEmptyCols();
					_helper.buildBottomLinks(elParent, obj.links);
					break;	
				case "3_about": case "2_about":
					elGrid = _helper.buildGrid(elParent, 'p-grid-2').addCols("p-column-1", "p-column-2", "p-divider", "p-column-3");
					elGrid.col[0].appendElement(_helper.createHeader('h4', obj.company));
					_helper.buildCategoryList(elGrid.col[0], obj.company);
					elGrid.col[1].appendElement(_helper.createHeader('h4', obj.careers));
					_helper.buildCategoryList(elGrid.col[1], obj.careers);
					elGrid.col[1].appendElement(_helper.createHeader('h4', obj.news_center));
					_helper.buildCategoryList(elGrid.col[1], obj.news_center);
					elGrid.col[3].appendElement(_helper.createHeader('h4', obj.latest_news));
					_helper.buildList(elGrid.col[3], obj.latest_news, "news");
					elGrid.removeEmptyCols();
					_helper.buildBottomLinks(elParent, obj.links);
					break;
				case "1_about":
					paramsLS = {type: '2', params: {remoteUrl: _page.crsc_server + "/crsc/locales/homepages", localeFlag: "global", localeText: "Choose country / language", showRows: 5}};
					_helper.buildNoWebPresenceGrid(elParent, obj, paramsLS);
					break;
				case "1_contact":
					elParent.appendChild(_helper.createHeader('h4', obj.block1));
					elGrid = _helper.buildGrid(elParent, 'p-grid-6').addCols("p-column-1 p-content", "p-column-2 p-content");
					elGrid.col[0].innerHTML += (obj.block1 && obj.block1.html? obj.block1.html: "");
					elGrid.col[1].innerHTML += (obj.block1 && obj.block2.html? obj.block2.html: "");
					elGrid.removeEmptyCols();
					break;	
				default:
					_helper.buildAltMessageGrid(elParent, {alt: {name: "Error", html: "<p>Section could not be found in data feed...</p>"}}); 
				}
			}
		}
		this.showContent();
	},
	htmlBlock: function () {
		var html, classNavNames, _navSections, navId, navObj, tabText, tabLink;
		html = "";
		classNavNames = (this.options.type !== ""? "p-" + this.options.type + " ": "") + (this.options.transparency? "p-opacity": "");
		html += "<div id=\"" + this._id + "\" " + (classNavNames !== ""? "class=\"" + classNavNames + "\"": "") + ">\n";
		html += "	<div id=\"p-navigator-tabs-wrapper\" class=\"p-clearfix\">\n"; 
		html += "		<ul id=\"p-navigator-tabs\">\n"; 
		_navSections = this.navSections[this.siteLevel];
		for (navId in _navSections) {
			if (typeof navId === "string") {
				navObj = (_page.topNav[(navId === "support"? "semi": navId)] || {})[0] || _navSections[navId]; // Exception added for support, which uses the semi id for the text translation and link
				tabText = navObj[0] || ""; 
				tabLink = navObj[1] || "";
				if (tabText !== "") {
					html += "		<li id=\"p-tab-"+navId+"\"><a href=\"" + (this.options.compatMode? tabLink: "javascript:void(0)") + "\"><span><nobr>" + tabText + "</nobr></span></a></li>\n";
				}
			}
		}
		html += "		</ul>\n";	
		html += "	</div>\n";	
		html += "	<div id=\"p-navigator-body-wrapper\" class=\"p-clearfix\" >\n";
		html += "		<div id=\"p-navigator-body\">\n";
		html += "			<div id=\"p-navigator-shadow-wrapper\">\n";
		html += '				<div class="p-shadow-left"></div>\n';
		html += "				<div id=\"p-navigator-content-wrapper\">\n";
		for (navId in _navSections) {
			if (typeof navId === "string") {
				navObj = (_page.topNav[(navId === "support"? "semi": navId)] || {})[0] || _navSections[navId]; // Exception added for support, which uses the semi id for the text translation and link
				tabText = navObj[0] || ""; 
				if (tabText !== "") {
					html += "				<div id=\"p-content-"+navId+"\" class=\"p-tab-content\"></div>\n";
				}
			}	
		}	
		html += "				</div>\n";				
		html += '				<div class="p-shadow-right"></div>\n';
		html += '			</div>\n';
		html += "			<a id=\"p-navigator-close\" class=\"p-close\" href=\"javascript:void(0)\"></a>\n";
		html += '		</div>\n';
		html += '		<div class="p-shadow-bottom"></div>\n';
		html += '	</div>\n';
		html += '</div>\n';
		return html;
	}
};	

/* STATIC CLASS:  HTML_HELPER */
_page.html_helper = {
	// TOP NAVIGATION HTML Helpers 
	topnav: { 
		// Bottom Links
		buildBottomLinks: function (oTarget, oSource) {
			var elWrapper;
			if (oSource) {
				oSource.max = 3;
			}	
			elWrapper = document.createElement("div");
			applyStyle(elWrapper, "p-tab-content-bottom");
			this.buildList(elWrapper, oSource, "sitespecific", false);
			oTarget.appendChild(elWrapper);
		},
		// Grid
		buildGrid: function (oTarget, sGridName) {
			var elGrid, elCol, i;
			elGrid = document.createElement("div");
			applyStyle(elGrid, sGridName);				
			if (oTarget) oTarget.appendChild(elGrid);
			elGrid.addCols = function (sColName) {
				this.col = [];
				for (i = 0;i < arguments.length;i += 1) {
					elCol = document.createElement("div");
					applyStyle(elCol,arguments[i]);
					this.appendChild(elCol);
					this.col[i] = elCol;
					this.col[i].appendElement = function (el) {if (el) this.appendChild(el);return this;};
					elCol = null;
				}	
				return this;
			}
			elGrid.removeEmptyCols = function () {
				var prevCol, colStyle, i;
				for (i = (this.col.length - 1); i >= 0; i -= 1) {
					prevCol = this.col[i + 1] || null;
					colStyle = getStyle(this.col[i]);
					if (	(prevCol == null && colStyle == "p-divider") || (this.col[i].innerHTML == "" && colStyle != "p-divider")) {
						_page.discardElement(this.col[i]);
						this.col.splice(i, 1);			// Remove element from column array
					}
				}
				this.cleanUp();
				return this;
			}
			elGrid.equalHeight = function (size) {
				var blnGetSize, elCol, elHeader, maxSize = 0;
				blnGetSize = (typeof size === "undefined"? true: false);				
				for (i = 0; i < this.col.length; i += 1) {
					elCol = this.col[i];
					elHeader = elCol.firstChild;
					if (elHeader && /h4/i.test(elHeader.nodeName)) {
						if (blnGetSize) {
							size = parseInt(elHeader.offsetHeight);
							maxSize = (size > maxSize? size: maxSize);							
						} else {
							elHeader.style.height = size + "px";
						}
					}
				}
				if (blnGetSize) {
					arguments.callee.apply(this, [maxSize]);
				}
			}
			elGrid.cleanUp = function () {
				elGrid = null;
			}
			return elGrid;
		},
		// Generic list
		buildList: function(oTarget, oSource, type, autoFit) {
			if (!oSource) return;
			var strCurLanguage, iCharLimit, useImages, elList, curItem, elListItem, tmpHTML, i, span,
				checkDoubleLine = false ;
			oSource.start = oSource.start || 0;
			oSource.items = oSource.items || oSource.categories || oSource;
			oSource.max = oSource.max || oSource.items.length;
			if (oSource.start >= oSource.max || oSource.items.length === 0) return;
			// type: product / article / news
			strCurLanguage = _page.locale.split("_")[1] || "en";
			iCharLimit = (strCurLanguage === "ja" || strCurLanguage === "zh" || strCurLanguage === "th" || strCurLanguage === "ru" || strCurLanguage === "ko"? 40: (_page.newHeaderNav? 95: 70));
			useImages = (type === "article" || type === "product"? true: false);
			elList = document.createElement("ul");
			applyStyle(elList,"p-" + type + "-list");
			oTarget.appendChild(elList);
			for (i = oSource.start; i < oSource.max;i += 1) {
				curItem = oSource.items[i];
				if (typeof curItem === "undefined") break;
				elListItem = document.createElement("li");
				elList.appendChild(elListItem);
				tmpHTML = "";
				if (useImages) {
					applyStyle(elListItem,"p-clearfix");
					tmpHTML += (curItem.src? "<div class=\"p-image\">" + _page.html_helper.topnav.createLink({name: "<img src=\"" + curItem.src + "\" alt=\"" + (curItem.alt? curItem.alt: "") + "\"></img>", href:curItem.href}) + "</div>": "");
				}	
				switch (type) {
				case "product":
					tmpHTML += "<div class=\"p-content\">";
					tmpHTML += (curItem.href? "<a href=\"" + curItem.href+"\">": "");
					tmpHTML += (curItem.name? "<span class=\"p-subheader\">" + curItem.name + "</span>": "");
					tmpHTML += (curItem.special? "<span class=\"p-special\">" + curItem.special + "</span>": "");
					tmpHTML += (curItem.href? "</a>": "");
					tmpHTML += "</div>";
					break;    
				case "article":
					tmpHTML += "<div class=\"p-content\">";
					tmpHTML += (curItem.name? "<h5 class=\"p-subheader\">" + _page.html_helper.topnav.createLink(curItem) + "</h5>":"");
					tmpHTML += (curItem.description? "<p class=\"p-description\">" + _page.html_helper.topnav.limitChar(curItem.description, iCharLimit) + "</p>":"");
					tmpHTML += (_page.newHeaderNav? "<span class=\"p-moreinfo\">" + _page.html_helper.topnav.createLink({name: (_page.text["readmore"] || _page.text["more_label"] || "More") + "<span class=\"p-marker-2\">&nbsp;</span>", href: curItem.href}) + "</span>":"");
					tmpHTML += "</div>";
					break;
				 case "news":
				 	tmpHTML += "<div class=\"p-content\">";
					tmpHTML += (curItem.date? "<span class=\"p-date\">" + curItem.date + "</span>": "");
					tmpHTML += (curItem.name? "<h5 class=\"p-subheader\">" + _page.html_helper.topnav.createLink(curItem) + "</h5>": "");
					tmpHTML += (curItem.description? "<p class=\"p-description\">" + _page.html_helper.topnav.limitChar(curItem.description, iCharLimit) + "</p>":"");
					tmpHTML += "</div>";
					break;
				case "cat2":
					tmpHTML += "<div class=\"p-image\">" + this.createLink({name: (this.createImage(curItem)), href: curItem.href}) + "</div>\n";
					tmpHTML += "<div class=\"p-content\">" + this.createLink({name: "<span>" + curItem.name + "</span>", href:curItem.href}) + "</div>\n";
					tmpHTML += "&nbsp;\n"; // Do not remove this, necessary for IE to overcome the white space gap bug between list items.
					checkDoubleLine = true;
					break;
				case "sitespecific":
					tmpHTML += this.createLink({
						name: (
							(curItem.name && curItem.name !== ""? "<span class=\"p-subheader\">" + curItem.name + "<span class=\"p-marker-1\">&nbsp;</span></span>": "")+ // Header
							(curItem.description && curItem.description !== ""? "<span class=\"p-description\">" + curItem.description + "</span>": "") // Text
						),
						href: curItem.href
					});			
					if (i === (oSource.max - 1)) {
						elListItem.className += " p-lastitem";
					}
					break;
				}
				elListItem.innerHTML = tmpHTML; 
				if (checkDoubleLine) {
					span = elListItem.getElementsByTagName("span")[0];
					if (span && span.offsetHeight > 30) {
						applyStyle(span, "p-doubleline");
					}
				}
				if (autoFit && _page.html_helper.topnav.contentHeightOverflow(oTarget, elList)) {
					_page.discardElement(elListItem);
					oSource.start = i;
					break;
				}
			}
			// Post processing
			switch (type) {
				case "cat2":
					if (i < oSource.max) {
						applyStyle(elList, "p-cat2-list p-bottom-shadow");
					}
				break;
			}	
			oSource.start = i;
		},
		// Category list 
		buildCategoryList: function (oTarget, oSource, autoFit, limitSubItems, showMoreSubItems ) {  // Removed elList
			if (!oSource) return;
			var iLimitSubItems, iShowMoreSubItems, sSubCatItemSep, sCatDescription, curCatItem, elListItem, strCatItemLink, elHeader, sSubCatHTML, bSubCatItemLimit, bSubCatShowMore, iSubCatItemsLength, curSubCatItem, curSubCatItemLink, elEntry, i, x;
			iLimitSubItems = limitSubItems || null;	   		// Limit the visible items
			iShowMoreSubItems = showMoreSubItems || null; 	// Show more link  from number of items
			if (autoFit) oTarget.style.overflow = "hidden";
			oSource.categories = oSource.categories || [];
			oSource.categories = oSource.categories.concat(oSource.add_categories || []); 	// Concat add_categories array to categories
			oSource.add_categories = [];													// Reset add_categories array after concatenation
			oSource.start = (oSource.start? oSource.start: 0);
			oSource.max = oSource.max || oSource.categories.length; // added
			if (oSource.start >= oSource.max) return;
			// Start category list
			sSubCatItemSep = ",";
			sCatDescription = _page.text["category_intro"];
			elList = document.createElement("ul");
			oTarget.appendChild(elList);
			applyStyle(elList, "p-cat-list");
			for (i = oSource.start; i < oSource.max; i += 1) { // changed
				curCatItem = oSource.categories[i];
				if (!curCatItem) break;
				elListItem = document.createElement("li");
				elList.appendChild(elListItem);
				strCatItemLink = curCatItem.href || "";				
				elHeader = _page.html_helper.topnav.createHeader('h5', curCatItem);
				elListItem.appendChild(elHeader);
				applyStyle(elHeader, "p-clearfix");
				if (curCatItem.items) {
					if (curCatItem.items.length > 0) {
						// Subcat items
						sSubCatHTML = '';
						bSubCatItemLimit = (iLimitSubItems != null? iLimitSubItems < curCatItem.items.length: false);
						bSubCatShowMore = (iShowMoreSubItems != null? iShowMoreSubItems <= curCatItem.items.length: bSubCatItemLimit);
						iSubCatItemsLength = (bSubCatItemLimit? iLimitSubItems: curCatItem.items.length); 
						for (x = 0; x < iSubCatItemsLength; x += 1) {
							curSubCatItem = curCatItem.items[x];
							curSubCatItemLink = _page.html_helper.topnav.createLink(curSubCatItem);
							sSubCatHTML += (x !== 0 && curSubCatItemLink !==""? sSubCatItemSep + " ": "") + curSubCatItemLink; 	
						}
						if (sSubCatHTML !=="" ) {
							sSubCatHTML += (bSubCatShowMore? sSubCatItemSep + " " + _page.html_helper.topnav.createLink({name: "...", href: strCatItemLink}): "");
							elEntry = document.createElement("p");
							elListItem.appendChild(elEntry);
							elEntry.innerHTML = sSubCatHTML;
						}
					}
				}
				if (autoFit && _page.html_helper.topnav.contentHeightOverflow(oTarget, elList)) {
					_page.discardElement(elListItem);
					oSource.start = i;
					break;
				}
			}
			oSource.start = i;
		},
		// Creates the no web presence grid
		buildNoWebPresenceGrid: function (oTarget, oSource, paramsLS) {
			if (!oSource) return;
			var elGrid, elLinks, lsConsumer;
			elGrid = _page.html_helper.topnav.buildGrid(oTarget, 'p-grid-4').addCols("p-column-1 p-content", "p-divider","p-column-2");
			elGrid.col[0].style.overflow = "auto";
			elGrid.col[0].appendElement(_page.html_helper.topnav.createHeader('h4', oSource.country));
			elGrid.col[0].innerHTML += oSource.country.html;
			elGrid.col[2].appendElement(_page.html_helper.topnav.createHeader('h4', oSource.product));
			elGrid.col[2].innerHTML += "<p>" + (oSource.product.description || "") + "</p><br />\n";
			lsConsumer = new _page.ls(paramsLS.type, paramsLS.params);
			elGrid.col[2].innerHTML += lsConsumer.html + "<br />";
			if (oSource.general) {
				elGrid.col[2].appendElement(_page.html_helper.topnav.createHeader('h4', oSource.general));
				elGrid.col[2].innerHTML += "<p class=\"p-notopmargin\">"+(oSource.general.description || "") + "</p><br />\n";
				elLinks = _page.html_helper.topnav.buildGrid(elGrid.col[2], 'p-columns').addCols("p-col-1", "p-col-2");
				_page.html_helper.topnav.buildCategoryList(elLinks.col[0], oSource.general, true);
				_page.html_helper.topnav.buildCategoryList(elLinks.col[1], oSource.general,true);
				elLinks.removeEmptyCols();
			}
			elGrid.removeEmptyCols();
		},
		// Displays alt message if alt object is available and no other sibling objects exist
		buildAltMessageGrid: function (oTarget, oSource) {
			if (!oSource) return;
			var altBuilt = false, i = 0, elGrid, id;
			for (id in oSource) i++;
			if (i === 1 && oSource.alt) {
				elGrid = _page.html_helper.topnav.buildGrid(oTarget, 'p-grid-5').addCols("p-column-1");
				elGrid.col[0].appendChild(_page.html_helper.topnav.createHeader('h4', (oSource.alt.name? oSource.alt: {name: "&nbsp;"})))
				elGrid.col[0].innerHTML += oSource.alt.html; 
				elGrid.removeEmptyCols();
				altBuilt = true;
			}
			return altBuilt;
		},
		// Limit visible characters 
		limitChar: function (str, max, end) {
			// Put str in div to encode the characters and for the correct character length
			var divEncode, afterWord, afterTotal, beforeWord;
			str = str || "", max = max || 90, end = end || "...";
			divEncode = document.createElement("div");
			divEncode.id = "p-encode-test";
			divEncode.innerHTML = str;
			str = divEncode.innerHTML;
			_page.discardElement(divEncode);
			afterTotal = str.substring(max);
			afterWord = afterTotal.substring(0, afterTotal.indexOf(" "));						
			beforeWord = str.substring(0, max);
			return beforeWord + (trim(afterTotal) !== "" || trim(afterWord) !== ""? afterWord + end: "");
		},
		// Does content overflows allowed
		contentHeightOverflow: function (oTarget, oSource) {
			oSource = oSource || oTarget.lastChild;				
			offsetTopSource = (_page.browser.isIE? oSource.offsetTop: (oSource.offsetTop - oTarget.offsetTop)); // parentNode seems to tbe the offsetParent in IE
			return (oSource && oTarget && ((oSource.offsetHeight + offsetTopSource) > oTarget.offsetHeight)? true: false);
		},
		// Single button 
		buildButton: function (oSource) {
			oSource = oSource || {};
			htmlClass = " class=\"p-button" + (oSource.type && oSource.type !== ""? "-" + oSource.type: "") + "\"";
			htmlOnClick = (oSource.evtOnClick && oSource.evtOnClick !== ""? " onclick=\"" + oSource.evtOnClick + "\"": "");
			htmlId = (oSource.eId && oSource.eId !== ""? " id=\"" + oSource.eId + "\"": "");
			return "<table cellspacing=\"0\"" + htmlId + htmlClass + htmlOnClick + " ><tr><td><div>"+_page.html_helper.topnav.createLink(oSource)+"</div></td></tr></table>";
		},
		// Multiple buttons 
		buildMultipleButtons: function (oSource) {
			if (!oSource || oSource.length == 0) return;
			var elBtnContainer = document.createElement("div"), i;
			applyStyle(elBtnContainer,"p-buttons p-clearfix");
			for (i = 0; i < oSource.length; i += 1) {
				elBtnContainer.innerHTML += _page.html_helper.topnav.buildButton(oSource[i]);
			}
			return elBtnContainer;
		},
		// Horizontal rule
		createHRule: function () {
			elRule = document.createElement("div");
			elRule.appendChild(document.createElement("hr"));
			applyStyle(elRule, "p-hrule");
			return elRule;
		},		
		// Generic header 
		createHeader: function (elName, oSource) {
			var elHeader = null, strHeader;
			strHeader = _page.html_helper.topnav.createLink(oSource);
			if (strHeader !== "") {
				elHeader = document.createElement(elName);
				elHeader.innerHTML = strHeader;
			}
			return elHeader;
		},
		// Generic image
		createImage: function (oSource) {
			var imgSrc = (oSource.src && oSource.src !== ""? " src=\"" + oSource.src + "\"": ""),
				imgAlt = " alt=\"" + (oSource.alt || "") + "\"",
				imgHeight = (oSource.height && oSource.height !== ""? " height=\"" + oSource.height + "\"": ""),
				imgWidth = (oSource.width && oSource.width !== ""? " width=\"" + oSource.width + "\"": "");
			return (imgSrc !== ""? "<img" + imgSrc + imgAlt + imgHeight + imgWidth + " ></img>": "");
		},
		// Generic link 
		createLink: function (oSource) {
			// oSource can only be an object!
			var src = oSource || {}, name = src.name || "", href = src.href || "";
			return (href !== "" && name !== ""? "<a href=\"" + href + "\">" + name + "</a>": name);
		}
	}
};

// PROCEDURE: Headernav Consumer Catalog
_page.html_helper.topnav.consumerCatalog = function () {
	var html = '', oGroups = [], animSlide, elContent, elNavs, elBlocks = [], helper = _page.html_helper.topnav, selUid, country, language, builtBlocks = {},
		defaultIndex = 0,
		activeIndex = -1,
		maxGroups = 8, 
		maxItemsPerColumn = 5,
		maxColumns = 2,
		needsPNGFix = /MSIE (5\.5|6)/.test(navigator.userAgent),
		imgStyleKey = needsPNGFix ?"filter" :"background",
		// Returns the number of allowed columns based on id
		getMaxColumnsById = function (id) {
			return /ACCESSORIES/i.test(id || "")? 3: maxColumns;
		},
		// Returns group index number based on group or cat id
		getGroupIndexById = function (id) {
			id = id || "";
			if (id !== "") {
				var i, z, oCategories,
					reg = new RegExp(id, 'i');
				for (i = 0; i < oGroups.length; i += 1) {
					if (reg.test((oGroups[i].uid || ""))) {
						return i;
					}
					oCategories = oGroups[i].categories || [];
					for (z = 0; z < oCategories.length; z += 1) {
						if (reg.test((oCategories[z].uid || ""))) {
							return i;
						}
					}
				}
			}
		},
		// Returns banner by defined size
		getBannersBySize = function (aBannerItems, selIndex) {	
			var i, aTmp = [];
			for (i = 0; i < aBannerItems.length; i += 1) {
				if (selIndex === (parseInt(aBannerItems[i].size, 10) || 0)) {
					aTmp.push(aBannerItems[i]);
				}
			}
			return aTmp;
		},
		// Omniture tracking
		omniTrack = function () {
			var productGroup = (selUid.match(/(.*)_gr/i) || [])[1] || "";
			if (_page.metrics && _page.metrics.trackAjax && productGroup !== "") {
				window.setTimeout(function () {
					_page.metrics.trackAjax({
						"division": "CP",
						"section": "main",
						"country": country,
						"language": language,
						"catalogtype": "consumer",
						"productgroup": productGroup,
						"productcategory": "",
						"productsubcategory": "",
						"productid": ""
					});
				}, 200);
			}
		},
		// Build group catalog
		buildGroupCatalog = function (index) {
			index = index || 0;
			var allowedCols, oCategories, elBlock, columnsCount, bannerSize, oBanner, firstBanner, elImage, elCol, z, availableBanners,
				oGroup = oGroup || oGroups[index];
			if (!oGroup || builtBlocks[index]) {
				return;
			}
			allowedCols = getMaxColumnsById(oGroup.uid);
			oCategories = oGroup.categories || [];
			elBlock = gE("p-cl-block-" + index);
			// Build category
			columnsCount = 0;
			for (z = 0; z < oCategories.length; z += maxItemsPerColumn) {				
				oGroup.max = z + maxItemsPerColumn;
				columnsCount += 1;
				elCol = document.createElement("div");	// Additional div wrapper is necessary for IE 5.5 list item width/indent bug
				elCol.className = "p-column";
				elBlock.appendChild(elCol);
				helper.buildList(elCol, oGroup, "cat2", false);
				if (columnsCount === allowedCols) {
					break;
				}
			}
			// Increase column size for country block 
			if (oGroup.country_specific && oGroup.country_specific.categories) {
				columnsCount += 1;
			}
			// Build banners HTML
			bannerSize = 4 - columnsCount;
			availableBanners = getBannersBySize(oGroup.banners, bannerSize);
			oBanner = availableBanners[Math.floor(Math.random() * availableBanners.length)];
			if (oBanner) {
				elImage = document.createElement("div");
				applyStyle(elImage, "p-image p-size-" + bannerSize);
				elImage.innerHTML += helper.createLink({ // Additional div image wrapper necessary for IE 5.5 float / margin bug 
					"name": helper.createImage({"src": oBanner.src, "alt": oBanner.alt}),
					"href": oBanner.href
				});
				elBlock.appendChild(elImage);
				columnsCount += 1;
			}
			// Build specific country block (always last block)
			if (oGroup.country_specific) {
				elCol = document.createElement("div");
				elCol.className = "p-column";
				elCol.appendChild(helper.createHeader('h4', oGroup.country_specific));
				helper.buildList(elCol, oGroup.country_specific, "sitespecific", false); // link
				elBlock.appendChild(elCol);
			}
			// Make sure block is always rendered
			if (columnsCount === 0) {
				elBlock.innerHTML += "&nbsp;";
			}
			builtBlocks[index] = true;
		},
		// Build all group's catalog
		buildAllGroupCatalog = function () {
			for (var i = 0; i < maxGroups; i += 1) {
				buildGroupCatalog(i);
			}
		},
		// Set group image
		setGroupImage = function (el, type) {
			if (el) {
				var index, path, styleValue;
				type = type || "";
				if (type !== "Hover" && /p-active/i.test(getStyle(el))) {
					return;
				}
				index = el.id.split("-")[3] || -1; 
				path = (oGroups && oGroups[index] && oGroups[index]["src" + type]? oGroups[index]["src" + type]: "");				
				styleValue = needsPNGFix ?"progid:DXImageTransform.Microsoft.AlphaImageLoader (src='" + path + "',sizingMethod='crop')": "url(" + path + ") no-repeat";
				el.style[imgStyleKey] = styleValue;
			}
		},
		// Select group private function
		selectGroup = function (params) {
			params = params || {};
			var i, curLeft, newLeft, elBlock, elNav,
				selIndex = params.index || getGroupIndexById(params.uid) || activeIndex,
				animate = typeof params.animate !== "undefined"? params.animate: true;
			selIndex = selIndex >= maxGroups? maxGroups - 1: (selIndex < 0? 0: selIndex);
			selUid = params.uid || oGroups[selIndex].uid || "";
			if (selIndex !== activeIndex) {
				activeIndex = activeIndex === -1? defaultIndex: activeIndex;
				buildGroupCatalog(selIndex);
				if (animSlide && animSlide.running) {
					animSlide.stop();	
				}
				for (i = 0; i < maxGroups; i += 1) {
					elNav = elNavs[i];
					if (elNav) {
						if (i === (selIndex - 1)) {
							applyStyle(elNav, "p-active");
							setGroupImage(elNav, "Hover");
						} else {
							applyStyle(elNav, "");
							setGroupImage(elNav);
						}
					}
					elBlock = elBlocks[i] = (elBlocks[i] || gE("p-cl-block-" + i));
					if (elBlock) {
						elBlock.style.display = (i === selIndex || i === activeIndex? "block": "none");
					}
				}
				if (selIndex > activeIndex) { 	// Right
					curLeft = 0;
					newLeft = -940; 
				} else { 					// Left
					curLeft = -940;
					newLeft = 0;
				}
				elContent = elContent || gE('p-cl-content');
				if (animate) {
					animSlide = new _page.animationMgr(elContent, {duration: 800, transition: _page.transition.expo.easeOut});	
					animSlide.start({'left': [curLeft, newLeft]});
				} else {
					sX(elContent, newLeft);
				}
				activeIndex = selIndex;
				omniTrack();
			}
		},
		// Mouse click
		mouseClick = function (index, event) {
			_page.Events.cancel(event);
			selectGroup({index: index});
		},
		// Preload image
		preloadImage = function (src) {
			src = src || "";
			if (document.images && src !== "") {
				var img = new Image();
				img.src = src;
			}
		};

	// Public functions
	return {
		init: function (params) {
			params = params || {};
			var oGroup, elNav, elList, i, selIndex,
				oSource = params.source || {},
				oTarget = params.elParent;
			// Set globals	
			oGroups = oSource.groups;
			selIndex = getGroupIndexById(params.activeItem) || defaultIndex;
			country = params.country;
			language = params.language;
			// Build navigation HTML 
			html += "<div id=\"p-cl-wrapper\">\n";
			html += "<div id=\"p-cl-nav-wrapper\">\n";
			html += "	<ul id=\"p-cl-nav\">\n";
			for (i = 1; i < maxGroups; i += 1) {
				oGroup = oGroups[i];
				if (oGroup) {
					html += "			<li><a href=\"javascript:void(0)\">" + oGroup.name + "</a></li>\n";
				} 
			}
			html += "	</ul>\n";
			html += "</div>\n";
			html += "<div id=\"p-cl-content-wrapper\">\n";
			html += "	<div id=\"p-cl-content\">\n";
			for (i = 0; i < maxGroups; i += 1) {
				oGroup = oGroups[i];
				if (oGroup) {
					html += "			<div id=\"p-cl-block-" + i + "\" class=\"p-cl-block\"></div>\n";
				}
			}
			html += "	</div>\n";
			html += "</div>\n";
			html += "</div>\n";
			oTarget.innerHTML  = html;
			// Set backgrounds and hovers (transparency)
			elList = gE("p-cl-nav-wrapper");
			elNavs = elList.getElementsByTagName("li");
			for (i = 0; i < elNavs.length; i += 1) {
				elNav = elNavs[i];
				elNav.id = "p-cl-nav-" + (i + 1);
				preloadImage(oGroups[i + 1].src || ""); 	 // Preload group image hovers
				preloadImage(oGroups[i + 1].srcHover || ""); // Preload group image
				_page.Events.add(elNav, "mouseover", setGroupImage.bindArgs(null, [elNav, "Hover"]));
				_page.Events.add(elNav, "mouseout", setGroupImage.bindArgs(null, [elNav]));
				_page.Events.add(elNav.firstChild, "click", mouseClick.bindArgs(null, [i + 1], true));
			}
			// Build group catalogs
			buildAllGroupCatalog();
			// Set default active
			selectGroup({index: selIndex, animate: false});
			return this;
		},
		selectGroup: function (id) {
			selectGroup({uid: id});
		}
	};
};

/* CLASS: ANIMATION  MANAGER */
_page.animationMgr = function (obj,params) {
	this.initialize(obj,params);
};
_page.animationMgr.prototype = {
	// Initialize object
	initialize: function (obj,params) {
		this.options = params;
		this.options.fps = parseInt(this.options.fps || 50);
		this.options.duration = parseInt(this.options.duration || 0);
		this.elNode = obj;
		this.running = false;
	},
	// Start animation
	start: function (obj) {
		this.running = true;
		this.onStart();
		for (var id in obj)
			this.style = id;this.from = obj[id][0];this.to = obj[id][1]; 
		this.change = this.to-this.from,this.now = this.from;
		this.timeStart = _page.getTime();
		this.set(this.from);
		this.timer = window.setInterval(this.tween.bindArgs(this), Math.round(1000 / this.options.fps));
	},
	// Actual tweening
	tween: function () {
		var time = _page.getTime();
		if (time < this.timeStart + this.options.duration){
			this.now = Math.round(this.options.transition.apply(this, [time - this.timeStart, this.from, this.change, this.options.duration]) * 100) / 100;
			this.set(this.now);
		} else {
			this.set(this.to);
			this.stop();
			this.onComplete();
		}
	},
	// Set the dimensions of the style
	set: function (value, obj) {
		obj = obj || this.elNode;
		switch (this.style) {
		case "height": case "left": case "right":
		  obj.style[this.style] = value + 'px';
		  break;    
		case "opacity":
		  _page.setOpacity(obj, value);
		  break;
		default:
		  obj.style[this.style] = value;
		}
	},
	// Stop animation
	stop: function () {
		window.clearInterval(this.timer);
		this.running = false;
		this.elNode = null;
	},
	// Function to call when the animation is ready
	onComplete: function () {
		if (this.options.onComplete)
			_page.startEvent(this.options, 'onComplete');
	},
	// Function to call when the animation starts
	onStart: function () {
		if (this.options.onStart)
			_page.startEvent(this.options, 'onStart');
	}
};

/* 	CLASS : TRANSITION
	- Credits: Easing Equations by Robert Penner, <http://www.robertpenner.com/easing/>.
*/
_page.transition = {
	bounce: {
		easeOut: function (t, b, c, d) {
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		},
		easeIn: function (t, b, c, d) {
			return c - _page.transition.bounce.easeOut (d-t, 0, c, d) + b;
		},
		easeInOut: function (t, b, c, d) {
			if (t < d/2) return _page.transition.bounce.easeIn (t*2, 0, c, d) * .5 + b;
			else return _page.transition.bounce.easeOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
	},
	expo: {
		easeIn: function (t, b, c, d) {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
		},
		easeOut: function (t, b, c, d) {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		},
		easeInOut: function (t, b, c, d) {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
	},
	linear: function (t,b,c,d) {
		return c*t/d + b;
	}
};

// Set opacity on an element 
_page.setOpacity = function (obj, opacity){
	if (opacity === 0){
		if (obj.style.visibility !== "hidden") obj.style.visibility = "hidden";
	} else {
		if (obj.style.visibility !== "visible") obj.style.visibility = "visible";
	}
	if (!obj.currentStyle || !obj.currentStyle.hasLayout) obj.style.zoom = 1;
	if (_page.browser.isIE) {
		if (opacity === 1) {
			try {obj.style.cssText = obj.style.cssText.replace(/filter:[^;]*;/i, "")} catch (e) {obj.style.filter=''};				
		} else {
			obj.style.filter = "alpha(opacity=" + opacity * 100 + ")";	
		}	
	}
	obj.style.opacity = opacity;
};

// Return the current time in seconds
_page.getTime = function () { return(new Date().getTime()); };

// Return the site level based upon locale
_page.getSiteLevelByLocale = function (locale) {
	var country = locale.split("_")[0];
	for (level in _page.siteLevelList)
		if (hasElement(_page.siteLevelList[level], country)) {
			return level;
		}
	return ""
};

// Returns meta element by name
_page.getMetaElementByName = function () {
	var meta;
	return function (name, force) {
		var el, i, metatags;
		if (typeof meta === "undefined" || force) {
			meta = {};
			metatags = document.getElementsByTagName("meta");
			for (i = 0; i < metatags.length; i += 1) {
				el = metatags[i];				
				meta[el.name.toLowerCase()] = el || "";
			}
		}
		return meta[name.toLowerCase()] || {};
	}	
}();

// GLOBAL FUNCTIONS
_page.startEvent = function (obj, type, args){
	args = (!args? arguments: args);
	if (typeof obj[type] === "function"){
		obj[type].apply(obj, args);
	}
};

// Function which accepts functions to be run when dom is ready
_page.onContentReady = function(f) { //(C)webreflection.blogspot.com
	var a,b=navigator.userAgent,d=document,w=window,
	c="__onContent__",e="addEventListener",o="opera",r="readyState",
	s="<scr".concat("ipt defer src='//:' on",r,"change='if(this.",r,"==\"complete\"){this.parentNode.removeChild(this);",c,"()}'></scr","ipt>");
	w[c]=(function(o){return function(){w[c]=function(){};for(a=arguments.callee;!a.done;a.done=1)f(o?o():o)}})(w[c]);
	if(d[e])d[e]("DOMContentLoaded",w[c],false);
	if(/WebKit|Khtml/i.test(b)||(w[o]&&(w[o].version?parseInt(w[o].version())<9:true))) // Applied change to support version number opera
	(function(){/loaded|complete/.test(d[r])?w[c]():setTimeout(arguments.callee,1)})();
	else if(/MSIE/i.test(b) && !_page.browser.isMac){d.write(s);} // disabled for IE mac, doesn't seem to respond
	else{addOnLoadEvent(w[c])}
};

// Function to load JS file on the fly
_page.loadJSFile = function (src, test, callback , charset) {
	var js = null, loadTimeout, done, timeStart, charSetType, isTimeout, complete, load;
	loadTimeout = 10000; //10 secs, only applicable for Safari / Opera < 9
	done = false;
	timeStart = new Date().getTime();
	charSetType = (charset)?charset:null;
	isTimeout = function () {
		var timeCur = new Date().getTime();
		return parseInt(timeCur) - parseInt(timeStart) > loadTimeout; 
	};
	complete = function () {
		if (!done) {
			done = true;
			callback();
			if (js) {
				js.parentNode.removeChild(js);
				js = null;
			}				
		}
	};
	load = (function () {
		var head, call;
		js = document.createElement('script');
		js.src = src;
		js.type = "text/javascript";
		if (charSetType) js.charset = charSetType;
		head = document.getElementsByTagName('head')[0];
		head.appendChild(js);
		js.onload = js.onreadystatechange = function () {
			if (!this.readyState || /loaded|complete/.test(this.readyState)) {
				complete();
			}
		};
		if (/WebKit|Khtml/i.test(navigator.userAgent)||(window.opera && (window.opera.version? parseInt(window.opera.version()) <= 9: true))) {
			(function() {
				call = false;
				try {call = test.call();} catch (e) {}
				if (call) {
					complete();
				} else {
					if (!isTimeout())
						setTimeout(arguments.callee, 100);
				}
			})();
		}		
	});
	window.setTimeout(load, 100) // Need timeout for IE
};

// CLASS: Search As You Type
_page.Sayt = function(queryId, suggestId, params) {
	this.options = params || {};
	this.id = suggestId;
	this.qid = queryId;
	this.options.minLetters = (typeof params.minLetters !== "undefined"? params.minLetters: 2);
	this.options.numberResults = (typeof params.numberResults !== "undefined"? params.numberResults: 10);
	this.suggestAjaxRequestOngoing = false;
	this.suggestVisible = false;
	this.selectedSuggestionItem = -1;
	this.lastQuery = "";
	this.init();
};
_page.Sayt.prototype = {
	evtClick: null,
	init: function (id, params) {		
		_page.onContentReady(this.initEvents.bindArgs(this));
	},
	initEvents: function () {
		gE(this.qid).setAttribute("autocomplete", "off");
		gE(this.id).className = "p-suggest-wrapper";
		_page.Events.add(gE(this.qid), 'keydown', this.suggestHandler.bindArgs(this));
		_page.Events.add(gE(this.qid), 'keyup', this.suggestHandler.bindArgs(this));
		_page.Events.add(gE(this.id), 'mouseover', this.suggestHandler.bindArgs(this));
		_page.Events.add(gE(this.id), 'click', this.suggestHandler.bindArgs(this));
	},
	documentClick: function () {
		this.lastQuery = "";
		this.hideSuggestDiv();
		_page.Events.removeSafe(evtClick);
	},
	suggestHandler: function (e) {
		var elTarget ,elRow, activeId;
		switch (e.type) {
		case "mouseover":
			elTarget = _page.Events.getTarget(e);
			if (elTarget.nodeName.toLowerCase() === "a"){
				elRow = elTarget.parentNode.parentNode;
				activeId = elRow.id.substring(elRow.id.lastIndexOf("-") + 1, elRow.id.length);
				this.setSuggestOver(activeId);
			}
			break;
		case "click":
			this.setSearch(this.selectedSuggestionItem);
			_page.Events.cancel(e); // don't bubble up to document.click
			break;
		case "keyup":
			if (e.keyCode !== 40 &&  e.keyCode !== 38 && e.keyCode !== 13)
				this.searchSuggest(this.options.section);
			break;
		case "keydown":
			if (this.suggestVisible === true) {
				if (e.keyCode === 38) {
					this.setSuggestOver(parseInt(this.selectedSuggestionItem) - 1);
					_page.Events.cancel(e);
				} else if (e.keyCode === 40) {
					this.setSuggestOver(parseInt(this.selectedSuggestionItem) + 1);
					_page.Events.cancel(e);
				}	
			}
			if (e.keyCode === 13) {
				this.setSearch(this.selectedSuggestionItem);
			}
		}
	},
	requestCompleted: function () {
		this.updateSuggestDiv();
		this.suggestAjaxRequestOngoing = false;
	},
	searchSuggest: function (section) {
		var userQuery, remoteUrl;
		if (!this.suggestAjaxRequestOngoing) {
			userQuery = gE(this.qid).value;
			if (userQuery.length >= this.options.minLetters && this.lastQuery != userQuery) {
				this.lastQuery = userQuery;	// Save the last query so that we do not have to search again
				this.suggestAjaxRequestOngoing = true;	
				this.selectedSuggestionItem = -1;
				remoteUrl = this.options.remoteUrl + "?query=" + this.lastQuery + "&locale=" + this.options.locale + "&section=" + this.options.section+"&numres=" + this.options.numberResults;
				delete _page.headerSayT.results; // delete and only trigger oncomplete function when available for Safari
				_page.loadJSFile(remoteUrl, function (){ return(_page.headerSayT.results);}, this.requestCompleted.bindArgs(this), "utf-8");
			}
		}
	},
	updateSuggestDiv: function () {
		var i, ss = gE(this.id), suggest = '', suggestions = _page.headerSayT.results || [];
		ss.innerHTML = '';
		this.hideSuggestDiv();
		if (suggestions.length > 0) {
			suggest += '<table id="' + this.id + '-table" class="p-suggest" cellspacing="0" >';
			for(i = 0; i < suggestions.length; i += 1) {
				suggest += '<tr id="' + this.id + '-row-' + i + '" class="p-suggest-link"><td class="p-suggest-value"><a id="' + this.id + '-value-' + i + '" href="javascript:void(0)">' + suggestions[i].query + '</a></td><td class="p-suggest-hits"><a id="' + this.id + '-info-' + i + '" href="javascript:void(0)">' + (suggestions[i].info || '&nbsp;') + '</a></td></tr>\n';
			}
			suggest += '</table>\n';
			ss.innerHTML = suggest;
			this.showSuggestDiv();
		}
	},
	hideSuggestDiv: function () {
		gE(this.id).style.display = 'none';
		this.suggestVisible = false;
	},
	showSuggestDiv: function () {
		evtClick = _page.Events.add(document, 'click', this.documentClick.bindArgs(this));
		gE(this.id).style.display = 'block';
		this.suggestVisible = true;
	},
	setSuggestOut: function (v) {
		applyStyle(gE(this.id + '-row-' + v),'p-suggest-link');
	},
	setSuggestOver: function (v) {
		if (this.selectedSuggestionItem !== v) this.setSuggestOut(this.selectedSuggestionItem);
		this.selectedSuggestionItem = v = (v <= -1 || v > this.options.numberResults - 1? (v <= -1? this.options.numberResults - 1: 0): v);
		applyStyle(gE(this.id + '-row-' + v), 'p-suggest-link-over');
	},
	setSearch: function (v) {
		var elValue = gE(this.id + '-value-' + v);
		if (elValue) {
			gE(this.qid).value = elValue.innerHTML;
		}	
		this.hideSuggestDiv();
		this.doSubmit();
	},
	doSubmit: function () {
		this.options.doSubmit();
	}
};

/*
***********************************
****** Generate Left menu  ********
***********************************
*/
_page.nav = (function () {
	// GLOBALS
	var options = {},
		activeId = activeId || _page.leftNavItem || "",
		items = _page.leftNav,	// Hashtable / object, holds the left nav items
		itemsSorted = [],		// Sorted array, used for sorted looping through leftnav items
		maxItemLevels = 7,		// Max number of levels in the left menu, excluding flyouts
		maxMenuLevels = 6,		// Max number of levels in the left menu, including flyouts, only applicable for hierarchy flyouts
		htmlNav = {},
	
		// Clone an object
		CloneObject = function (what) {
			for (var i in what) {
				if (typeof what[i] === 'object') {
					this[i] = new CloneObject(what[i]);
				} else {
					this[i] = what[i];
				}	
			}
		},

		// Returns the item level of the given item
		getItemLevel = function (itemId) {
			itemId = itemId || "";
			return itemId.split("_").length;
		},
	
		// Check if the given item inherits the showall attribute
		inheritsShowall = function (item) {
			if (item.level > 1 && items[item.parentid].showAll && items[item.parentid].active) {
				return true;
			} else if (item.level > 2 && (item.level < getItemLevel(activeId) + 1) && items[item.parentid].active) {
				return inheritsShowall(items[item.parentid]);
			} else { 
				return false;
			} 	
		},

		// Check if the given item is the sibling of the active item
		isSibling = function (item) {
			if (activeId === "") {
				// No selection
				return false;
			} else {
				// Check if current item and active item have the same parent
				if (item.level > 1) {
					if (item.parentid === items[activeId].parentid) {
						return true;
					} else {
						return false;
					}
				} else {
					// Top level item
					return false;
				}
			}
		},

		// This function searches for visible siblings of the item by looking up items with the same parent
		hasVisibleSiblings = function (item) {
			var i, tmpItem, isVisible = false;
			for (i = (itemsSorted.length - 1); i >= 0; i -= 1) {
				tmpItem = itemsSorted[i];
				if (tmpItem.level > 1 && tmpItem.parentid === item.parentid && tmpItem.id !== item.id && !tmpItem.hideLink && !tmpItem.showCategory) {
					isVisible = true;
					break;
				}
			}
			return isVisible;
		},
		
		// Process the items in the global items array
		itemUpdate = function () {
			var item, itemId, disableLink, hideChilds, showAll, hideLink, showCategory, hideFlyout, itemOptions = [], option = "", x, i,
				selId, activeItemLevel;
			selId = activeId;	
			activeItemLevel = getItemLevel(activeId);
			// Set active for all active and parent items			
			for (i = 0; i < activeItemLevel; i += 1) {
				item = items[selId];
				if (item) {
					item.active = true;
				}
				selId = selId.substr(0, selId.lastIndexOf("_"));	// Remove last two characters from string (one level less)
			}
			for (x = 0; x < itemsSorted.length; x += 1) {
				item = itemsSorted[x];
				itemId = item.id;
				item.level = getItemLevel(itemId);
				item.active = (item.active? item.active: false);
				// Get extra options if option-string is not empty
				if (item.options !== "" && typeof item.options !== "undefined") {
					// Initial / default option values
					hideFlyout = false;
					disableLink = false;
					hideChilds = false;
					showAll = false;
					hideLink = false;
					showCategory = false;
					// First, split option-string in seperate options
					itemOptions = item.options.split(",");
					// Check for options
					for (i = 0; i < itemOptions.length; i += 1) {
						option = itemOptions[i];
						if (option.indexOf("flyout=no") === 0) {
							// Don't show flyout
							hideFlyout = true;
						} else if (option.indexOf("link=no") === 0) {
							//Don't show links
							disableLink = true;
						} else if (option.indexOf("hidechilds=yes") === 0) {
							// Don't show childs directly, only as flyout
							hideChilds = true;
						} else if (option.indexOf("showall=yes") === 0) {
							// Show all childs
							showAll = true;					
						} else if (option.indexOf("hidelink=yes") === 0) {
							// Hide this link
							hideLink = true;
						} else if (option.indexOf("category=yes") === 0) {
							// Hide this link
							showCategory = true;					
						}
						// Update status of hideChilds
						item.hideChilds = hideChilds;
						// Update status of showAll
						item.showAll = showAll;
						// Update status of hideLink
						item.hideLink = hideLink;
						// Update status of showCategory, only shown at level 1
						item.showCategory = showCategory;
						// Update status of link should be shown of item
						if (disableLink) {
							item.showLink = false;
						}
						// Update flyout status of item
						item.hideFlyout = hideFlyout;
					}
				} 
				// If not a top-item:
				// - add the ID of the parent item
				// - set the parent to have children, only if at least 1 child is visible
				if (item.level > 1) {
					item.parentid = itemId.substr(0, itemId.lastIndexOf("_"));
					if ((item.showCategory || item.hideLink) && !hasVisibleSiblings(item)) {
						items[item.parentid].children = false;
					} else {
						items[item.parentid].children = true;
					}
				}
				// Set default flyout visibility
				if (item.hideFlyout) {
					item.flyout = false;
				} else {
					if (item.level < maxMenuLevels) {
						// Only flyout on levels < 'maxMenuLevels'
						item.flyout = true;
					} else {
						// Level >= 'maxMenuLevels'
						item.flyout = false;
					}
				}
				// Check if current flyout is allowed to be rendered
				if (item.active) {
					// No flyout allowed for active item at level 1-4 (show children first)
					if (!options.showHierarchyFlyouts && item.level < maxItemLevels) {
						item.flyout = false;
					}
					// Don't show flyout for active item
					if (options.showHierarchyFlyouts && (item.level === items[activeId].level))  {
						item.flyout = false;
					}
				} else if (item.level > 1) {
					if (options.showHierarchyFlyouts) {
						if (item.parentid === activeId && !items[item.parentid].hideChilds) { 
							item.flyout = false; 	// Don't show flyout when active item it's childs are shown
						}
					} else {
						if (items[item.parentid].flyout || item.parentid === activeId) {
							// Parent has flyout or is active, flyout possible
							if (item.level > 2 && items[items[item.parentid].parentid].flyout) {
								item.flyout = false; 	// Grandparent already has flyout, flyout not allowed - Maximize flyout level to 2
							} else if (item.flyout) {
								// Parent has flyout or is active --> flyout is allowed
							}
						} else {
							item.flyout = false;
						}
					}	
				} else if (item.level === 1) {
					// do nothing
				} else {
					item.flyout = false;
				}
				// If childs of active item are hidden in leftmenu, force flyout
				if (activeId === itemId && item.active && item.hideChilds && !item.hideFlyout) {
					item.flyout = true;
				}
				// If item inherits a showall-property, all child are shown in leftmenu --> no flyout
				if (inheritsShowall(item)) {
					item.flyout = false;
				}
				// When item is not active and doesn't have a link and don't is disabled by the user, show flyout
				if (!item.showLink && !item.hideFlyout && !item.active) {
					item.flyout = true;
				}
				if (item.flyout) {
					item.flyoutLevel = -1;
				}
			}
		},
		
		// Creates hierarchy flyouts (optional)
		createHierarchyFlyouts = function () {
			var itemId, i, curId, objNav, item,
				itemLength = itemsSorted.length,
				hierStartLevel = 1000,
				hierMainId = "",
				hierId = "",
				firstLevelId = activeId.split("_")[0],
				replaceFirstLevelNumber = function (source, number) {
					return (source || "").replace(/^(\d+)/, (number || ""));
				};

			if (activeId !== "" && items[activeId] && items[activeId].level > 1) {
				curId = items[activeId].parentid;
				while (items[curId]) {
					for (i = 0; i < itemLength; i += 1) {
						item = itemsSorted[i];
						itemId = item.id;
						if (itemId.indexOf(firstLevelId) === 0) {
							// Duplicate node
							hierId = replaceFirstLevelNumber(itemId, hierStartLevel);
							objNav = new CloneObject(item);
							objNav.id = hierId;
							objNav.isHier = true;
							objNav.parentid = replaceFirstLevelNumber(objNav.parentid, hierStartLevel);
							// Always show the flyouts unless the user has defined not showing it
							if (item.level < maxMenuLevels && !item.hideFlyout) {
								objNav.flyout = true;
							}
							delete objNav.hierId;
							items[hierId] = objNav;
							itemsSorted[itemsSorted.length] = objNav;
						}
					}
					hierMainId = replaceFirstLevelNumber(curId, hierStartLevel);
					items[curId].hierId = hierMainId;		// set hier id
					items[hierMainId].wrapperId = curId; 	// set wrapper id 
					curId = items[curId].parentid;
					hierStartLevel += 1;
				}
			}
		},
		
		// Sort left nav helper
		itemSortLeftNav = function (arg1, arg2) {
			var arg1IDs = arg1.ids, arg2IDs = arg2.ids, minLength, i;
			minLength = (arg1IDs.length <= arg2IDs.length ? arg1IDs.length : arg2IDs.length);
			for (i = 0; i < minLength; i += 1) {
				if (parseInt(arg1IDs[i], 10) < parseInt(arg2IDs[i], 10)) { 
					return -1;
				}
				if (parseInt(arg1IDs[i], 10) > parseInt(arg2IDs[i], 10)) {
					return 1;
				}
			}
			if (arg1IDs.length < arg2IDs.length) {
				return -1;
			}
			if (arg1IDs.length > arg2IDs.length) { 
				return 1;
			}
			return 0;
		},
		
		// Sorts the leftnavigation menu based on level id's
		itemSort = function () {
			var length = 0, i, id, item, itemSorted;
			itemsSorted = []; // Global array to sort left menu items
			for (id in items) {
				item = items[id];
				if (item.text) {
					item.id = id;
					item.ids = id.split("_");
					itemsSorted[length] = item;
					length += 1;
				}
			}
			itemsSorted.sort(itemSortLeftNav);
			items = [length];
			for (i = 0; i < length; i += 1) {
				itemSorted = itemsSorted[i];
				items[itemSorted.id] = itemSorted;
			}
		},
		
		// Puts the HTML in the document for the level 1 flyouts
		flyoutHtml = function (navLevels) {
			navLevels = navLevels || 1;
			var elWrapper = gE("flyoutitems"), html = "", itemId;
			if (elWrapper) {
				for (itemId in htmlNav) {
					if (items[itemId].flyoutLevel !== -1 && items[itemId].flyoutLevel <= navLevels) {
						html += htmlNav[itemId];
					}
				}
				elWrapper.innerHTML = html;
			}
		},
		
		// Append flyouts dynamically to the document
		flyoutAppend = function (itemId) {
			var elContainer,
				elWrapper = gE("flyoutitems"),
				html = htmlNav[itemId] || "";
			if (html !== "") {
				elContainer = document.createElement("div");
				elContainer.innerHTML = html;
				elWrapper.appendChild(elContainer);
			}
		},
		
		// This function generates all flyouts
		flyoutCreateAll = function () {
			var item, curLevel, html, aHtml, nolinkClass, iframeHtml, itemGrandParent, itemId, parentItemId, itemParent, flyoutClass;
			//Set flyout level and menu id
			for (itemId in items) {
				if (items[itemId].text) {
					item = items[itemId];
					curLevel = item.level;
					parentItemId = item.parentid;
					itemParent = items[parentItemId];
					// Check parent id for creation of flyout
					if (itemParent && itemParent.flyout && itemParent.children) {
						itemGrandParent = items[itemParent.parentid];
						if (itemGrandParent && itemGrandParent.flyoutLevel > -1) {
							itemParent.flyoutLevel = itemGrandParent.flyoutLevel + 1;
							itemParent.menuId = itemGrandParent.menuId;
						}
					}
				}
			} 				
			// Generate flyout html for all flyouts which are having a flyoutlevel higher then -1
			for (itemId in items) {
				if (items[itemId].text) {
					item = items[itemId];
					curLevel = item.level;
					parentItemId = item.parentid;
					itemParent = items[parentItemId];
					if (curLevel > 1) {
						aHtml = [];
						// Check parent id for creation of flyout
						if (itemParent && itemParent.flyout && itemParent.children && itemParent.flyoutLevel > -1) {
							// If it doesn't exist create it
							if (!htmlNav[parentItemId]) {
								htmlNav[parentItemId] = "";
								flyoutClass = (itemParent.flyoutLevel === 1? "p-flyoutdiv": "p-flyoutdiv-2");
								aHtml[aHtml.length] = "<div class=\"" + flyoutClass + "\" id=\"flyout_" + parentItemId + "\" onmouseover=\"_page.flyout_hide_cancel('" + parentItemId + "');\" onmouseout=\"_page.flyout_hide('" + parentItemId + "');\">";
								aHtml[aHtml.length] = "<table id=\"flyout_table_" + parentItemId + "\" class=\"p-table_flyout\" cellspacing=\"0\">";
								aHtml[aHtml.length] = "<tr>";
								aHtml[aHtml.length] = "<td class=\"p-flyout-left-first\"><div id=\"right_arrow_" + parentItemId + "\" class=\"p-right_arrow\">&nbsp;</div></td>";
								aHtml[aHtml.length] = "<td class=\"p-flyout-right\">"; 
								aHtml[aHtml.length] = "<table cellspacing=\"1\" width=\"100%\">"; 
							}
							// BODY ROW
							if (!item.showCategory && !item.hideLink) {
								aHtml[aHtml.length] = "<tr>";
								// Make sure no hand is shown when no link is available
								nolinkClass = (!item.showLink? " p-nolink": ""); 
								// Create item with or without flyout
								if (item.flyout && item.children) {
									aHtml[aHtml.length] = "<td	id='ln_itm_" + itemId + "' class=\"p-flyout-content-flyout" + nolinkClass + "\" onmouseover=\"_page.flyout('" + itemId + "');\" onmouseout=\"_page.flyout_hide('" + itemId + "')\">";
								} else {
									aHtml[aHtml.length] = "<td	id='ln_itm_" + itemId + "' class=\"p-flyout-content" + nolinkClass + "\">";
								}
								// Show item with/without link
								if (item.showLink) {
									aHtml[aHtml.length] = "<a class=\"p-flyout_link_" + itemParent.flyoutLevel + "\" id=\"left_level_link_" + itemId + "\" href=\"" + item.link + "\">" + item.text + "</a>"; // Let the text  break!!!
								} else {
									aHtml[aHtml.length] = "<span class=\"p-flyout_link_" + itemParent.flyoutLevel + "\">" + item.text + "</span>";	// Item without link
								}
								aHtml[aHtml.length] = "</td>";
								aHtml[aHtml.length] = "</tr>";
							}
							htmlNav[parentItemId] += aHtml.join('\n');
						}
					}
				}
			}
			// Close all open table HTML
			html = "</table>\n</td>\n</tr>\n</table>\n</div>\n\n";
			for (itemId in htmlNav) {
				if (htmlNav.hasOwnProperty(itemId)) {
					// If needed for browsertype, create IFRAME to solve select-problem
					iframeHtml = (useIframe? "<IFRAME frameborder=0 id=\"flyout-" + itemId + "-IF\" src=\"javascript:false;\" scroll=none style=\"FILTER:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0);visibility:hidden;height:0;position:absolute;width:0px;top:0px;z-index:0\"></iframe>": "");
					htmlNav[itemId] += html + iframeHtml;
				}
			}
		},

		// Cancel opening new flyout
		flyoutCancel = function (itemCurId) {
			clearTimeout(items[itemCurId].flyoutopenid);
			items[itemCurId].flyoutopenid = 0;
		},
		
		// Show flyout (timout)
		flyout = function (itemCurId, flyoutLevel) {
			var delay;
			// Cancel possibile hide-action on current_item
			_page.flyout_hide_cancel(itemCurId);
			// If flyout is not scheduled, schedule it
			if (items[itemCurId].flyoutopenid === 0) { 	
				delay = (_page.browser.isMac? 250: 100);
				items[itemCurId].flyoutopenid = setTimeout("_page.flyout2('" + itemCurId + "', " + flyoutLevel + ")", delay);
			}
		},

		// Show flyout
		flyout2 = function (itemCurId, flyoutLevel) { 
			var dd, obj, arrow, moveRight, moveUp, xPos, yPos, scrollPosTop, screenHeight, flyoutWidth, flyoutHeight, flyoutPosTop, flyoutPosBottom, flyoutHeightAvailable, i, objTopPosBottom, position, fframe, itemId, item, scrollPosBottom, elTable, elCells, elCell, yPosPrev, 
				prefixId = 'ln_itm_';
			flyoutLevel = flyoutLevel || items[itemCurId].flyoutLevel;
			// Lookup flyout item and set postion
			dd = gE("flyout_" + itemCurId);
			if (!dd) {
				flyoutAppend(itemCurId);
				dd = gE("flyout_" + itemCurId);
			}
			// Hide all flyouts
			for (itemId in items) {
				if (items[itemId].text) {
					// Check if flyout is available and this is not the current item
					item = items[itemId];
					if (item.flyout && item.children && itemCurId !== itemId && item.flyoutOpen) {
						// Don't close parent
						if (itemCurId.indexOf(itemId) !== 0) {
							_page.flyout_hide2(itemId);
						}
					}
				}
			}
			obj = gE(prefixId + (items[itemCurId].wrapperId || itemCurId));
			arrow = gE("right_arrow_" + itemCurId);
			if (flyoutLevel === 1) {
				if (_page.direction === "rtl") {
					moveRight = -141;
				} else {
					moveRight = 170; 	
				}			
				moveUp = 21; //21
			} else {
				if (_page.direction === "rtl") {
					moveRight = -141;
				} else {
					moveRight = 126;
				}	
				moveUp = 21;
			}
			// Flyout x and y positions
			xPos = getLeftPos(obj) + moveRight;
			yPos = getTopPosBottom(obj) - moveUp;
			// Get browser dimensions		
			scrollPosTop = getScrollPosTop();  				 // Positon top in scrolled browser window
			screenHeight = getScreenHeight();				// Available height browser window
			scrollPosBottom = scrollPosTop + screenHeight;	// Positon bottom in scrolled browser window	
			// Flyout dimensions
			flyoutWidth = dd.offsetWidth;					// Flyout width
			flyoutHeight = dd.offsetHeight;					// Flyout height
			flyoutPosTop = findPosY(obj); 					// Top position of flyout
			flyoutPosBottom = flyoutPosTop + flyoutHeight; 	// Bottom position of flyout
			// Adjust positioning from top or bottom
			flyoutHeightAvailable = scrollPosBottom - flyoutPosBottom;
			if (flyoutHeightAvailable < 0) { 
				elTable = gE("flyout_table_" + itemCurId);
				elCells = elTable.getElementsByTagName("td");
				i = 2; // Start at the third!
				elCell = elCells[i];
				objTopPosBottom = getTopPosBottom(obj);
				while (elCell) {
					// Calculate positions
					flyoutPosBottom -= (elCell.offsetHeight + 1);
					yPos = flyoutPosBottom - flyoutHeight; 
					// Statements to set the position
					if (flyoutPosBottom < objTopPosBottom) {
						yPos += (objTopPosBottom - flyoutPosBottom + 1);
						break;
					} else if (yPos < scrollPosTop) {
						yPos = yPosPrev;
						break;
					} else if (flyoutPosBottom < scrollPosBottom) {
						break;
					}
					yPosPrev = yPos;
					i += 1;
					elCell = elCells[i];
				}			
			}
			// Position Arrow 
			moveUp = (flyoutLevel === 1? -1: -1);
			position = flyoutPosTop - yPos - moveUp;
			if (arrow) {
				sY(arrow, position);
			}	
			// Position Flyout and Iframe
			if (useIframe) {
				fframe = gE("flyout-" + itemCurId + "-IF");
				// Initiate iframe behind flyout
				sH(fframe, flyoutHeight);
				sW(fframe, flyoutWidth);
				sX(fframe, xPos);
				sY(fframe, yPos);
				sE(fframe);
			}		
			sX(dd, xPos);
			sY(dd, yPos);
			sE(dd);	
			if (arrow) {
				sE(arrow);
			}
			// Set open state
			items[itemCurId].flyoutOpen = true;
		},

		// Cancel  hiding of flyout
		flyoutHideCancel = function (itemCurId) {
			var item = items[itemCurId], itemParent;
			// Set highlight on left nav item
			if (item.flyoutLevel === 1) {
				itemMouseOver('ln_itm_'+item.menuId);
			} 
			clearTimeout(item.flyoutid);
			item.flyoutid = 0;
			// Clear timeout of parents (which prevents the actual hiding event)
			if (item.level > 1) {
				itemParent = items[item.parentid];
				while (itemParent && itemParent.flyout) {
					clearTimeout(itemParent.flyoutid);
					itemParent.flyoutid = 0;
					itemParent = items[itemParent.parentid];
				}
			}	
		},

		// Hide flyout (timout)
		flyoutHide = function (itemCurId) {
			var item = items[itemCurId], itemParent;
			// Cancel direct the opening of the flyout
			_page.flyout_cancel(itemCurId);
			// Set interval before removing flyout
			if (item.flyoutid === 0) {
				item.flyoutid = setTimeout("_page.flyout_hide2('" + itemCurId + "')", 100);
			}
			// When cur level is 2 or higher:  hide all parents with delay
			if (item.level > 1) {
				itemParent = items[item.parentid];
				while (itemParent && itemParent.flyout) {
					if (itemParent.flyoutid === 0) {
						itemParent.flyoutid = setTimeout("_page.flyout_hide2('" + itemParent.id + "')", 1000);
					}
					itemParent = items[itemParent.parentid];
				}
			}
		},

		// Hide flyout
		flyoutHide2 = function (itemCurId) {
			var fframe,
				item = items[itemCurId],
				dd = gE("flyout_" + itemCurId);
			// Remove highlight from left nav item
			if (item.flyoutLevel === 1) {
				itemMouseOut('ln_itm_'+item.menuId);
			}	
			if (dd) {
				hE(dd);
			} 	
			if (useIframe) {
				fframe = gE("flyout-" + itemCurId + "-IF");
				if (fframe) { 
					hE(fframe);
				} 
			}
			// reset id
			item.flyoutid = 0;
			item.flyoutOpen = false;
		},

		// Mouse over menu item
		itemMouseOver = function (el) {
			var strCurStyle, strStyle, strNewStyle;
			el = el || "";
			if (typeof el === "string") {
				el = gE(el);
			} 	
			if (el) {
				strStyle = getStyle(el);
				if (strStyle.indexOf("hier") === -1 && strStyle.indexOf("category") === -1 && strStyle.indexOf("p-left_hover") === -1) {
					strCurStyle = getStyle(el);
					strNewStyle = strCurStyle + " p-left_hover";
					applyStyle(el, strNewStyle);
				}
			}
		},
		
		// Mouse out menu item
		itemMouseOut = function (el) {
			var strStyle, strNewStyle;
			el = el || "";
			if (typeof el === "string") {
				el = gE(el);
			}	
			if (el) {
				strStyle = getStyle(el);
				if (strStyle.indexOf("p-left_hover") > -1) {
					strNewStyle = strStyle.substring(0, strStyle.indexOf(" "));
					applyStyle(el, strNewStyle);
				}
			}		
		},
		
		// Build navigation
		write2 = function (active, params) {
			activeId = active || _page.leftNavItem || activeId; // Set active item if given as function parameter
			options = params || options;
			options.showHierarchyFlyouts = options.showHierarchyFlyouts? options.showHierarchyFlyouts: false;
			var html, showTable, activeLevel, currentLevel, previousLevel, showItem, objLeftNav, z, item, itemId, cellClass, flyoutId, itemHier, 				showFlyout, isOpen, isActive, isOpenActive, isCategory;
			// Sort item array
			itemSort();
			// Update all items objects
			itemUpdate();
			// Create hierarchy flyouts (optional)
			if (options.showHierarchyFlyouts) {
				createHierarchyFlyouts();
			}
			// Don't build left nav table if no nav items present
			html = '';
			showTable = (itemsSorted.length > 0? true: false);
			if (showTable) {
				html +=  "<table id=\"p-table-left\" class=\"p-section-nav\" cellspacing=\"0\">\n";
				activeLevel = getItemLevel(activeId);
				currentLevel = 1;
				previousLevel = 0;
				for (z = 0; z < itemsSorted.length; z += 1) {
					item = itemsSorted[z];
					itemId = item.id;
					showItem = false;			
					currentLevel = item.level;	// Get level of current item
					// Check if item need to be shown
					// Only show if one of the following options is true:
					// Item is not hidden (hideLink)
					// - Item is level 1 item
					// - Item is active item
					// - Item is in currently opened menu
					if (item.hideLink) {
						// Never show Link if this value is true
						showItem = false;
					} else if (item.isHier) {
						// Never show item if it's duplicated content in hierarchy
						showItem = false;
					} else if (currentLevel === 1) { 
						showItem = true;	// First evel items are always visible
					} else if (currentLevel > 1 && 
									(item.active ||
									(activeId !== "" && items[item.parentid].id === activeId) || 
									inheritsShowall(item) ||
									(!options.showHierarchyFlyouts && isSibling(item)))) {
						// An item-level should be < maxItemLevels. No more levels are allowed on the left. A flyout is needed for the rest				
						if (items[item.parentid].hideChilds) {
							//Check if this item is still active. Don't hide then
							if (item.active) {
								showItem = true;
							} else {
								showItem = false;
							}
						} else if (currentLevel <= maxItemLevels) {
							showItem = true;
						}
					}
					
					if (showItem) {
						// Only show seperator when not the first item
						if (previousLevel !== 0 && previousLevel !== 1 && currentLevel === 1 ) {
							//Only show solid seperator when previous item is not a level 1 item
							html +=  "<tr><td><div class=\"p-solidsep\"> </div></td></tr>\n";
						}
						html +=  "	<tr>\n";
						// Get layout of this item
						itemHier = items[item.hierId] || item; // Get hierarchy duplicated item for display flyout options, or keep the original item
						showFlyout = (itemHier.flyout && itemHier.flyout && itemHier.children? true: false);
						isOpen = (item.active && item.children && (currentLevel < maxItemLevels)? true: false);
						isActive = (item.active && activeId === itemId? true: false);
						isOpenActive = (isActive && isOpen? true: false);
						isCategory = (item.showCategory? true: false);
						if (isCategory) {
							cellClass = "p-left_level_" + currentLevel + "_category";		// Category item
						} else if (isActive && showFlyout) {
							cellClass = "p-left_level_" + currentLevel + "_fly_active";		// Special item for flyout on active item on 'max_item_level'
						} else if (isOpen && showFlyout) {
							cellClass = "p-left_level_" + currentLevel + "_open_fly";		// Special item for flyout on active item with forced flyout - hierarchy
							cellClass += (currentLevel > 0? " p-hier" + (activeLevel - currentLevel): "");
						} else if (isOpenActive) {		
							cellClass = "p-left_level_" + currentLevel + "_open_active";
						} else if (isActive) {		
							cellClass = "p-left_level_" + currentLevel + "_active";
						} else if (isOpen) {
							cellClass = "p-left_level_" + currentLevel + "_open";			// Active item
							cellClass += (currentLevel > 0? " p-hier" + (activeLevel - currentLevel): "");
						} else if (showFlyout) {
							cellClass = "p-left_level_" + currentLevel + "_fly";			// Fly out item
						} else {
							cellClass = "p-left_level_" + currentLevel + "_closed";			// Inactive item
						}
						// Make sure no hand is shown when no links available
						if (!item.showLink) {
							cellClass += " p-nolink";
						}
						// Create item with or without mouseover for flyout 
						if (showFlyout) {
							flyoutId = itemHier.id;
							html += "		<td id='ln_itm_" + itemId + "' class=\"" + cellClass + "\" onmouseover=\"_page.flyout('" + flyoutId + "');_page.item_mouseover(this);\" onmouseout=\"_page.flyout_hide('" + flyoutId + "');_page.item_mouseout(this);\">";
							items[flyoutId].flyoutLevel = 1;
							items[flyoutId].menuId = itemId;
						} else {
							html += "		<td id='ln_itm_" + itemId + "' class=\"" + cellClass + "\" onmouseover=\"_page.item_mouseover(this);\" onmouseout=\"_page.item_mouseout(this);\">";
						}
						// If this item has a link, create it
						if (item.showLink && !item.showCategory) {
							html += "			<a class=\"p-left-level_link_" + currentLevel + "\" href=\"" + item.link + "\">";
							html += "			" + item.text + "</a>";		
						} else {
							html += "			<span class=\"p-left-level_link_" + currentLevel + "\">" + item.text + "</span>";		// Item without link
						}
						html += "		</td>\n";
						html += "	</tr>\n";
						previousLevel = currentLevel; // used to check if solid seperator is needed
					}
	
				}
				if (_page.sectionMain[0] && _page.sectionMain[1] && _page.sectionSpecial[0]) {
					html += "	<tr>\n";
					html += "		<td class=\"p-left_specialsection\" onmouseover=\"_page.item_mouseover(this);\" onmouseout=\"_page.item_mouseout(this);\"><a class=\"p-left-level_link_1\" href=\"" + _page.sectionMain[1] + "\">" + _page.sectionMain[0] + "</a></td>\n";
					html += "	</tr>\n";
				}
				html += "	<tr>\n";
				html += "		<td class=\"p-left-bottom\">&nbsp;</td>\n";
				html += "	</tr>\n";
				html += "</table>\n";
				html += "<div id=\"flyoutitems\"></div>\n";
				
			} else {
				html += "&nbsp;\n";
			}
			
			// Write left navigation to screen
			if (_page.leftNavOnload) {
				objLeftNav = gE("p-leftnav-container");
				if (objLeftNav) {
					objLeftNav.innerHTML = ''; // MAC IE compat.
					objLeftNav.innerHTML = html;
				}
			} else {
				// Write direclty
				_page.write(html, false);
			}
			flyoutCreateAll();
			flyoutHtml();
		},
	
		// Build navigation (helper / timout)
		write = function (active, params) {
			activeId = active || activeId;
			options = params || {};
			if (_page.leftNavOnload) {
				// register onload event
				document.write('<div id=\"p-leftnav-container\">&nbsp;</div>');
				setTimeout("_page.writeLeftNav2()", 50);
			} else {
				// build left nav immediately
				write2(activeId);
			}
		};
	
	// Make current private functions publicly available due to legacy and html registered events
	_page.item_mouseover = itemMouseOver;
	_page.item_mouseout = itemMouseOut;
	_page.flyout_cancel = flyoutCancel;
	_page.flyout = flyout;
	_page.flyout2 = flyout2;
	_page.flyout_hide2 = flyoutHide2;
	_page.flyout_hide = flyoutHide;
	_page.flyout_hide_cancel = flyoutHideCancel;
	_page.writeLeftNav = write;
	_page.writeLeftNav2 = write2;
	
	return function () {
		// Do nothing
	};
})();
	
_page.email = function(posturl) {
	try{var strURL = encodeURI(document.location);}catch(e){strURL = escape(document.location)}
	window.location='mailto:?subject='+escape(document.title)+'&body=Please see '+strURL;
};

_page.printVersion = function(print_type) {
	var printarea, printHTML = '', crsc, privacy_footer, print_body = '', stylesheet_externalextranet, wHeight, wWidth, w, sWidth, sHeight;
	printarea = document.getElementById("p-printarea");
	if (printarea == null) {
		alert("no print area defined");
		return;
	} else {
		printHTML += printarea.innerHTML.replace(/document.write\(.+\);?/gi,""); // Remove document.write instances in the HTML;
	}
	// Create privacy footer
	crsc = _page.crsc_server;
	privacy_footer = _page.text["footer"];
	privacy_footer = privacy_footer.replace("{BR}", "<br />");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{PRIVACY}", "<a href=\""+_page.link["privacy"]+"\">"+_page.text["privacy"]+"</a>");
	privacy_footer = privacy_footer.replace("{OWNER}", "<a href=\""+_page.link["owner"]+"\">"+_page.text["owner"]+"</a>");
	privacy_footer = privacy_footer.replace("{TERMS}", "<a href=\""+_page.link["terms"]+"\">"+_page.text["terms"]+"</a>");
	privacy_footer = privacy_footer.replace("| {SITEMAP}", "");
	privacy_footer = privacy_footer.replace("{CAREERS} | ","");
	print_body += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n';
	print_body += '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n';
	print_body += '<html xmlns="http://www.w3.org/1999/xhtml">\n';
	print_body += '<head>\n';
	print_body += '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n';
	if(_page.headerType == "external_extranet") {
		// No global stylesheet when using external extranet
		stylesheet_externalextranet = "	<link rel=\"stylesheet\" type=\"text/css\" href=\""+crsc+"/crsc/styles/external_extranet.css\" />\n";
		print_body += stylesheet_externalextranet;
	} else {
		print_body += '  <link href="'+crsc + '/crsc/styles/global.css" type="text/css" rel="stylesheet" />\n';
	}
	print_body += '  <link href="'+crsc + '/crsc/styles/components.css" type="text/css" rel="stylesheet" />\n';
	print_body += '  <link href="'+crsc + '/crsc/styles/print.css" type="text/css" rel="stylesheet" />\n';
	if(_page.direction=="rtl"){
		print_body += '  <link href="'+crsc + '/crsc/styles/rtl.css" type="text/css" rel="stylesheet" />\n';
	}
	print_body += '  <link media="print" href="'+crsc + '/crsc/styles/printbrowser.css" type="text/css" rel="stylesheet" />\n';
	// Adjust styles of some locales
	if (_page.locale) {
		if (_page.locale.substring(3,5) === "zh") {
			// Add extra stylesheet for Chinese  and Korean locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/zh.css\" />\n";
		} else if (_page.locale.substring(3,5) === "ko") {
			// Add extra stylesheet for Japanese locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ko.css\" />\n";
		} else if(_page.locale.substring(3,5) === "ja") {
			// Add extra stylesheet for Japanese locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ja.css\" />\n";
		}
	}
	print_body += '	<title>'+document.title+'</title>';
	print_body += '</head>\n';
	print_body += '<body style="direction:'+_page.direction+'" onload="setTimeout(\'window.print()\', 1000);setTimeout(\'window.close()\', 5000);">\n';
	print_body += '	<div class="p-printcontainer">\n';
	print_body += '  	<div class="p-print-logo"><img alt="Philips" src="'+crsc + '/crsc/images/mainlogo.gif" /></div>\n';
	if(print_type=='press'){
		print_body += '  	<div class="p-print-press"><img alt="Press information" src="'+crsc + '/crsc/images/pressrelease_header.gif" /></div>\n';
	} else {
		print_body += '  	<div class="p-line"><img alt="" src="'+crsc + '/crsc/images/solidline.gif" /></div>\n';
	}
	print_body += '  	<div id="p-grid-c">'+printHTML+'</div>\n';
	print_body += '  	<div class="p-line"><img alt="" src="'+crsc + '/crsc/images/solidline.gif" /></div>\n';
	print_body += '  	<div class="p-print-footer">\n';
	print_body += '  	  ' + privacy_footer +'\n';
	print_body += '		</div>\n';
	print_body += '	</div>\n';
	print_body += '</body></html>\n';
	// Create popup window
	wHeight=500;
	wWidth=700;
	w = window.open('','','height='+wHeight+',width='+wWidth+',toolbar=yes,scrollbars=yes')
	// Center popup window
	sWidth = parseInt(gsW());
	sHeight = parseInt(gsH());
	if( sWidth>0&&sHeight>0 ){w.moveTo(Math.round((sWidth-wWidth)/2),Math.round((sHeight-wHeight)/2))};
	if( w.focus ) { w.focus(); }
	w.document.open();
	w.document.write(print_body);
	w.document.close();
};

_page.showPopup = function(url) {
	var wHeight = _page.popupHeight, wWidth=_page.popupWidth, w;
	w = window.open(url,'_blank','height='+wHeight+',width='+wWidth+',toolbar=no,scrollbars=yes,resizable=yes')
	return false;
};

_page.writePopupHeader = function() {
	_page.headerType = "popup";
	var strHTML = "", crsc = _page.crsc_server;
	strHTML+='<link href="'+crsc+ '/crsc/styles/popup.css" type="text/css" rel="stylesheet" />\n';
	strHTML+='	<table cellspacing="0" cellpadding="0" id="p-container">\n';
	strHTML+='		<tr>\n';
	strHTML+='			<td id="p-containertd">\n';
	strHTML+='				<table  cellspacing="0" cellpadding="0" id="p-inner-container">\n';
	strHTML+='					<tr>\n';
	strHTML+='						<td id="p-inner-containertd">\n';
	strHTML+='							<table cellspacing="0" cellpadding="0" id="p-popup-container">\n';
	if(!_page.popupHideHeader) {
		strHTML+='							<tr>\n';		
		strHTML+='								<td id="p-popup-header">\n';		
		strHTML+='									<img alt="Philips" src="'+crsc+ '/crsc/images/mainlogo.gif" />\n';
		strHTML+='								</td>\n';		
		strHTML+='							</tr>\n';		
	}
	strHTML+='								<tr>\n';		
	strHTML+='									<td id="p-popup-body">\n';	
	_page.write(strHTML,false);
	if(_page.activateActiveX) includeActiveXFix();
};

_page.writePopupFooter = function() {
	var privacy_footer, strHTML;
	privacy_footer = _page.text["footer"];
	privacy_footer = privacy_footer.replace("{OWNER} | {PRIVACY} | {TERMS} | {SITEMAP}{BR}", "");
	privacy_footer = privacy_footer.replace("{COPYRIGHT}", _page.text["copyright"]);
	privacy_footer = privacy_footer.replace("{CAREERS} | ","");
	strHTML = "";
	strHTML+='									</td>';
	strHTML+='								</tr>';
	if(!_page.popupHideFooter) {
		strHTML+='							<tr>\n';		
		strHTML+='								<td id="p-popup-footer">\n';		
		strHTML+=									privacy_footer+'\n';
		strHTML+='								</td>\n';		
		strHTML+='							</tr>\n';		
	}
	strHTML+='							</td>';
	strHTML+='						</tr>';
	strHTML+='					</table>';
	strHTML+='				</table>';
	strHTML+='			</td>';
	strHTML+='		</tr>';
	strHTML+='	</table>';
	_page.write(strHTML,false);
	addOnLoadEvent(resizePopup);	// Fit window to content
	onloadHandler();
};

// Function which checks the cases
_page.checkSpecialCase = function() {
	var strMapping, strSep1, strSep2, position, arrObjReplace, arrTmpClass, strAction, i;
	// Initialize 
	strMapping = _page.text["case_mapping"];
	if(strMapping != " " && strMapping != "") {
		// Set mappings if available
		strSep1 = "&amp;&amp;";
		strSep2 = ",";	
		_page.arrCaseMapping = strMapping.split(strSep1);
		for(i=0;i<_page.arrCaseMapping.length;i++) {
			position = _page.arrCaseMapping[i].indexOf(strSep2);
			_page.arrLCase[i] = _page.arrCaseMapping[i].substring(0,position);
			_page.arrUCase[i] = _page.arrCaseMapping[i].substring(position+1,_page.arrCaseMapping[i].length);
		}				
		// Check for all affected objects
		arrParentClass = new Array();
		arrParentClass["H4"] = new Array();
		arrParentClass["H4"]["p-header"] = new Array();
		arrParentClass["H4"]["p-header"]["p-form"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-payment"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-approval"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-approval-support"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-comparison"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-product-related"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-table"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-404"] = "ucase";
		arrParentClass["H4"]["p-header"]["p-contact-category"] = "ucase";
		for(strClassName in arrParentClass) {
			arrObjReplace = document.getElementsByTagName(strClassName);
			for(i=0;i < arrObjReplace.length;i++){
				arrTmpClass = arrParentClass[strClassName];
				strAction = getSpecialCaseAction(arrObjReplace[i],arrTmpClass);
				if(strAction!="") {
					replaceSpecialCase(arrObjReplace[i],strAction,"innerHTML");
				}
			}	
		}
	}
}

// Function which set's active tab
_page.showTab = function (intTable,intRow){	
	var tmpTableTop, tmpTableContent, rowsLength, tmpRowTop, tmpRowContent, tmpCellContentNew, tmpCellContentDup, tmpRow, i;
	// Get table objects
	tmpTableTop = gE("table_top"+intTable);
	tmpTableContent = gE("table_content"+intTable);
	rowsLength = gE("table_content"+intTable).rows.length;
	for(i=0;i<rowsLength;i=i+2){
		if(i==intRow){	
			//Display the tab as active.
			applyStyle(gE("headermain"+intTable+"_"+i),"p-tab-active");
			// Get selected boy node and duplicate it
			tmpRowTop = tmpTableTop.rows[1];
			tmpRowContent = gE("body"+intTable+"_"+(intRow+1));
			tmpCellContentNew = tmpRowContent.firstChild;
			tmpCellContentDup = tmpCellContentNew.cloneNode(true);
			applyStyle(tmpCellContentDup,"p-content");
			// Add extra cell and delete previous one
			tmpTableTop.rows[1].appendChild(tmpCellContentDup);
			tmpTableTop.rows[1].deleteCell(0);
			// Copy extra cell into new row
			tmpRow = tmpRowTop.cloneNode(true);
			tmpRowTop.parentNode.insertBefore(tmpRow,tmpRowTop);
			tmpTableTop.deleteRow(1);
		}else{
			applyStyle(gE("headermain"+intTable+"_"+i),"p-tab-inactive");			
		}
	}
};

// Function which creates tabbed tables
_page.createTabs = function(intTableCount , tmpTableObj){
	var maxHeight, strTableType, tmpTable, tmpBody, tmpRow, tmpCell, tmpDiv, tmpText, curHeight, tmpRowBody, tmpCellBody, tmpRowBottom, tmpCellBottom, tmpTableFooter, tmpBodyFooter, tmpRowFooter, tmpCellFooter, i, z;
	maxHeight = 0;
	strTableType = tmpTableObj.type;
	// Set content table style to hidden or nodisply
	tmpTableObj.cellSpacing = 0;
	tmpTableObj.cellPadding = 0;
	applyStyle(tmpTableObj,(strTableType == "p-tab-double"?"p-tabbedtable-hidden":"p-tabbedtable-nodisplay"));	
	// Create Main Table
	tmpTable = document.createElement("table");
	tmpBody = document.createElement("tbody");
	tmpRow = document.createElement("tr");
	tmpCell = document.createElement("td");
	tmpTable.id = "table_top"+intTableCount;
	applyStyle(tmpTable,(strTableType == "p-tab-double"?"p-extrainfo-double":"p-extrainfo-multiple"));
	tmpTable.cellSpacing = 0;
	tmpTable.cellPadding = 0;
	tmpCell.className = "p-top";
	tmpTableObj.parentNode.insertBefore(tmpTable,tmpTableObj);
	tmpTable.appendChild(tmpBody);
	tmpBody.appendChild(tmpRow);
	tmpRow.appendChild(tmpCell);		
	//Process all rows and display the tabs
	maxRows = tmpTableObj.rows.length;
	intRow = 0;
	for(i=0;i<maxRows;i++) {
		curRow = tmpTableObj.rows[i];
		// Only process child rows, no nested table/rows (Opera compat. issue)
		if(curRow.parentNode.parentNode.id == tmpTableObj.id) {
		curRow.id = "body"+intTableCount+"_"+intRow;
			//Header row
			if(Math.round(intRow/2)==intRow/2){
				// Tab Header left
				tmpDiv = document.createElement("div");
				applyStyle(tmpDiv,"p-tab-border-left");
				tmpDiv.id="headerleft"+intTableCount+"_"+intRow;
				tmpCell.appendChild(tmpDiv);					
				// Tab Header body
				tmpDiv = document.createElement("div");
				applyStyle(tmpDiv,"p-tab-inactive");
				tmpDiv.id="headermain"+intTableCount+"_"+intRow;
				tmpDiv.onclick = _page.showTab.bindArgs(tmpDiv,[intTableCount,intRow]);
				tmpCell.appendChild(tmpDiv);
				//Create a new text object in the cell object.
				tmpText = document.createTextNode(ReplaceTags(curRow.firstChild.innerHTML));
				tmpDiv.appendChild(tmpText);
				// Tab Header right
				tmpDiv = document.createElement("div");
				applyStyle(tmpDiv,"p-tab-border-right");
				tmpDiv.id="headerright"+intTableCount+"_"+intRow;
				tmpCell.appendChild(tmpDiv);
				// Tab spacer, only visibile between tabs
				if(tmpTableObj.rows[i+2]!=null) {
					tmpDiv = document.createElement("div");
					applyStyle(tmpDiv,"p-tab-spacer");
					tmpCell.appendChild(tmpDiv);
				}	
			} else {
				// Get heighest tab
				if(strTableType=="p-tab-double") {
					curHeight = curRow.firstChild.offsetHeight;
					maxHeight = (curHeight>maxHeight?curHeight:maxHeight);
				}	
			}
			intRow++;
		} else {
			maxRows++;
		}
	}
	// Create body row
	tmpRowBody = document.createElement("tr");
	tmpCellBody = document.createElement("td");
	tmpBody.appendChild(tmpRowBody);
	tmpRowBody.appendChild(tmpCellBody);
	if(strTableType=="p-tab-double") {
		// Create bottom, only in double tabbed table
		tmpRowBottom = document.createElement("tr");
		tmpCellBottom = document.createElement("td");
		applyStyle(tmpCellBottom,"p-bottom");
		tmpBody.appendChild(tmpRowBottom);
		tmpRowBottom.appendChild(tmpCellBottom);
		// Create footer table in cell bottom
		tmpTableFooter = document.createElement("table");
		tmpBodyFooter = document.createElement("tbody");
		tmpRowFooter = document.createElement("tr");
		tmpTableFooter.cellSpacing = "0";
		tmpTableFooter.cellPadding = "0";
		tmpCellBottom.appendChild(tmpTableFooter);
		tmpTableFooter.appendChild(tmpBodyFooter);
		tmpBodyFooter.appendChild(tmpRowFooter);
		// Left footer cell
		tmpCellFooter = document.createElement("td");
		applyStyle(tmpCellFooter,"p-bottom-left");
		tmpRowFooter.appendChild(tmpCellFooter);
		// Right footer cell
		tmpCellFooter = document.createElement("td");
		applyStyle(tmpCellFooter,"p-bottom-right");
		tmpRowFooter.appendChild(tmpCellFooter);
		//Set max height to each body row
		intRow = 0;
		for(z=0;z<tmpTableObj.rows.length;z++) {
			curRow = tmpTableObj.rows[z];
			sH(curRow.firstChild,maxHeight+6);
		}
		//Set content table back top display: none
		applyStyle(tmpTableObj,"p-tabbedtable-nodisplay");
	}	
};	

_page.get_fontsize = function() {
	var strCookie = readCookie("Philips-Fontsize");
	if(strCookie!=null) {
		_page.articleCSSFontsizeCurrent = strCookie.substr(strCookie.indexOf("fontsize=")+9,strCookie.length);
		_page.font_resize();
	}
}

_page.articleCSS = null;
_page.font_resize = function(intFontsizeMultiplier) {
	var intFontsize, strCSSText, intListItemTop;
	// Set new font-size and define CSS rules
	intFontsize = (_page.articleCSSFontsizeCurrent!=""?_page.articleCSSFontsizeCurrent:_page.articleCSSFontsizeDefault);
	// Only adjust font-size if multiplier has been set
	if(intFontsizeMultiplier) {
		if(intFontsizeMultiplier > 1){
			intFontsize = Math.round(parseInt(intFontsize) * intFontsizeMultiplier)
		} else {
			intFontsize = Math.round(parseInt(intFontsize) / (1+(1-intFontsizeMultiplier)))
		}
	}
	intListItemTop = Math.round((intFontsize / 100 * 0.2)*10)/10 // List item positioning
	strCSSText =".p-article{font-size:"+intFontsize+"%!important;line-height:160%!important;}.p-article ul li{background-position:0 "+intListItemTop+"em;}";
	_page.articleCSSFontsizeCurrent = intFontsize;
	if(_page.articleCSS == null) {
		// Add new stylesheet
		_page.articleCSS = new _page.stylesheet();
		_page.articleCSS.add(strCSSText);
	} else {
		// Update stylesheet
		_page.articleCSS.update(strCSSText);
	}
}
	
// Function which created array with all current browser information
_page.setBrowserInfo = function () {
	var intBrowserSupported, fltMinBrowserVersion, intBreak, intBrowser, strBrowserPlatform, strBrowserName, fltBrowserVersion, id;
	// Flash 
	if(typeof(browser_flashInstalled) == "undefined") _page.setFlashInfo();
	_page.browserInfo["browser_flash_installed"] = _page.browser.flashInstalled;
	_page.browserInfo["browser_flash_version"] = _page.browser.flashVersion;
	// Philips browser compliancy			
	_page.browserInfo["browser_name"] =_page.browser.name;
	_page.browserInfo["browser_version"] = _page.browser.versionMinor;
	_page.browserInfo["browser_platform"] = _page.browser.platform;
	_page.browserInfo["browser_dhtml"] = _page.browser.isDHTML;
	_page.browserInfo["browser_dom"] = _page.browser.isDOM;
	// Current browser supported
	_page.browserSupport = new Array();
	_page.browserSupport["1"] = [// Philips Supported browsers  / == if equal
									["win32","Internet Explorer",5.5],
									["win32","Internet Explorer",6],
									["win32","Netscape",6.2],
									["win32","Netscape",7],
									["win32","FireFox",1.0],
									["mac","Internet Explorer",5.23],
									["mac","Netscape",6.2],
									["mac","Netscape",7],
									["mac","Netscape",7.1]
								];									
	_page.browserSupport["2"] = [// Philips best-practise browsers  / => if equal or higher
									["win32","Internet Explorer",5],
									["win32","Mozilla",1.6],
									["win32","Opera",7.54],
									["win32","Firefox",0.9],
									["mac","Internet Explorer",5],
									["mac","OmniWeb",563],
									["mac","Firefox",0.9],
									["mac","Safari",1.2],
									["mac","Opera",7.54]
								];
	intBrowserSupported = 3; // Default not supported (1/2/3)
	fltMinBrowserVersion = parseFloat(_page.browser.versionMinor);
	intBreak = false;
	for(id in _page.browserSupport) {
		if(intBreak == false) {
			for(intBrowser=0;intBrowser<=(_page.browserSupport[id].length-1);intBrowser++) {
				strBrowserPlatform = _page.browserSupport[id][intBrowser][0];
				strBrowserName = _page.browserSupport[id][intBrowser][1];
				fltBrowserVersion = parseFloat(_page.browserSupport[id][intBrowser][2]);
				// Match platform and browser name
				if((strBrowserName.toLowerCase() == _page.browser.name.toLowerCase()) && (strBrowserPlatform == _page.browser.platform)) { 
					switch (id){
					case "1": 
						// Equal same version 
						if( fltMinBrowserVersion == fltBrowserVersion) {intBrowserSupported = id; intBreak = true}; 
						break;
					case "2":
						// Equal or higher version
						if( fltMinBrowserVersion >= fltBrowserVersion) {intBrowserSupported = id; intBreak = true}; 
						break;
					}
				}
			}
		}	
	}
	_page.browserInfo["browser_supported"] = intBrowserSupported;
};

// Print all browser info
_page.printBrowserInfo = function() {
	var tableHTML = '', id;
	tableHTML += "<table class=\"p-table\" cellspacing=\"0\">\n";
	tableHTML += "	<tr>\n";
	tableHTML += "		<td class=\"p-header\"><H4>Browser info</H4></td>\n";
	tableHTML += "	</tr>\n";
	tableHTML += "	<tr>\n";
	tableHTML += "		<td class=\"p-content\">\n";
	tableHTML += "			<table cellspacing=\"0\">\n";
	tableHTML += "				<tr class=\"p-bold\">\n";
	tableHTML += "					<td>Id</td>\n";
	tableHTML += "					<td class=\"p-hl\">Value</td>\n";
	tableHTML += "				</tr>\n";
	if(_page.loadBrowserInfo == false) {
			tableHTML += "				<tr><td colspan=\"2\"><i>To retrieve browser info, make sure <b>_page.loadBrowserInfo = true;</b> has been set in the HTML header. </i></td></tr>\n";		
	} else {
		for(id in _page.browserInfo) {
			tableHTML += "				<tr>\n";
			tableHTML += "					<td>"+id+"</td>\n";
			tableHTML += "					<td class=\"p-hl\">"+_page.browserInfo[id]+"</td>\n";
			tableHTML += "				</tr>\n";
		}
	}		
	tableHTML += "			</table>\n";
	tableHTML += "		</td>\n";
	tableHTML += "	</tr>\n";
	tableHTML += "</table>\n";
	document.write(tableHTML);
};

/* Get flash info: installed and version */
_page.setFlashInfo = function() {
	var flashInfo = FlashDetect();
	if(_page.browser) {
		_page.browser.flashInstalled = flashInfo[0];
		_page.browser.flashVersion = flashInfo[1];
	}
}

// Function which activates all "disabled" active-x objects within the document due to Microsoft Windows IE patch
_page.activeXCSS = null;
}

/*
*************************************
***** Include stylesheets 		*****
*************************************
*/
function include_stylesheets () {
	// This function will be used to include stylesheets
	// Values in extra stylesheets will overrule values in global stylesheet
	var crsc = _page.crsc_server, stylesheet = '', rtl;
	if (!_page.hideGlobalStyle) {
		// Show global stylesheet
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/global.css\" />\n";
	}
	if(_page.headerType === "internet") {
		// Show stylesheet for internet
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/internet.css\" />\n";
	}
	// Show stylesheet for components
	stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/components.css\" />\n";
	switch (_page.headerType) {
	case "external_extranet":
		// Show stylesheet for extranet
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/external_extranet.css\" />\n";
		break;
	case "microsite":
		// Show stylesheet for microsite
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/microsite.css\" />\n";
		break;
	case "popup":	
		// Show stylesheet for rich content popup
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/popup.css\" />\n";
		break;
	}
	// TEMPORARY backwards compatibility (old design) navigation header
	if (_page.headerType === "internet" && !_page.newHeaderNav) {
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/headernav_old.css\" />\n";
	}
	if (!_page.hideGlobalStyle) {
		// Add specific stylesheet for printing
		stylesheet += "<link media=\"print\" rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/printbrowser.css\" />\n";
	}
	// Include RTL stylesheet when RTL language is used
	if (_page.direction === "rtl") {
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/rtl.css\" />\n";
	}	
	if (_page.browser.isMac) {
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/mac.css\" />\n";
	}
	if (_page.browser.isNS6x) {
		// Add temp for fix NS6.2 drop down menu
		stylesheet += "<style>td.dd-inactiveItem{font-size:80%;}td.dd-activeItem{font-size:80%;}.p-table_flyout{font-family:Verdana, Arial, Helvetica, sans-serif;font-size:70%;}</style>";
	}
	if (_page.browser.isNS6x || _page.browser.isNS7x) {
		// Remove border-collapse for Netscape. This causes problems when JS files are included in the content area
		stylesheet += "<style>.p-content-grid{border-collapse:inherit;}</style>";
	}
	if (_page.browser.isNS7x) {
		// Remove border in menu for Netscape. This was showing grids when menu should be  hidden
		stylesheet += "<style>table.p-dropdown table td{border-width:0px;}</style>";
	}
	if (_page.browser.isOpera && _page.browser.isWin) {
		stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/opera.css\" />\n";
	}
	// Include Internet Explorer specific stylesheet - necessary to calculate the absolute PNG path.
	stylesheet += "<!--[if lte IE 6]>\n";
	if (_page.newHeaderNav) {
		if (_page.direction === "rtl") {
			// Currently not in use
			// stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ie_transparency_rtl.css\" />\n";
		} else {
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ie_transparency.css\" />\n";
		}
	} else {
		if (_page.direction === "rtl") {
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/headernav_old_ie_rtl.css\" />\n";
		} else {
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/headernav_old_ie.css\" />\n";
		}
	}
	stylesheet += "<![endif]-->\n";
	// Adjust styles of some locales
	if (_page.locale) {
		if (_page.locale.substring(3,5) === "zh") {
			// Add extra stylesheet for Chinese  and Korean locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/zh.css\" />\n";
		} else if (_page.locale.substring(3,5) === "ko") {
			// Add extra stylesheet for Japanese locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ko.css\" />\n";
		} else if(_page.locale.substring(3,5) === "ja") {
			// Add extra stylesheet for Japanese locales
			stylesheet += "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + crsc + "/crsc/styles/ja.css\" />\n";
		}
	}
	// Write stylesheets to screen
	if (stylesheet !== "") document.write(stylesheet);
};

function getLocaleURL(locale){
	// Get correct link to switch to
	return _page.locales[locale];
};

/* Helper function for locale switching pages */

	function set_localeselector(){
		if(!document.changelanguage) return;
		var optionName, optionName2;
		// Add text and global option on top of select box
		optionName = new Option(_page.text["localeselector"], "");
		document.changelanguage.locale.options[0] = optionName;	
		optionName2 = new Option("Global / English", "global");
		document.changelanguage.locale.options[1] = optionName2;	
	};
		
	function redirect_item(locale){
		if(!document.changelanguage) return;
		if(document.changelanguage.locale.value!=""){
			if(document.changelanguage.remember.checked){
				// Remember locale setting
				_page.setlocale(locale);
			} else{
				// Redirect directly to site
				window.open(_page.locales[document.changelanguage.locale.value], "_self");
			}
		} else{
			alert(_page.text["alert2"]);
		}
	};
 /* End helper function*/
 
updateLocales = function(area){
	// This function will update the list of locale files on basis of the Homepage file that is loaded
	// Set standard switching text + Global link
	if(!document.changelanguage) return;
	var optionName, strSelectedlocale, nr_locale, current_country, current_language, show_locale;
	set_localeselector();
	nr_locale = 2;
	for(anItem in _page.locales){
			if(anItem!="global"){
				current_country = anItem.substring(0,2);
				current_language = anItem.substring(3,5);
				show_locale = _page.countries[current_country] +" / "+ _page.languages[current_language];
				optionName = new Option(show_locale, anItem);
				document.changelanguage.locale.options[nr_locale] = optionName;
				nr_locale += 1;
			}		
	}
	// Sort list
	SortSelectList(document.changelanguage.locale);
	// Add others option at the last position in the list / Only applicable for normal internet site
	if(_page.headerType =="internet") {
		_page.locales["others"] = "http://www.philips.com/countries";
		optionName = new Option("Others", "others" );
		document.changelanguage.locale.options[nr_locale] = optionName;
	}
	// Set selected locale in localelist
	strSelectedlocale = (_page.selectedLocale!=""?_page.selectedLocale:_page.locale);
	setSelectListLocale(strSelectedlocale);	
};

function processLocales() {
	var arrLocales = [], i, anItem, strCountry, strLanguage, sortCol, sortOrder, lengthLocales;
	// Build array
	if(_page.locales["others"]) delete _page.locales["others"];			// Delete current others var if exists, as it will be appended to the bottom
	i = 1;
	for(anItem in _page.locales){
		if(anItem != "global") {
			strCountry = _page.countries[anItem.substring(0,2)];
			strLanguage = _page.languages[anItem.substring(3,5)];
			arrLocales[i] = [];
			arrLocales[i][0] = anItem;									// Store locale code
			arrLocales[i][1] = strCountry;								// Store country
			arrLocales[i][2] = strLanguage; 							// Store language
			arrLocales[i][3] = _page.locales[anItem]; 					// Store link
			arrLocales[i][4] = strCountry+" / "+strLanguage; 			// Store combi country/language
			i++;
		}
	}
	if(i > 1) {
		arrLocales[0] = []; 	// Create first container for locale global.
		arrLocales[0][4] = "/"	// Enter empty value, inorder to make sure the element is on top of the list
		// Sort array
		function sortArray(a,b) {
			if (a[sortCol]<b[sortCol]) return (sortOrder=="asc"?-1:1);
			if (a[sortCol]>b[sortCol]) return (sortOrder=="asc"?1:-1);
			return 0;
		}
		sortCol=4;
		sortOrder="asc";
		arrLocales.sort(sortArray);
		// Insert global locale as first element
		arrLocales[0][0] = "global";
		arrLocales[0][1] = "Global";
		arrLocales[0][2] = "English";
		arrLocales[0][3] = _page.locales["global"];
		arrLocales[0][4] =  arrLocales[0][1]+" / "+arrLocales[0][2];
		// Add others option at the last position in the list / Only applicable for normal internet site
		if(_page.headerType =="internet") {
			lengthLocales = arrLocales.length;
			_page.locales["others"] = "http://www.philips.com/countries";
			arrLocales[lengthLocales] = [];
			arrLocales[lengthLocales][0] = "others";
			arrLocales[lengthLocales][1] = "Others";
			arrLocales[lengthLocales][2] = "";
			arrLocales[lengthLocales][3] = _page.locales["others"];
			arrLocales[lengthLocales][4] = "Others";
		}
	}	
	return arrLocales;
}

/*
**********************************
******* Top menu functions *******
**********************************
*/

// Fired on mouseover of a section
function sectionOn(sect, event){
	event.cancelBubble = true;
	hideOtherMenus(sect);
	if(menuDown != sect){
		clearTimeout(dropDown);
		_page.topNavType == "internet"?sectionButtonOn(sect):sectionButtonHover(sect);
		menuDown = sect;
		section = sect;
		positionDropDown(sect);
		dropDown = setTimeout('dropdownMenu("' + sect + '")', dropdown_show_delay);
	}
};

// Fired on mouseout of a section
function sectionOff(sect){				
	if(sect != section){
		sectionButtonOff(sect);
	}
};

// This function sets the style of section 'sect' to hover
function sectionButtonHover(sect){
	var td = document.getElementById(sect + "button");
	if(td){
		if(sect != currSection){
			applyStyle(td, "sectionhover");	
		}
	}
}

// This function sets the style of section 'sect' to active
function sectionButtonOn(sect){
	var td, sepLeft, sepRight;
	td = document.getElementById(sect + "button");
	if(td){
		// Set style of this TD to 'active'
		if(_page.topNavType == "internet") {
			applyStyle(td, "sectionon");
		} else {
			applyStyle(td, "sectionon");
			sepLeft = td.previousSibling;
			if(sepLeft.nodeType == 3) sepLeft = sepLeft.previousSibling;
			if(sepLeft) applyStyle(sepLeft, "mainnavsep-left");	
			sepRight = td.nextSibling;
			if(sepRight.nodeType == 3) sepRight = sepRight.nextSibling;
			if(sepRight) applyStyle(sepRight, "mainnavsep-right");	
		}
	}		
};

// This function sets the style of section 'sect' to inactive 
function sectionButtonOff(sect){
	var td = document.getElementById(sect + "button"); 
	if(td){
		if(sect != currSection){
			if (td.getAttribute("className") != "navbutton") {
				applyStyle(td, "navbutton");
			}
		}
	}
};

// This function shows the dropdown menu of section 'sect'
function dropdownMenu(sect){
	// Show drop-down menu
	showDD(sect);
};

// This function hides all menu's with a delay of 'menu_hide_delay' (see general settings)
function hideAllMenus() {
	clearTimeout(dropDown);
	hideMenu = setTimeout('hideIt()', menu_hide_delay);	
	menuDown = "";
}

// 	This function hides all menu's except the menu of the section 'skipSect'
function hideOtherMenus(skipSect) {
	var counter, sect;
	for(counter=1;counter<menuArray.length;counter++) {
		if(menuArray[counter] != skipSect){
			sect = menuArray[counter];
			sectionButtonOff(sect);				
			hideDD(sect);
		};		
	};
};

// 	This function hides all menu's except the one that's currently active
function hideIt(){
	var counter, sect;
	for(counter=1;counter<menuArray.length;counter++) {
		if(menuArray[counter] != menuDown){
			sect = menuArray[counter];
			sectionButtonOff(sect);
			hideDD(sect);
		};
	};
};

// This function shows the dropdown of 'sect'
function showDD(sect) {
	var objDD, ddframe;
	objDD = gE('p-' + sect + 'DD');
	if(objDD){
		objDD.style.zIndex=1;
		sE(objDD);
		if (useIframe) {
			ddframe = gE('p-' + sect + 'IF');
			if(ddframe) sE(ddframe);
		};
	};
};

// This function hides the dropdown of 'sect'
function hideDD(sect) {
	var odd, ddframe;
	odd = gE('p-' + sect + 'DD');
	if(odd) {
		hE(odd);		// Hide element
		if (useIframe) {
			ddframe = gE('p-' + sect + 'IF');
			if(ddframe) hE(ddframe);
		};
	};
};
	
// This function sets the style of an active drop-down item
function activeDDItem(td, extra_class){
	applyStyle(td, "dd-activeItem"+extra_class);
};

// This function sets the style of an inactive drop-down item
function inactiveDDItem(td, extra_class){
	applyStyle(td, "dd-inactiveItem"+extra_class);
};

// This function returns the X position of 'objElement'
function getLeftPos(objElement) {
	var offsetLeft = findPosX(objElement);
	return offsetLeft - 2;
};

// This function returns the Y position of 'objElement'
// Note: instead of returning the top of the object, the bottom is returned!
function getTopPosBottom(objElement) {
	var adjust = 0;
	// Onderstaand kan netter
	if(objElement != null){
		if(objElement.offsetHeight!=33){
			// 33 is height of top menu (return bottom of object). Return top of object for rest.
			if(objElement.offsetHeight==34){
				// Two lines in flyout
				adjust = objElement.offsetHeight - 18;
			}else{
				adjust = objElement.offsetHeight - 20;
			}		
		}
		return findPosY(objElement) + objElement.offsetHeight - adjust;
	}
	return 0;
};

// This function positions all the dropdown layers
// Every dropdown is aligned with the corresponding menu-button
function positionDropDown(section){
	var objButton, dd, ddframe, extra_left;
	// Position drop-down
	objButton = gE(section + 'button');
	dd = gE('p-' + section + 'DD');
	if(dd) {
		extra_left = 1;
		// If page direction is RTL, then dropdown aligns with right-side of button
		if(_page.direction=="rtl"){
			// Calculate space to move box to the left
			extra_left = objButton.offsetWidth - dd.offsetWidth + 3;
		}
		// Position the dropdown-menu
		sX(dd, getLeftPos(objButton)+extra_left);
		sY(dd, getTopPosBottom(objButton));
		// If browser is not NS or IE5, set size and position the iframe behind dropdown
		if (useIframe) {
			ddframe = gE('p-' + section + 'IF');
			sH(ddframe, (dd.offsetHeight));
			sW(ddframe, (dd.offsetWidth));
			sX(ddframe, getLeftPos(objButton)+extra_left);
			sY(ddframe, getTopPosBottom(objButton));
		}
	}
};

// This function initiates the positioning of dropdowns and overlay fillers
function initDropDowns(){
	for(var counter=1;counter< menuArray.length;counter++) {
		// Position dropdown
		positionDropDown(menuArray[counter]);
	}
}

// Function to create the dropdown menu, append HTML to array
function createTopNavMenu(m) {
	var tm, dropdown, show_class, extra_class, language_switch, i;
	tm = _page.headerType == "external_extranet"?_page.topNavXN[m]:_page.topNav[m];
	dropdown = '';
	dropdown+="		<!-- "+m+" section dropdown-->\n";
	// If needed for browsertype, create IFRAME to solve select-problem
	if(useIframe) {
		dropdown+="		<IFRAME frameborder=0 id=\"p-"+m+"IF\" src=\"javascript:false;\" scroll=none style=\"FILTER:progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0);visibility:hidden;height:0;position:absolute;width:0px;top:0px;z-index:0;\"></iframe>";
	}
	// Create actual dropdown
	dropdown+="			<div id=\"p-"+m+"DD\" class=\"p-mainnavDD\" onmouseover=\"event.cancelBubble=true\">\n";
	if (tm.length>1) {
		// Only load table if submenu's are available
		if(_page.headerType == "external_extranet") {
			dropdown+="			<div class=\"p-mainnavDD-spacer\" style=\"height:"+topmenu_dd_spacer+"px\">&nbsp;</div>\n";
		}	
		dropdown+="			<table class=\"p-dropdown\" cellspacing=\"0\" onmouseover=\"sectionOn('"+m+"', event)\">\n";				
		for (i=1;i<tm.length;i++) {
			dropdown+="							<tr>\n";
			// Get layout of item (check extra parameters)
			show_class  = "dd-inactiveItem";
			extra_class = "";
			language_switch = "";
			if(typeof(tm[i][2])!="undefined"){
				if(tm[i][2].indexOf("bold=yes")!=-1){
					show_class="dd-inactiveItem p-bold";
					extra_class = " p-bold";
				}
			}					
			// Check if there is a language switch
			language_switch = '';
			if(tm[i][2]) language_switch = getLanguageSwitch(tm[i][2]);
			dropdown+="								<td class=\""+show_class+"\" onmouseover=\"activeDDItem(this, '"+extra_class+"')\" onmouseout=\"inactiveDDItem(this, '"+extra_class+"')\"\n";
			dropdown+="									onclick=\"Javascript:_page.switchHandler('"+tm[i][1]+"', '_self', '"+language_switch+"')\">\n";
			dropdown+="									"+tm[i][0]+"\n";
			dropdown+="								</td>\n";
			dropdown+="							</tr>\n";
		}
		dropdown+="						</table>\n";
	}
	dropdown+="		</div>\n";
	dropdown+="		<!-- end "+m+" section dropdown -->\n";
	return dropdown;
};

/*
*********************************
****** Left menu functions ******
*********************************
*/

// Object for left menu items
function _Item(text, link, options) {		
	this.text = text;
	this.link = link;
	this.options = options;
	this.flyoutid = 0;
	this.flyoutopenid = 0;
	this.parentid = "";
	this.level = 0;				// Default level, incremented during item_update
	this.children = false;		// By default -> no children. Value is changed in _Item_update()
	this.showLink = true; 		// Show standard the links in the menu
	this.showCategory = false;	// Item is not category by default
	this.hideChilds = false;	// Always use flyout instead of childs in left-menu
	this.showAll = false;		// Show all childs or not
	this.hideLink = false;		// Hide current link from left menu
	this.hideFlyout = false;	// Force hidden flyout
};	

resizePopup = function() {
	var w, oD, oW, oH, myW, myH;
	w = window;
	// Get popup container div
	oD = w.document.getElementById('p-inner-containertd'); if( !oD ) { return false; }
	// Get offset dimensions popup
	oW = goW(oD);
	oH = goH(oD); if( !oH ) { return false; }
	if(!_page.popupAutoFitWindowToContent)	{
		// Manual resize
		oW = _page.popupWidth;
		oH = _page.popupHeight;
		w.resizeTo(oW, oH);
	} 
	else if(_page.popupAutoFitWindowToContent) {
		// Auto resize
		// Resize popup use 200 width/height extra to force unknown scrollbars
		w.resizeTo( oW + 200, oH + 200 );
		// Get inside dimensions
		myW = 0, myH = 0;
		myW = getScreenWidth()
		myH = getScreenHeight();
		if(window.opera && !document.childNodes) { myW -= 16; }
		// Resize popup / substract the 200 width/height
		w.resizeTo( oW + ( ( oW + 200 ) - myW), oH + ( (oH + 200 ) - myH) );
	}
	// Center popup
	w.moveTo(Math.round((gsW()-oW)/2),Math.round((gsH()-oH)/2));
	if( w.focus ) { w.focus(); }
};

// Function to create cookie
function createCookie(name,value,days) {
	var date, expires;
	if (days) {
		date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		expires = "; expires="+date.toGMTString();
	} else { 
		expires = "";
	}	
	// document.cookie = name+"="+value+expires+"; path=/;domain=philips.com";
	document.cookie = name+"="+value+expires+"; path=/";
};	

// Function to read cookie
function readCookie(name)	{
	var nameEQ, ca, c, i;
	nameEQ = name + "=";
	ca = document.cookie.split(';');
	for(i=0;i < ca.length;i++)	{
		c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length); // Remove spaces in front of cookie name
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
};

// Function to erase cookie
function eraseCookie(name)	{
	createCookie(name,"",-1);
}

// Function which replaces the current sectionBanner
function replaceSectionBanner(useFlash,tmpSection){
	var crsc, showImage, objSection, flashFileName, flashPre, flashExt, curLocale, flashDynamic, tmpTargetVal, tmpReplaceVal, flashHTML;
	crsc = _page.crsc_server;
	showImage = true;
	objSection = document.getElementById("p-sectionbanner");
	if(objSection) {
		if(useFlash) {
			// Call flash detection function if needed
			if(typeof(_page.browser.flashInstalled)=="undefined") _page.setFlashInfo();
			// Flash installed and version 6 or higher
			if(_page.browser.flashInstalled == 2 && (parseInt(_page.browser.flashVersion) >= 6)) {		
				flashFileName = "";
				flashPre = "section_banner";					
				flashExt = ".swf";
				curLocale = _page.locale;
				flashDynamic = true;
				bannerDynamic = new Array();
				// consumer
				bannerDynamic["consumer_us_en"] = "section_banner_consumer_us";
				bannerDynamic["consumer_de_de"] = "section_banner_consumer_de_nl_uk";
				bannerDynamic["consumer_nl_nl"] = "section_banner_consumer_de_nl_uk";
				bannerDynamic["consumer_uk_en"] = "section_banner_consumer_de_nl_uk";
				// medical
				bannerDynamic["medical_it_it"] = "section_banner_medical_it";
				// all sections russian
				bannerDynamic[tmpSection+"_ua_ru"] = "section_banner_"+tmpSection+"_ru_ru";
				// asian english
				bannerDynamic["about_cn_en"] = "section_banner_about_asia";
				bannerDynamic["about_hk_en"] = "section_banner_about_asia";
				bannerDynamic["about_in_en"] = "section_banner_about_asia";
				bannerDynamic["about_my_en"] = "section_banner_about_asia";
				bannerDynamic["about_ph_en"] = "section_banner_about_asia";
				bannerDynamic["about_pk_en"] = "section_banner_about_asia";
				bannerDynamic["about_sg_en"] = "section_banner_about_asia";
				// fifa banner for all locales
				bannerDynamic["fifa_"+curLocale] = "section_banner_fifa_"+curLocale;
				bannerStatic = new Array("pl_pl","cz_cs","ro_ro","sk_sk","tr_tr","cn_zh","hk_zh","tw_zh","gr_el","ru_ru","kr_ko","th_th","jp_ja","il_he","bg_bg","hu_hu");
					// Returns static filename
					function chkBannerStatic(curLocale) {
						var flashFileName = "", i;
						for(i=0;i<bannerStatic.length;i++) {
							if(bannerStatic[i] == curLocale) {
								flashFileName = flashPre + "_" + tmpSection + "_" + curLocale + flashExt;
								return "true";
							}
						}
						return "false";
					}
				// Get filename				
				if(bannerDynamic[tmpSection+"_"+curLocale]){
					// Dynamic exception
					flashFileName = bannerDynamic[tmpSection+"_"+curLocale] + flashExt;
					flashDynamic = true;
				}else{
					// Specialized Business exceptions
					if(tmpSection == "streamium_consumer"  || tmpSection == "cineos_consumer" || tmpSection == "modea_consumer") {
						// Static
						flashFileName = flashPre + "_" + tmpSection + flashExt;
						flashDynamic = false;
					}
					// Normal flash sectionbanners
					else if(chkBannerStatic(curLocale) == "true"){
						// Static
						flashFileName = flashPre + "_" + tmpSection + "_" + curLocale + flashExt;
						flashDynamic = false;
					}else{
						// Dynamic
						flashFileName = flashPre + "_" + tmpSection + flashExt;
						flashDynamic = true;
					}
				}
				// Attach parameters to flash object if dynamic flash
				tmpTargetVal = "sectionText1";
				tmpReplaceVal = _page.text['sectionbanner_'+tmpSection];
				try{tmpReplaceVal=encodeURI(tmpReplaceVal);}catch(e){tmpReplaceVal=escape(tmpReplaceVal)}
				if(flashDynamic) flashFileName += "?"+tmpTargetVal+"="+tmpReplaceVal;
				// Set flashbanner HTML
				flashHTML = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="'+(window.location.protocol=="https:"?"https":"http:")+'//fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="770" height="47" align="middle" id="flashSectionBanner">'; // CHECK
				flashHTML += '<param name="allowScriptAccess" value="sameDomain" />';
				flashHTML += '<param name="movie" value="'+crsc+'/crsc/images/'+flashFileName+'" />';
				flashHTML += '<param name="quality" value="high" />';
				flashHTML += '<param name="scale" value="noscale" />';
				flashHTML += '<param name="salign" value="lt" />';
				flashHTML += '<param name="bgcolor" value="#ffffff" />';
				flashHTML += '<param name="wmode" value="opaque" />';
				flashHTML += '<embed swliveconnect="true" name="flashSectionBanner" src="'+crsc+'/crsc/images/'+flashFileName+'" quality="high" bgcolor="#ffffff" width="770" height="47" align="middle"  type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" wmode="opaque" />';
				flashHTML += '</object>';
				// Replace image by flash sectiobanner
				objSection.innerHTML = "";
				objSection.innerHTML = flashHTML;
			}
		}
		if(showImage) sE(objSection);
	}
};

// Function which iniates replace of sectionbanner depending on cookie
function initSectionBanner() {
	var shFlashBanner, cookieName, tmpSection, otherSection, urlLocation, tmpLocale, cookieVal, subCookieExists, cookieArray, subArray, subSection, subLocale, url, i;
	shFlashBanner = false;
	cookieName = "flashbanner";
	tmpSection = currSection.toLowerCase();	// Define tmp section
	if(_page.hideFlashSectionBanner == false) {
		if ((tmpSection == "about" || tmpSection == "consumer" || tmpSection == "medical"  || tmpSection == "lighting"  || tmpSection == "fifa" || _page.showSBFlashSectionBanner!="") 
		&& (_page.locale!="cn_en" && _page.locale!="cn_zh")		// disabled for china
		&& (!_page.browser.isOpera)){									// disabled for opera browsers e.g. 8.0 causes error; object error detection not possible
			// Allow specialized business flash banner
			if(_page.showSBFlashSectionBanner!="") tmpSection = _page.showSBFlashSectionBanner; 
			// Check if section is search, based on url's
			otherSection = new Array();
			urlLocation = "";
			// Use error handling to prevent security issues within winxp IE6.
			try {
				urlLocation = escape(window.location);
			} catch(e) {
			}
			otherSection["www.search.philips.com"] = "search";
			otherSection["www.consumer.philips.com/consumer/search"] = "search";
			for (url in otherSection) {
				if(urlLocation.indexOf(url) != -1) {
					tmpSection = "search";
					break;
				}
			}			
			// Get cookie
			tmpLocale = _page.locale;
			cookieVal = readCookie(cookieName);
			if(cookieVal) {
				subCookieExists = false;
				cookieArray = cookieVal.split("--");
				// Check for each value in cookie, if section/locale combination exists
				for(i=0;i<cookieArray.length;i++) {
					subArray = cookieArray[i].split("||");
					subSection = (typeof(subArray[0])!="undefined"?subArray[0]:"");
					subLocale = (typeof(subArray[1])!="undefined"?subArray[1]:"");
					if(subSection.indexOf(tmpSection) != -1 && subLocale.indexOf(tmpLocale) != -1) {
						subCookieExists = true;
					} 
				}
				// Append section/locale to cookie
				if(subCookieExists == false) {
					createCookie(cookieName,cookieVal+="--"+tmpSection+"||"+tmpLocale)
					shFlashBanner = true;
				}
			} else {
				// Set cookie(section/locale) and show flashbanner
				createCookie(cookieName,tmpSection+"||"+tmpLocale)
				shFlashBanner = true;
			}
		}
	}	
	replaceSectionBanner(shFlashBanner,tmpSection);	
};

function activateActiveX() {
	var _nodes, _tag, _objects, _params, x, i,j,_object,_child;
	if(_page.browser.isIE && !_page.browser.isMac) {
		_nodes = ["embed","object"];
		for (x = 0; x < _nodes.length; x++) {
			_tag = _nodes[x];
			_objects = document.getElementsByTagName(_tag);
			for (i = 0; i < _objects.length; i++) {
				_object = _objects[i];
				_params = '';
				for (j = 0; j<_object.childNodes.length; j++) {
					_child = _object.childNodes[j];
					if (_child.tagName == "PARAM") _params += _child.outerHTML;		       
				}
				//The tag with the attributes, the params and it's inner html	
				_object.outerHTML = _object.outerHTML.split(">")[0] + '>' + _params + _object.innerHTML +'</'+_tag.toUpperCase()+'>';
			}
		}	
		_page.activeXCSS.remove() // Show all objects
	}
}

getSpecialCaseAction = function(objCompare, arrTmpClass) {
	var strStyleCur, strAction;
	// Current object
	strStyleCur = "";
	strAction = (typeof arrTmpClass == "string"?arrTmpClass:"");
	// Get parent objects
	while (objCompare.offsetParent && strAction=="") {
		objCompare = objCompare.offsetParent;
		strStyleCur = getStyle(objCompare);
		if(arrTmpClass[strStyleCur]) {
			if(typeof arrTmpClass[strStyleCur] == "string") {
				strAction = arrTmpClass[strStyleCur];
			} else {
				arrTmpClass = arrTmpClass[strStyleCur];	
			}
		}			
	}
	return strAction;
}

// Function which replaces exceptions on upper- and lowercasing
replaceSpecialCase = function(sObject, sMethod, sAttribute) {
	var strTmpValue, bContinue, strTarget, strSource, i;
	if(sObject) {
		strTmpValue = sObject[sAttribute];
		bContinue = true;
		// Catch unsupported encodeURI error's, like Win IE 5.0 / Mac IE 5+
		try { encodeURI(""); } catch(e) { bContinue = false; };
		if(bContinue) {			
			// Replace values
			strTmpValue = encodeURI(strTmpValue);
			for(i=0;i<_page.arrLCase.length;i++) {
				// Set type switch
				switch(sMethod){
				case "ucase":
					strTarget = _page.arrLCase[i];
					strSource = _page.arrUCase[i];
					break;
				case "lcase":
					strTarget = _page.arrUCase[i];
					strSource = _page.arrLCase[i];					
					break;
				}
				strTmpValue = strTmpValue.replace(strTarget,strSource,"g");
			}
			strTmpValue = decodeURI(strTmpValue);
		}
		switch(sMethod){	
		case "ucase":
			strTmpValue = strTmpValue.toUpperCase();
			break;
		case "lcase":
			strTmpValue = strTmpValue.toLowerCase();
			break;
		}
		sObject[sAttribute] = strTmpValue;
	}
};
	
function processTables(){	
	// Process tables
	var allTables, intTableCount = 0, tmpTableObj, maxRows, intRow, bActivated, curRow, k, j, i;
	allTables = document.getElementsByTagName("table");
	for(k=0;k<allTables.length;k++){
		if(getStyle(allTables[k]) == "p-tab-multiple" || getStyle(allTables[k]) == "p-tab-double") {
			allTables[k].type = getStyle(allTables[k]);
			allTables[k].id="table_content"+(intTableCount+1);
			tabTables[intTableCount] = allTables[k];
			intTableCount++;
		}
	}
	intTableCount=0;
	for(j=0;j<tabTables.length;j++){
		//Create a handle to the table.
		tmpTableObj=tabTables[j];
		//Increase the table counter.
		intTableCount++;
		//Create the tabs for all tabbed tables.
		_page.createTabs(intTableCount, tmpTableObj);
		// Set active tab
		maxRows = tmpTableObj.rows.length;
		intRow = 0;
		bActivated = false;
		for(i=0;i<maxRows;i++) {
			curRow = tmpTableObj.rows[i];
			// Only process child rows, no nested table/rows (Opera compat. issue)
			if(curRow.parentNode.parentNode.id == tmpTableObj.id) {
				if(getStyle(curRow) == "active") {_page.showTab(intTableCount,intRow);bActivated = true}
				intRow++;
			} else {
				maxRows++;
			}
		}
		if(bActivated == false) _page.showTab(intTableCount,0);
	}
};

// Add onload event
function addOnLoadEvent(fn) {
	arrLoad[arrLoad.length] = fn;
};

// Add DOM onload event fired by end of footer
function addDOMOnLoadEvent(fn) {
	arrDOMLoad[arrDOMLoad.length] = fn;
};

// Generic onload handler
function onloadHandler() {
	var k, existing;
	// Do DOM onload event requests
	for(k=0;k<arrDOMLoad.length;k++) {
		try{arrDOMLoad[k]()}catch(err){};
	}
	// Load all arrays
	function doLoad(evt) {
		for(k=0;k<arrLoad.length;k++) {
			try{arrLoad[k]()}catch(err){};
		}
	}
	//Setup onload function
	if(typeof window.addEventListener != 'undefined') {
			//.. gecko, safari, konqueror and standard
			window.addEventListener('load', function(){}, false); // Dummy function inorder to prevent removal of doLoad listner
			window.addEventListener('load', doLoad, false);
	} else if(typeof document.addEventListener != 'undefined') {
			//.. opera 7
			document.addEventListener('load', doLoad, false);
	} else if(typeof window.attachEvent != 'undefined') {
			//.. win/ie
			window.attachEvent('onload', doLoad);
	} else { 
			//.. mac/ie5 and anything else that gets this far
			//if there's an existing onload function
			if(typeof window.onload == 'function') {
				//store it
				existing = onload;
				//add new onload handler
				window.onload = function() {
					//call existing onload function
					existing();
					//call generic onload function
					doLoad();
				};
			} else {
				//setup onload function
				window.onload = doLoad;
			}
	}
};

/*
*****************************
****** Helper functions *****
*****************************
*/
// 1k DHTML API - standards version
function gE(e,f){if(l){var V,W,t;f=(f)?f:self;V=f.document.layers;if(V){if(V[e])return V[e];for(W=0;W<V.length;)t=gE(e,V[W++]);return t;}}if(d.getElementById)return d.getElementById(e);if(d.all)return d.all[e];else return null;};
function sE(e){l?e.visibility='show':e.style.visibility='inherit';};
function hE(e){l?e.visibility='hide':e.style.visibility='hidden';};
function dE(e){e.style.display='block';};
function nE(e){e.style.display='none';};
function sZ(e,z){l?e.zIndex=z:e.style.zIndex=z;};
function sX(e,x){l?e.left=x:op?e.style.pixelLeft=x:e.style.left=x+px;};
function sY(e,y){l?e.top=y:op?e.style.pixelTop=y:e.style.top=y+px;};
function sW(e,w){l?e.clip.width=w:op?e.style.pixelWidth=w:e.style.width=w+px;};
function gW(e){if(l){return e.clip.width}else if(op){return e.style.pixelWidth}else{return e.style.width;}};
function sH(e,h){l?e.clip.height=h:op?e.style.pixelHeight=h:e.style.height=h+px;};
function sC(e,t,r,b,x){var X;l?(X=e.clip,X.top=t,X.right=r,X.bottom=b,X.left=x):e.style.clip='rect('+t+px+' '+r+px+' '+b+px+' '+x+px+')';};
function wH(e,h){if(l){var Y=e.document;Y.open();Y.write(h);Y.close();}if(e.innerHTML)e.innerHTML=h;};
// Additions
function goW(e){return(e.clip?e.clip.width:e.offsetWidth)};
function goH(e){return(e.clip?e.clip.height:e.offsetHeight)};
function gsW(){return(screen.availWidth?screen.availWidth:screen.width)};
function gsH(){return(screen.availHeight?screen.availHeight:screen.height)};

// This function applies the style-class 'className' to the element 'elementId'
function applyStyle(element, className) {
	if(element)
		element.className = className;
};

// This function returns the current style of the element
function getStyle(element) {
	return (element ? element.className : "");
};

// This function returns the x-pos of 'obj'
function findPosX(obj) {
	var curleft = 0;
	if(obj != null) {
		if (obj.offsetParent) {			
			while (obj.offsetParent) {
				curleft += obj.offsetLeft;
				obj = obj.offsetParent;
			}
		}
		else if (obj.x) curleft += obj.x;
	}
	return curleft;
};

// This function returns the y-pos of 'obj'
function findPosY(obj) {
	var curtop = 0;
	if(obj != null) {
		if (obj.offsetParent) {
			while (obj.offsetParent) {
				curtop += obj.offsetTop;
				obj = obj.offsetParent;
			}
		}
		else if (obj.y)	curtop += obj.y;
	}
	return curtop;
};

// Returns top positon in scrolled browser window
function getScrollPosTop(){
	var pos="";
	if( typeof(self.pageYOffset)!="undefined" ){ pos = self.pageYOffset; }
	else if( document.documentElement && document.documentElement.scrollTop ) { pos = document.documentElement.scrollTop; }
	else if( document.body ) { pos = document.body.scrollTop; }
	return pos;	
};   

// Returns available height browser window
function getScreenHeight(){
	var pos="";
	if( typeof(self.innerHeight)!="undefined" ){ pos = self.innerHeight; }
	else if( document.documentElement && document.documentElement.clientHeight ){ pos = document.documentElement.clientHeight; }
	else if ( document.body ){ pos = document.body.clientHeight; }
	return pos;
};

// Returns available height browser window
function getScreenWidth(){
	var pos="";
	if( typeof(self.innerWidth)!="undefined" ){ pos = self.innerWidth; }
	else if( document.documentElement && document.documentElement.clientWidth ){ pos = document.documentElement.clientWidth; }
	else if ( document.body ){ pos = document.body.clientWidth; }
	return pos;
};

// Flash detection
function FlashDetect() {
	var flashInstalled, flashVersion, MSDetect, flash, i, x, y;
	flashInstalled = 0;				// 0 = not installed, 1 = unknown, 2 = installed 
	flashVersion = 0;				// Flash version, default 0
	MSDetect = "false";				// MS IE detection, default false
	if (navigator.plugins && navigator.plugins.length)	{
		x = navigator.plugins["Shockwave Flash"];
		if (x)	{
			flashInstalled = 2;
			if (x.description)	{
				y = x.description;
				flashVersion = y.charAt(y.indexOf('.')-1);
			}
		} else {
			flashInstalled = 1;
		}
		if (navigator.plugins["Shockwave Flash 2.0"])	{
			flashInstalled = 2;
			flashVersion = 2;
		}
	} else if (navigator.mimeTypes && navigator.mimeTypes.length)	{
		x = navigator.mimeTypes['application/x-shockwave-flash'];
		if (x && x.enabledPlugin) {
			flashInstalled = 2;
		} else {
			flashInstalled = 1;
		}
	} else {
		MSDetect = "true";
	}
	// MS IE detect
	if(MSDetect == "true") {
		for(i=9; i>0; i--){
			flashVersion = 0;
			try{
				flash = new ActiveXObject("ShockwaveFlash.ShockwaveFlash." + i);
				flashVersion = i;
				flashInstalled = 2;
				break;
			}
			catch(e){
			}
		}
	}
	return [flashInstalled, flashVersion];
};

// This function performs an extensive browser detection and stores 
// all data in an object for later use.		
function BrowserDetect() {
	var ua = navigator.userAgent.toLowerCase(); 
	// browser engine name
	this.isGecko       = (ua.indexOf('gecko') != -1 && ua.indexOf('safari') == -1);
	this.isAppleWebKit = (ua.indexOf('applewebkit') != -1);
	// browser name
	if(ua.indexOf('opera') != -1) {this.isOpera = true; this.name = "Opera"};
	if((ua.indexOf('msie') != -1 && !this.isOpera && (ua.indexOf('webtv') == -1) )) {this.isIE=true; this.name = "Internet Explorer"};
	if(this.isGecko && ua.indexOf('gecko/') + 14 == ua.length) {this.isMozilla=true; this.name = "Mozilla"};
	if((this.isGecko) ? (ua.indexOf('netscape') != -1) : ( (ua.indexOf('mozilla') != -1) && !this.isOpera && !this.isSafari && (ua.indexOf('spoofer') == -1) && (ua.indexOf('compatible') == -1) && (ua.indexOf('webtv') == -1) && (ua.indexOf('hotjava') == -1) )) {this.isNS=true; this.name = "Netscape"};
	if(ua.indexOf('firebird/') != -1) {this.isFirebird=true; this.name = "Firebird"};
	if(ua.indexOf('firefox/') != -1) {this.isFirefox=true; this.name = "FireFox"};
	if(ua.indexOf('safari/') != -1) {this.isSafari=true; this.name = "Safari"};
	if(ua.indexOf('konqueror') != -1) {this.isKonqueror=true; this.name = "Konqueror"};
	if(ua.indexOf('omniweb') != -1) {this.isOmniweb=true; this.name = "Omniweb"};
	if(ua.indexOf('webtv') != -1) {this.isWebtv=true; this.name = "WebTV"};
	if(ua.indexOf('icab') != -1) {this.isICab=true; this.name = "Icab"};
	if(ua.indexOf('camino') != -1) {this.isCamino=true; this.name = "Camino"};
	// spoofing and compatible browsers
	this.isIECompatible = ( (ua.indexOf('msie') != -1) && !this.isIE);
	this.isNSCompatible = ( (ua.indexOf('mozilla') != -1) && !this.isNS && !this.isMozilla);
	// rendering engine versions
	this.geckoVersion = ( (this.isGecko) ? ua.substring( (ua.lastIndexOf('gecko/') + 6), (ua.lastIndexOf('gecko/') + 14) ) : -1 );
	this.equivalentMozilla = ( (this.isGecko) ? parseFloat( ua.substring( ua.indexOf('rv:') + 3 ) ) : -1 );
	// browser version
	this.versionMinor = parseFloat(navigator.appVersion); 
	// correct version number
	if (this.isGecko && !this.isMozilla) {
		if(this.isFirefox) {
			this.versionMinor = parseFloat(ua.substring(ua.indexOf('firefox/')+8,ua.length));
		} else {
			this.versionMinor = parseFloat( ua.substring( ua.indexOf('/', ua.indexOf('gecko/') + 6) + 1 ) );
		}
	}
	else if (this.isMozilla) this.versionMinor = parseFloat( ua.substring( ua.indexOf('rv:') + 3 ) );
	else if (this.isIE && this.versionMinor >= 4) this.versionMinor = parseFloat( ua.substring( ua.indexOf('msie ') + 5 ) );
	else if(this.isSafari) this.versionMinor = parseFloat( ua.substring( ua.indexOf('safari/') + 7) );
	else if(this.isOmniweb) this.versionMinor = parseFloat(ua.substring( ua.indexOf('omniweb/v') + 9));
	else if(this.isOpera && !this.isMac) this.versionMinor = parseFloat(ua.substring( ua.indexOf('opera') + 6));
	this.versionMajor = parseInt(this.versionMinor); 
	// dom support 
	this.isDOM = (document.getElementById && document.createElement?true:false);
	this.isDOM1 = (document.getElementById?true:false);
	this.isDOM2Event = (document.addEventListener && document.removeEventListener?true:false);
	// dhtml support
	this.isDHTML = (document.getElementById || document.all || document.layers?true:false);
	// css compatibility mode
	this.mode = document.compatMode ? document.compatMode : 'BackCompat';
	// platform
	if(ua.indexOf('win') != -1) {this.isWin=true; this.platform="win"}
	if(this.isWin && ( ua.indexOf('95') != -1 || ua.indexOf('98') != -1 || ua.indexOf('nt') != -1 || ua.indexOf('win32') != -1 || ua.indexOf('32bit') != -1 || ua.indexOf('xp') != -1)){this.isWin32=true; this.platform = "win32"}
	if(ua.indexOf('mac') != -1){this.isMac=true; this.platform = "mac"}
	if(ua.indexOf('x11') != -1){this.isMac=true; this.platform = "unix"}
	if(ua.indexOf('linux') != -1){this.isMac=true; this.platform = "linux"}
	// specific browser shortcuts
	this.isNS6x = (this.isNS && this.versionMajor == 6);
	this.isNS6up = (this.isNS && this.versionMajor >= 6);
	this.isNS7x = (this.isNS && this.versionMajor == 7);
	this.isNS7up = (this.isNS && this.versionMajor >= 7);
	this.isIE5x = (this.isIE && this.versionMajor == 5);
	this.isIE55 = (this.isIE && this.versionMinor == 5.5);
	this.isIE5up = (this.isIE && this.versionMajor >= 5);
	this.isIE6x = (this.isIE && this.versionMajor == 6);
	this.isIE6up = (this.isIE && this.versionMajor >= 6);
	this.isIE7up = (this.isIE && this.versionMajor >= 7);
};

// Function which removes all tags from string
function ReplaceTags(xStr){
	var regExp = /<\/?[^>]+>/gi;
	return xStr.replace(regExp,"");
};		

// This function determines the path to the global CRSC server.
function get_crsc_server() {
	// Get all script elements in page
	var script_files, i, global_location, global_id;
	script_files = document.getElementsByTagName("SCRIPT");
	for(i=0;i<script_files.length;i++){
		//Loop through all script elements
		global_location = script_files[i].src;
		global_id = global_location.indexOf('/crsc/scripts/lib_global');
		if(global_id!=-1){
			// Get location for Common Resources
			return global_location.substring(0,global_id);
		}
	}
};

// This function determines the path to the global CRSC NAV server.
function get_crsc_nav_server() {
	var crsc_server = _page.crsc_nav_server || get_crsc_server();
	// If crsc domain found respect domain, i.e. www.staging.crsc.philips.com
	return ( crsc_server.indexOf('.crsc.philips.com') !=-1 ? crsc_server :(window.location.protocol=="https:"?"https:":"http:") + "//www.crsc.philips.com" )
};

function getLanguageSwitch(obj) {
	var language_switch = '', start_pos, last_pos;
	if(obj){
		if(obj.indexOf("language=")!=-1){
			start_pos = obj.indexOf("language=");
			last_pos = obj.indexOf(",", start_pos);
			if(last_pos==-1){
				// No options left, so take maximum length
				last_pos = obj.length;
			}
			// get language
			language_switch = obj.substr(start_pos+9, last_pos-start_pos-9);
		}				
	}
	return language_switch;	
}

function replaceAll(streng, soeg, erstat) { 
	var st = streng, idx;
	if (soeg.length == 0) return st;
	idx = st.indexOf(soeg);
	while (idx >= 0){  st = st.substring(0,idx) + erstat + st.substr(idx+soeg.length);
		 idx = st.indexOf(soeg);
	}
	return st;
};

function trim(s) {
	// Remove leading spaces and carriage returns
	while ((s.substring(0,1) == ' ') || (s.substring(0,1) == '\n') || (s.substring(0,1) == '\r')) {
		s = s.substring(1,s.length);
	};
	// Remove trailing spaces and carriage returns
	while ((s.substring(s.length-1,s.length) == ' ') || (s.substring(s.length-1,s.length) == '\n') || (s.substring(s.length-1,s.length) == '\r')) {
		s = s.substring(0,s.length-1);
	}
	return s;
};

// This function sort the locale list
function SortSelectList(e){
	// Will not work on IE5 on Mac
	var n = e.length, i, j, sz;
	if(!(_page.browser.isMac && _page.browser.isIE5x)){
		for (i=2; i < n; i++){ //Skip first and second item (Choose country/language and Global)
			for (j=i+1; j < n; j++){
				if (e.options[j].text < e.options[i].text){
					if (_page.browser.isIE){  
						// Swap nodes
						e.options[i].swapNode(e.options[j]);
					}else{
						// Swap values
						sz = e.options[i].text;
						e.options[i].text = e.options[j].text;
						e.options[j].text = sz;
						sz = e.options[i].value;
						e.options[i].value = e.options[j].value;
						e.options[j].value = sz;
					}
			   }
			}
		}
	}
};

// This functions set the selected locale entry in the localelist
function setSelectListLocale(locale) {
	// Skip first 2 entries
	for(var i=2;i<document.changelanguage.locale.length;i++) {
		if(document.changelanguage.locale.options[i].value == locale) document.changelanguage.locale.selectedIndex = i;
	}
};

// Has element method
hasElement = function(obj,elem) {
	for(var i=0;i < obj.length;i++)
		if(obj[i]==elem)
			return true;
	return false;
}

/* Apply Active-X fix */
function includeActiveXFix() {
	if(_page.browser.isIE && !_page.browser.isMac) {					// Only IE and not Mac
		_page.activeXCSS = new _page.stylesheet(); 
		_page.activeXCSS.add('object,embed{display:none};') // Hide all objects
		addOnLoadEvent(activateActiveX)
	}
}

function includeStockquotes(){
	if (window.location.protocol === "http:") {
		objBody = document.getElementsByTagName('body').item(0);
		objScript = document.createElement('script');
		objScript.src =  _page.externalUrlPrefix.stockQuotes + "/asp/ir/philips_java.aspx";
		objScript.type = 'text/javascript';
		objBody.appendChild(objScript);	
	}
};

function includeOmniture() {
	var protocol, omniture;
	if(_page.loadOmniture == true) {
		protocol = (window.location.protocol=="https:" || window.location.protocol=="http:"?window.location.protocol:"http:"); // only allow http and https
		omniture = "<scri"+"pt type='text/javascript' src='"+protocol+"//www.crsc.philips.com/crsc/scripts/s_code_philipsglobal.js'></scr"+"ipt>";
		document.write(omniture);
	}	
};

function includeSIFR() {
	/* Available options
	default (no options set) 			// SIFR script and config is loaded only for the locales which are not in the _page.disabledLocalesSIFR array
	_page.loadSIFR = false;			// Doesn't load SIFR script and config files at all
	_page.loadSIFRScript = true; 		// Loads the base SIFR script file for all locales without any respects to the locales
	_page.loadSIFRConfig = false;	// Doesn't load the SIFR config file (for GMM header replacement)
	*/
	var strSIFR, strLanguage, replaceHeader, loadscript, loadconfig;
	strSIFR = "";
	strLanguage = _page.locale.split("_")[1];
	replaceHeader = !hasElement(_page.disabledLocalesSIFR,strLanguage);
	loadscript = false;
	loadconfig = false;
	loadscript = (_page.loadSIFR==false?false:replaceHeader);
	if(loadscript || _page.loadSIFRScript) {
		strSIFR += "<scri"+"pt language='JavaScript' type='text/javascript' src='" + _page.sIFR.js.core.src + "'></scr"+"ipt>";
	}
	loadconfig = (loadscript && replaceHeader?true:false);
	if(loadconfig && _page.loadSIFRConfig) {
		strSIFR += "<scri"+"pt language='JavaScript' type='text/javascript' src='" + _page.sIFR.js.config.src + "'></scr"+"ipt>";
	}
	document.write(strSIFR);
};

// Extend function class with bindArguments method 
Function.prototype.bindArgs = function (scope, args, event) {
	var reference = this;
	return function (e) {
		reference.apply(scope, (event ?(args || []).concat([(e || window.event)]): (args || arguments) )); // Only append event as last element when args and event has been set.
	}
};

// Backwards compatibility push array
if (typeof Array.prototype.push !== "function") {
	Array.prototype.push = ArrayPush;function ArrayPush (value) {this[this.length] = value;}
}
