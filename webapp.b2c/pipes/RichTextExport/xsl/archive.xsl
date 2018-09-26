<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="sourceDir" as="xs:string"/>
  <xsl:param name="targetDir" as="xs:string"/>
  <!-- -->
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:file"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[dir:xpath]">
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
      <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
    </shell:move>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[not(dir:xpath)]">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
    </shell:delete>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>