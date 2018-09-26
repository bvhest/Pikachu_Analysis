<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:ws="http://apache.org/cocoon/source/1.0">

  <xsl:param name="output-dir"/>
  <xsl:param name="process"/>
  <xsl:param name="prefix"/>
  
  <xsl:template match="dir:directory">
    <root>
      <xsl:apply-templates select="dir:file/dir:xpath/batch"/>
    </root>
  </xsl:template>
  
  <xsl:template match="batch">
    <ws:write>
      <ws:source>
        <xsl:value-of select="concat($output-dir,'/',$prefix,@number,'.xml')"/>
      </ws:source>
      <ws:fragment>
        <batch number="{@number}">
          <xsl:apply-templates select="i:include"/>
        </batch>
      </ws:fragment>
    </ws:write>
  </xsl:template>
  
  <xsl:template match="i:include">
    <xsl:copy>
      <xsl:attribute name="src" select="replace(@src,'^cocoon:/.*?/',concat($process,'/'))"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>