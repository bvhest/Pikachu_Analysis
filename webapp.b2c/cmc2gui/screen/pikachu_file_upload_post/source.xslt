<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="source">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  <xsl:variable name="channel">
    <xsl:value-of select="$param1"/>
  </xsl:variable>
  <xsl:variable name="box">
    <xsl:value-of select="$param2"/>
  </xsl:variable>
  <xsl:param name="dir"/>
  <xsl:param name="datafile"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:variable name="name">
      <xsl:call-template name="filename">
        <xsl:with-param name="x" select="$datafile"/>
      </xsl:call-template>
    </xsl:variable>
    <root>
      <source:write>
        <source:source>
          <xsl:value-of select="$dir"/>
          <xsl:value-of select="$channel"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$box"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$name"/>
        </source:source>
        <source:fragment>
          <xsl:apply-templates/>
        </source:fragment>
      </source:write>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template name="filename">
    <xsl:param name="x"/>
    <xsl:choose>
      <xsl:when test="contains($x,'/')">
        <xsl:call-template name="filename">
          <xsl:with-param name="x" select="substring-after($x,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($x,'\')">
        <xsl:call-template name="filename">
          <xsl:with-param name="x" select="substring-after($x,'\')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$x"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
