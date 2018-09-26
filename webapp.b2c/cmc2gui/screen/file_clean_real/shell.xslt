<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml dir.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir" as="xs:string"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  <xsl:variable name="channel">
    <xsl:value-of select="$param1"/>
  </xsl:variable>
  <xsl:variable name="box">
    <xsl:value-of select="$param2"/>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="//dir:file"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <shell:move overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($dir,$channel,'/',$box,'/',@name)"/>
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($dir,$channel,'/archive/',@name)"/>
      </shell:target>
    </shell:move>
  </xsl:template>
</xsl:stylesheet>
