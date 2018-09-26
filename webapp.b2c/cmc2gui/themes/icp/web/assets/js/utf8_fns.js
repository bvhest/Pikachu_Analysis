// some functions to enable posting data independant of browser settings for character encoding
// version : $Id: utf8_fns.js,v 1.1 2004/09/16 14:43:37 wboumans Exp $
// caters for all Browsers

function utf8(wide) {
  var c, s;
  var enc = "";
  var i = 0;
  while(i<wide.length) {
    c= wide.charCodeAt(i++);
    // handle UTF-16 surrogates
    if (c>=0xDC00 && c<0xE000) continue;
    if (c>=0xD800 && c<0xDC00) {
      if (i>=wide.length) continue;
      s= wide.charCodeAt(i++);
      if (s<0xDC00 || c>=0xDE00) continue;
      c= ((c-0xD800)<<10)+(s-0xDC00)+0x10000;
    }
    // output value
    if (c<0x80) enc += String.fromCharCode(c);
    else if (c<0x800) enc += String.fromCharCode(0xC0+(c>>6),0x80+(c&0x3F));
    else if (c<0x10000) enc += String.fromCharCode(0xE0+(c>>12),0x80+(c>>6&0x3F),0x80+(c&0x3F));
    else enc += String.fromCharCode(0xF0+(c>>18),0x80+(c>>12&0x3F),0x80+(c>>6&0x3F),0x80+(c&0x3F));
  }
  return enc;
}

var hexchars = "0123456789ABCDEF";

function toHex(n) {
  return hexchars.charAt(n>>4)+hexchars.charAt(n & 0xF);
}

var okURIchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";

function encodeURIComponentNew(s) {
  var s = utf8(s);
  var c;
  var enc = "";
  for (var i= 0; i<s.length; i++) {
    if (okURIchars.indexOf(s.charAt(i))==-1)
      enc += "%"+toHex(s.charCodeAt(i));
    else
      enc += s.charAt(i);
  }
  return enc;
}

// for formating purposes, here is a >

function encodeData(fld)
{
	if (fld == "") return "";
	var encodedField = "";
	var s = fld;
	if (typeof encodeURIComponent == "function")
	{
		// Use JavaScript built-in function
		// IE 5.5+ and Netscape 6+ and Mozilla
		encodedField = encodeURIComponent(s);
	}
	else 
	{
		// Need to mimic the JavaScript version
		// Netscape 4 and IE 4 and IE 5.0
		encodedField = encodeURIComponentNew(s);
	}
	return encodedField;
}

// processToUTF8FormElements
//
// finds all form elements with the name "xxxRaw" and creates a new "xxx" element with the
// utf-8 encoded data in it as a hidden field
// this ensures that no data is lost due to character encoding problems with Dynamo
// and the client's browsers. The service delegate can automatically decode the data
// where they find "xxx" and "xxxRaw" parameters so all the developer has to do is change the
// jsp to include this function as part of the submit, e.g.
//
// <form id="form1" action="http://your/post/url" method="post">
//   <input type="text" name="text1Raw" /><br />
//   <a href="javascript:encodeToUTF8FormElements('form1'); document.getElementById('form1').submit();">Submit!</a>
// </form>

function encodeToUTF8FormElements(formId) {
  var pageForm = document.forms[formId];

  var formElements = pageForm.elements;
  var numElementsToLoop = formElements.length; // ensure we don't loop beyond initial size
  for (var elementsLoop=0; elementsLoop < numElementsToLoop; elementsLoop++) {
	// check if it matches "xxxRaw", if so, create an "xxx" version, and add it to the form
	var formName = formElements[elementsLoop].name;
	if (formName.lastIndexOf("Raw") == (formName.length - 3) && (formName.length > 3)) {
	  // found one with Raw at end
	  var newElement = document.createElement("input");
	  var elementName = formName.substring(0, formName.length - 3);
	  newElement.setAttribute('id', elementName );
	  newElement.setAttribute('name', elementName );
	  newElement.setAttribute('type', 'hidden' );

	  // encode it to UTF-8
	  newElement.setAttribute('value', encodeData(formElements[elementsLoop].value));
	  pageForm.appendChild(newElement);
	}
  }
}
