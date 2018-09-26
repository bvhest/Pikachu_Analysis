<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id">0</xsl:param>

  <xsl:template match="/root">
  <html>
	<body contentID="content">
	<h2>CMC2 locale translations map</h2><hr/>
	<table class="main">
  	<tr>
  		<td width="250">Locale</td>
  	    <td width="150">Division</td>
  	    <td width="150">Source Locale</td>
  	    <td width="150">Target Locale</td>
  	    <td width="150">IsDirect</td>
  	    <td width="150">Enabled</td>
  	</tr>  
	<xsl:apply-templates/>
	</table>
	</body>
  </html>
  </xsl:template>
  
  <xsl:template match="sql:row">
	<tr>
	    <td><xsl:value-of select="sql:locale"/></td>
	    <td><xsl:value-of select="sql:division"/></td>
	    <td><xsl:value-of select="sql:source_locale"/></td>
	    <td><xsl:value-of select="sql:target_locale"/></td>
	    <td><xsl:value-of select="sql:isdirect"/></td>
	    <td><xsl:value-of select="sql:enabled"/></td>
	</tr>  
  </xsl:template>
</xsl:stylesheet>