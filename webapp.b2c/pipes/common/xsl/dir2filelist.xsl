<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" encoding="iso-8859-1" omit-xml-declaration="yes"/>
  
  <xsl:param name="channel">unknown</xsl:param>
  <xsl:param name="exportdate">19700101T0000</xsl:param>

	<xsl:template match="/">
<xsl:text>Files exported on </xsl:text><xsl:value-of select="$exportdate"/><xsl:text> for channel </xsl:text><xsl:value-of select="$channel"/><xsl:text>:
</xsl:text>
    <xsl:apply-templates select="//dir:file"/>
	</xsl:template>

	<xsl:template match="dir:file">
    <xsl:value-of select="@name"/><xsl:text>
</xsl:text>
	</xsl:template>

</xsl:stylesheet>
