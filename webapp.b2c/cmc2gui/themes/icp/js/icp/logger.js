var LogLevel = {
	"ERROR": 1, "WARN": 2, "INFO": 3, "DEBUG": 4
}

// The Logger class
function Logger(type, level, containerId) {
	if (arguments.length > 0)
		this.type = type;
	else
		this.type = "";
		
	if (arguments.length > 1)
		this.logLevel = level;
	else
		this.logLevel = LogLevel.WARN;
		
	containerId = containerId || "logger"
	this.out = $("#"+containerId);
	if (!this.out.data("initialized")) {
		this.out.prepend("<div class=\"title\">Logger</div>")
		this.out.addClass("logger_transparent");
		this.out.hover(
			function() { $(this).removeClass("logger_transparent"); },
			function() { $(this).addClass("logger_transparent"); }
		);
		this.out.children("div.title").click(function() {
			var parent = $(this).parent();
			if (parent.data("collapsed")) {
				parent.height(parent.data("height"));
				parent.data("collapsed", false);
			} else {
				parent.data("height", parent.height());
				parent.height(35);
				parent.data("collapsed", true);
			}
		});
		this.out.data("initialized", true);
	}
}

Logger.prototype.error = function(message) {
	if (this.logLevel >= LogLevel.ERROR) {
		this.log(message);
	}
}
Logger.prototype.warn = function(message) {
	if (this.logLevel >= LogLevel.WARN) {
		this.log(message);
	}
}
Logger.prototype.info = function(message) {
	if (this.logLevel >= LogLevel.INFO) {
		this.log(message);
	}
}
Logger.prototype.debug = function(message) {
	if (this.logLevel >= LogLevel.DEBUG) {
		this.log(message);
	}
}

Logger.prototype.log = function(message) {
	if (typeof(this.out) != "undefined" && this.out != null) {
		var now = new Date();
		var ts = now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds() + "." + now.getMilliseconds();
		this.out.append("<p>" + ts + " - " + this.type + " - " + message + "</p>");
	}
}
