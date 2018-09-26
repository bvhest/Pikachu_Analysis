<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dir:directory[empty(ancestor::dir:directory)]">
    <xsl:copy>
      <xsl:attribute name="name" select="'cache'"/>
      <xsl:apply-templates select="dir:directory">
        <xsl:with-param name="parent-path" select="concat('cache/',@name)"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <!-- Keep only dir:file elements -->
  <xsl:template match="dir:directory">
    <xsl:param name="parent-path"/>
    <xsl:apply-templates select="*">
      <xsl:with-param name="parent-path" select="concat($parent-path,'/',@name)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:param name="parent-path"/>
    <xsl:copy>
      <xsl:apply-templates select="@name|@date"/>
      <xsl:attribute name="parent" select="$parent-path"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>