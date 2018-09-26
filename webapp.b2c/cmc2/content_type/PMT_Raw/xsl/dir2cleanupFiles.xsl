<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="dir"/>
  <xsl:param name="archive-dir"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates select="dir:file" />
    </root>
  </xsl:template>

  <xsl:template match="dir:file[position() = 1]">
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="concat($dir,'/',@name)" /></shell:source>
      <shell:target><xsl:value-of select="concat($archive-dir,'/',@name)" /></shell:target>
    </shell:move>
  </xsl:template>

  <xsl:template match="dir:file[position() gt 1]">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($dir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>

</xsl:stylesheet>