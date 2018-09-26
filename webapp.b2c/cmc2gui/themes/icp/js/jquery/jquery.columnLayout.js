/*
	jquery.columnLayout.js
	
	version:   1.0
	author:    Freek Segers
	copyright: 2009 Philips Consumer Lifestyle
	date:      2009-05-05
*/

(function($) {
	// Private methods
	function insertElementsIntoColumns(jqElements, jqColumns) {
		var curColumn = jqColumns.eq(0);
		var curContainer = curColumn.children("div[columnLayoutWrapper]");
		curColumn.data("columnLayoutLastUsed", true);

		return jqElements.each(function() {
			var $this = $(this);
			var originalParent = $this.parent();
			$this.appendTo(curContainer);
			// Check for overflow
			if (curContainer.height() > curColumn.innerHeight()) {
				if (jqColumns.length >= 2) {
					// Process the remaining selected elements including the last element that
					// caused the overflow.
					curColumn.removeData("columnLayoutLastUsed");
					// Move to next column on next iteration
					// Slice the selected elements to get the remaining list
					var lastIndex = jqElements.index(this);
					insertElementsIntoColumns(jqElements.slice(lastIndex), jqColumns.slice(1));
				} else {
					// Put the element back to where it came from
					$this.prependTo(originalParent);
				}
				// Break from this each loop
				return false;
			}
		});
	};
	
	// Prototype Methods
	$.fn.extend({
		columnLayoutAppendTo: function(columns) {
			// columns is either
			// 1. a jQuery object that contains the column elements
			// 2. an Array with DOM elements that form the columns
			// 3. a String to be used as a jQuery selector to get the column elements
			//
			// All column elements must have a fixed height.
			
			if (columns instanceof Array || typeof(columns) == "string") {
				columns = $(columns);
			}
			
			if (this.length == 0 || columns.length === 0) {
				return;
			}
			
			// Add content wrappers to every columns
			columns.not(":has(div[columnLayoutWrapper])").empty().append("<div columnLayoutWrapper=\"true\"></div>");
			columns.css("overflow", "hidden");
			// Find the last column that was used before, if any.
			var curColIdx = 0;
			columns.each(function() {
				var $this = $(this);
				if (!$this.data("columnLayoutLastUsed")) {
					curColIdx++;
				} else {
					// Break from this each loop
					return false;
				}
			});
			if (curColIdx >= columns.length) {
				// Not found, use first column
				curColIdx = 0;
			}
			
			// Add the selected elements to the columns
			return insertElementsIntoColumns(this, columns.slice(curColIdx));
		}
	});
})(jQuery);