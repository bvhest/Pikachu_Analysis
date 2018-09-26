<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="timestamp"/>
  <xsl:param name="process"/>
  
  <!-- 
    Process the first file in the directory list.
    Copy all dir:file entries for later transformation.
  -->
  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="dir:directory/dir:file"/>
    </root>
  </xsl:template>

  <xsl:template match="dir:file[position()=1]">
    <xsl:copy>
      <xsl:attribute name="name" select="@name"/>
      <i:include src="{$process}/{$timestamp}/{@name}"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dir:file[position() gt 1]">
    <xsl:copy>
      <xsl:attribute name="name" select="@name"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>