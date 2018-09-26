<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:i="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="process"/> 
  <xsl:param name="cache-path"/>
  <xsl:param name="locale"/>

  <xsl:template match="/">
    <root name="{$process}" locale="{$locale}">
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:variable name="ctn" select="tokenize(@name, '\.')[position() = last()-1]" />
    <i:include>
      <xsl:attribute name="src">
        <xsl:value-of select="concat('cocoon:/',$process,'/',@name)" />
        <xsl:if test="$cache-path != ''">
          <xsl:text>?path=</xsl:text>
          <xsl:value-of select="concat($cache-path,'/',$locale,'/',substring($ctn,1,1))" />
        </xsl:if>
      </xsl:attribute>
    </i:include>
  </xsl:template>
</xsl:stylesheet>