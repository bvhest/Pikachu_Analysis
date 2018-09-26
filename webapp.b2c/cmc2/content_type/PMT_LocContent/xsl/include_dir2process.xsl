<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:i="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="process"/> 
  <xsl:param name="cache-path"/>

  <xsl:template match="/">
    <root name="{$process}">
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <i:include>
      <xsl:attribute name="src">
        <xsl:value-of select="concat('cocoon:/',$process,'/',@name)" />
      </xsl:attribute>
    </i:include>
  </xsl:template>
</xsl:stylesheet>