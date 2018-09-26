<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="destination"/>
  <!-- -->
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:file"/>
    </root>      
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <cinclude:include><xsl:attribute name="src">cocoon:/transformXMLToExternalTable/<xsl:value-of select="@name"/>?destination=<xsl:value-of select="$destination"/></xsl:attribute></cinclude:include>
  </xsl:template>
</xsl:stylesheet>