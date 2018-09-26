<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id">0</xsl:param>

  <xsl:template match="/root">
  <html>
	<body contentID="content">
	<h2>Pika-Chu locale language map</h2><hr/>
	<table>
	<tr>
	    <td width="100">Locale</td>
	    <td width="100">Country</td>
	    <td width="100">Translation Locale code</td>
	    <td width="100">CCR Language code</td>
	    <td width="100">Needs Translation</td>
	    <td>Language name</td>
	</tr>  
	<xsl:apply-templates/>
	</table>
	</body>
  </html>
  </xsl:template>
  
  <xsl:template match="sql:row">
	<tr>
	    <td><xsl:value-of select="sql:locale"/></td>
	    <td><xsl:value-of select="sql:country"/></td>
	    <td><xsl:value-of select="sql:languagecode"/></td>
	    <td><xsl:value-of select="sql:language"/></td>
	    <td><xsl:value-of select="sql:translationflag"/></td>
	    <td><xsl:value-of select="sql:name"/></td>
	</tr>  
  </xsl:template>
</xsl:stylesheet>