<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="/">
      <xsl:apply-templates/>
  </xsl:template>
	<!--  -->
  <xsl:template match="//xhtml:td[@id='guiversion']">
      <td><xsl:value-of select="concat('Gui: ',document('../version.xml')/version/@label)"/></td>
  </xsl:template>
  <xsl:template match="//xhtml:td[@id='engineversion']">
      <td><xsl:value-of select="concat('Engine: ',document('../../pipes/version.xml')/version/@label)"/></td>
  </xsl:template>
	<!--  -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
