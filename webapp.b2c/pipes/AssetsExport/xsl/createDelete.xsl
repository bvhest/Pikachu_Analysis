<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:param name="fn"/>

  <xsl:template match="/root">
  	<xsl:element name="delete">
  		<xsl:value-of select="$fn"/>
  	</xsl:element>
  </xsl:template>
</xsl:stylesheet>