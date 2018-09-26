<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:pikaf="http://www.philips.com/functions/pikachu/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  extension-element-prefixes="pikaf"> 

  <!--
    Get the complete path for a dir:file or dir:directory entry
    IN:   A dir:file element or a dir:directory element
    OUT:  The path of the entry as a string
  -->
  <xsl:function name="pikaf:get-path">
    <xsl:param name="entry"/>
    <xsl:param name="path"/>
    <xsl:choose>
      <xsl:when test="$entry/parent::dir:directory">
        <xsl:value-of select="fn:concat(pikaf:get-path($entry/parent::dir:directory, $path), '/', $entry/@name)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$entry/@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
