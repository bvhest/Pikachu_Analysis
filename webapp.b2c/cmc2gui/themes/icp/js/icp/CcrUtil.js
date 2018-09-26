window.CcrUtil = {
	getCcrUrl : function(ccrConfig, objectProperties) {
		var queryString = "id="+objectProperties.id+"&doctype=" + objectProperties.docType;
		var url = ccrConfig.ccrUrl + "?" + queryString;
		if (ccrConfig.ccrIsSecure) {
			url += "&grss=" + MD5(ccrConfig.ccrMagic + queryString);
		}
		return url;
	}
};
