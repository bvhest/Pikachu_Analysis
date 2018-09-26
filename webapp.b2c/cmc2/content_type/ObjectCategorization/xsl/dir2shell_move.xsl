<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceDir"/>
  <xsl:param name="targetDir"/>
  <xsl:param name="filename"/>

  <xsl:template match="/">
    <page>
      <xsl:apply-templates select="//dir:file"/>
    </page>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:if test="starts-with(@name,$filename)">  
      <shell:move overwrite="true">
        <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
        <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
      </shell:move>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>