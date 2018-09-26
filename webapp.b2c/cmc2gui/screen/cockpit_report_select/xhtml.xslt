<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="section"/>
	<xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
	

	<xsl:template match="/root">	
		<html>
		<body>
		<script>
	<!--document.writeln('<p>hello world</p>'); -->
	
			function verify(f)
			{
				var formOk    = true;
			
				//alert('validating form' + f.name);
				for (var i = 0; i &lt; f.length; i++)
				{
					var e = f.elements[i];
					//alert('Checking field'+e.name);
					if ((e.type=="text") &amp;&amp; (e.value == ""))
					{
					alert("value must be entered");
						e.focus();
						return false;
					}
					if (e.value == "")
					{
					alert("value must be entered");
						e.focus();
						return false;
					}
				 }
			}	
	
			var catalogs = new Array();
			
			function catalog(ctgName)
			{
				this.name = ctgName;
				this.countries = new Array();
			}
			
			function populateCatalogs()
			{
				<xsl:for-each select="/root/sql:rowset[@name='catalogs']/sql:row">
				<xsl:variable name="ctg-name" select="sql:customer_id"/>
					var ctg = new catalog('<xsl:value-of select="$ctg-name"/>');
					<xsl:for-each select="/root/sql:rowset[@name='countries']/sql:row[sql:customer_id=$ctg-name]">
						ctg.countries.push('<xsl:value-of select="sql:country"/>');
					</xsl:for-each>
					catalogs.push(ctg);
				</xsl:for-each>
			}

			populateCatalogs();
			
			
	       function NewList(selObj,newObj) {
			  var selElem = document.getElementById(selObj);
			  var selIndex = selElem.selectedIndex;
			  var selName = selElem.options[selIndex].value;
			  var newElem = document.getElementById(newObj);
			  newElem.options.length = 0;
			  for (var i=0; i &lt; catalogs.length; i++) 
			  {
					var ctg = catalogs[i];
					if (ctg.name ==  selName){
						for (var j = 0; j &lt; ctg.countries.length; j++){
							newElem.options[newElem.options.length] = new Option(ctg.countries[j] ,ctg.countries[j]);
						}
					}
				}
			}
			
		function getFieldByName(myField, exactMatch) {
			  if (!myField) 
			return null;
			  found = false;
			  formElement = null;
			  for (var j=0; (j&lt;document.forms.length) &amp;&amp; !found; j++) {
				  var myForm = document.forms[j];
				  for (var i=0; ( i &lt; myForm.elements.length) &amp;&amp; !found; i++) {
					  formElement = myForm.elements[i];
					  if ((myField.indexOf(formElement.name, 0) > -1) ||
						  (formElement.name.indexOf(myField, 0) > -1)) {
						  found = true;
					  }
				  }
			  }
			  return formElement;
		}
		window.onload=function()
			{
				 NewList('Catalog','Country')
			}

		</script>
				<h2>Cockpit Report Select</h2>
				<form action="{concat($gui_url,$section_url,'cockpit_report_post')}" method="get" enctype="multipart/form-data" onSubmit="return verify(this);" >
					<br/>
					<table>
						<tbody>
							<tr>
								<th>Catalog</th>
								<td>
									<select id="Catalog" name="Catalog" onclick="NewList('Catalog','Country')">
										<xsl:for-each select="sql:rowset[@name='catalogs']/sql:row/sql:customer_id">
										<option value="{.}"><xsl:value-of select="."/></option>
										</xsl:for-each>
									</select>
								</td>
							</tr>
							<tr/>
							<tr/>
							<tr>
								<th>Country</th>
								<td>
									<select id="Country" name="Country">
									</select>
								</td>
							</tr>
							<tr>
								<td/>
								<td/>
								<td>
									<input id="Run" style="width: 137px" type="submit" value="Run"/>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
			<script>
		<!--document.writeln('<p>hello world</p>'); -->
		</script>
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
