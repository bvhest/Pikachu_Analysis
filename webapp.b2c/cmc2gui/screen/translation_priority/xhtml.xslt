<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		
	<!-- -->
	<xsl:template match="/root/sql:rowset">
	<html>
	<body contentID="content">
		<h2>New Translation Priority request - Step 1</h2><hr/>
    <br />
    Specify a CTN and locale:
    <br />
		<form method="POST" id="to_form" name="to_form" enctype="multipart/form-data">
        <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'translation_priority_step2')"/></xsl:attribute>
		<table>
			<tr>
				<td style="width: 180px"><b>CTN</b></td>
				<td style="width: 205px">
					<input name="CTN" size="60" type="text"/>
              </td>
			</tr>
			<tr>
				<td style="width: 180px"><b>Locale</b></td>
				<td style="width: 205px">
					<select name="language">
						<option value="" selected="selected">Select from the following</option>
						<xsl:apply-templates select="./sql:row"/>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td style="width: 180px" />
				<td style="width: 205px">
					<input id="SendChannelData" style="width: 137px" type="submit" value="Submit"/>
				</td>
			</tr>
		</table>
		</form>
	</body>
	</html>
	</xsl:template>

	<xsl:template match="sql:row">
		<option><xsl:attribute name="value" select="sql:locale"/><xsl:value-of select="sql:locale"/></option>
	</xsl:template>
</xsl:stylesheet>
