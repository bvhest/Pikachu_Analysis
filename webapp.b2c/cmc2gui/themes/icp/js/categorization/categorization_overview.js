function icp_init_view_categorization_overview() {
	// Register onclick for toggling a node
	$("p.cattreenode .toggle").click(function() {
		toggleNode($(this).parent());
	});
	
	// Register onclick for recursiveley expaning and collapsing a node
	$("p.cattreenode .toggleAll").click(function() {
		var opened = toggleNode($(this).parent());
		if (!opened)
			collapse($(this).parent().next(".cattreenode_children").eq(0).find("p.cattreenode"));
		else
			expand($(this).parent().next(".cattreenode_children").eq(0).find("p.cattreenode"));
	});
}

function toggleNode(jqSel) {
	jqSel.next(".cattreenode_children").eq(0).toggle("normal");
	return updateToggler(jqSel.children(".toggle"));
}
function openNode(jqSel) {
	jqSel.next(".cattreenode_children").eq(0).show();
	return updateToggler(jqSel.children(".toggle"), true);
}
function closeNode(jqSel) {
	jqSel.next(".cattreenode_children").eq(0).hide();
	return updateToggler(jqSel.children(".toggle"), false);
}

function updateToggler(toggler, openIt) {
	var opened;
	if (toggler.html() == "►" && ((arguments.length > 1 && openIt == true) || arguments.length == 1)) {
		toggler.html("▼");
		opened = true;
	} else if (toggler.html() == "▼" && ((arguments.length > 1 && openIt == false) || arguments.length == 1)) {
		toggler.html("►");
		opened = false;
	}
	return opened;
}

function collapse(jqSel) {
	jqSel.queue(function() {
		closeNode($(this));
		$(this).dequeue()
	});
}

function expand(jqSel) {
	jqSel.queue(function() {
		openNode($(this));
		$(this).dequeue()
	});
}

$(document).ready(icp_init_view_categorization_overview);
