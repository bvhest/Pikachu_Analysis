<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
>

  <xsl:param name="destDir" />
  <xsl:param name="sourceDir" />

  <xsl:template match="/">
    <root>
      <xsl:if test="count(//dir:file) &gt; 0">
        <xsl:apply-templates select="//dir:file" />
      </xsl:if>
    </root>
  </xsl:template>

  <xsl:template match="dir:file">
    <cinclude:include
          src="cocoon:/splitFile/{@name}?destDir={$destDir}" />
          
     <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>
