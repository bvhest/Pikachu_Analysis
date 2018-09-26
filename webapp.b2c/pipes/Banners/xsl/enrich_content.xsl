<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="target">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <!-- enrich with content specs -->
      <xsl:variable name="target-name" select="@name"/>
      <xsl:variable name="locale" select="ancestor::content/locale/text()"/>
      <xsl:variable name="language" select="ancestor::content/language/text()"/>
      <xsl:variable name="specs" select="/root/content-specs/root/sheet/row[cell[@name='Name']/text()=$target-name]"/>
      
      <xsl:attribute name="type" select="$specs/cell[@name='Type']/text()"/>
      <xsl:attribute name="duration" select="$specs/cell[@name='Duration']/text()"/>
      <xsl:attribute name="group" select="$specs/cell[@name='Location']/text()"/>
      
      <!-- Tab name comes from translations sheet 'Tabnames' and is keyed by language -->
      <xsl:attribute name="tabname" select="/root/translations/text/root/sheet[@name='Tabnames']/row[cell[@name='Name']/text()=$target-name]/cell[@name=$language]/text()"/>
      <xsl:if test="$specs/cell[@name='Type'] = 'swf'">
        <xsl:apply-templates select="$specs/cell[fn:starts-with(@name, 'TextElement_')]">
          <xsl:with-param name="target-name" select="$target-name"/>
          <xsl:with-param name="locale" select="$locale"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$specs/cell[@name='Type'] = 'jpg'">
        <url>
          <xsl:value-of select="/root/translations/url/root/sheet/row[cell[@name='Name']/text() = $target-name]/cell[@name=$locale]/text()"/>
        </url>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cell[starts-with(@name, 'TextElement_')]">
    <xsl:param name="target-name"/>
    <xsl:param name="locale"/>
    <xsl:param name="language"/>
    <xsl:variable name="text-name" select="@name"/>
    <xsl:variable name="text-type" select="fn:normalize-space(text())"/>
    <xsl:variable name="text-index" select="fn:substring-after(@name, '_')"/>
    <xsl:choose>
      <xsl:when test="fn:lower-case($text-type) = 'findoutmore'">
        <!-- URL: get value from translations/url -->
        <url>
          <xsl:value-of select="/root/translations/url/root/sheet/row[cell[@name='Name']/text() = $target-name]/cell[@name=$locale]/text()"/>
        </url>
      </xsl:when>
      <xsl:when test="fn:lower-case($text-type) != 'x' and fn:string-length($text-type) > 0">
        <!-- text: get value from translations/text -->
        <xsl:variable name="text-element"
                      select="/root/translations/text/root/sheet[@name=$text-name]/row[cell[@name='Name']/text() = $target-name]"/>
        <text type="{$text-type}"
              color="{$text-element/cell[fn:lower-case(@name)='color']/text()}"
              fontSize="{$text-element/cell[fn:lower-case(@name)='fontsize']/text()}">
          <xsl:value-of select="$text-element/cell[@name=$language]/text()"/>
        </text>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="content-specs|translations"/>

  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
