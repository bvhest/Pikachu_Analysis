<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="source-dir"/>
  <xsl:param name="target-dir"/>
  
  <xsl:template match="/dir:directory">
    <root name="dir2copyfiles">
      <xsl:apply-templates select="dir:file|dir:directory">
        <xsl:with-param name="parent-dir" select="''"/>
      </xsl:apply-templates>
    </root>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="parent-dir"/>
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="parent-dir"  select="concat($parent-dir, '/', @name)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="parent-dir"/>
    <shell:copy overwrite="true">
      <shell:source><xsl:value-of select="concat($source-dir, $parent-dir, '/' ,@name)" /></shell:source>
      <shell:target><xsl:value-of select="concat($target-dir, $parent-dir, '/' ,@name)" /></shell:target>
    </shell:copy>
  </xsl:template>

</xsl:stylesheet>