if (typeof window.ICPConfig === "undefined")
	window.ICPConfig = {config: {}};

ICPConfig.config.logLevel = LogLevel.DEBUG;
ICPConfig.config.views = {
			"website": {name: "Consumer site"},
			"overview": {name: "Details"},
			"shop": {name: "Online shop"},
			"leaflet": {name: "Leaflet"},
      "awardsandreviews": {name: "Awards/Reviews"}
		};

ICPConfig.config.systems = {
	"tms": {
		"defaultView": "overview"
	},
	"local": {
		"defaultView": "overview"
	}
}

ICPConfig.config.flowPlayerUrl = "flowplayer/flowplayer-3.1.1.swf";

ICPConfig.config.build = "33";

ICPConfig.getConfig = function() {
	return ICPConfig.config;
}
