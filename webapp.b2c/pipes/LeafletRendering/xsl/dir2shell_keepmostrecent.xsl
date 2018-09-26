<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="dir"/>
  
  <xsl:template match="dir:directory">
    <root>
      <xsl:for-each-group select="dir:file" group-by="replace(@name,'(.+\..+)\.\d+\.xml','$1')">
        <xsl:sort select="@name"/>
        <!-- Select the files that have a more recent version -->
        <xsl:apply-templates select="current-group()[position() &lt; last()]"/>
      </xsl:for-each-group>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($dir,'/',@name)"/></shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>