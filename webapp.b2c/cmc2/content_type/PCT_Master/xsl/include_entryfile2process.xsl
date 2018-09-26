<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="process"/>
  <xsl:param name="reload"/>
  <xsl:param name="dir"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <xsl:choose>
      <xsl:when test="not($reload='true')">
        <cinclude:include src="{$process}/{$dir}/{@name}"/>
      </xsl:when>
      <xsl:otherwise>
        <cinclude:include src="{$process}/{$dir}/{@name}?reload=true"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>