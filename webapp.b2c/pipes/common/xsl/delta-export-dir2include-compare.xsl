<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0">
  
  <xsl:param name="source-dir"/>
  <xsl:param name="cache-dir"/>
  <xsl:param name="call"/>
  
  <xsl:template match="/dir:directory">
    <root name="delta-export">
      <xsl:apply-templates select="dir:file"/>
    </root>
  </xsl:template>  
  
  <xsl:template match="dir:file">
    <i:include src="{concat($call, '?source=', $source-dir, '/', @name, '&amp;cache=', $cache-dir, '/', @name)}"/>
  </xsl:template>
</xsl:stylesheet>
