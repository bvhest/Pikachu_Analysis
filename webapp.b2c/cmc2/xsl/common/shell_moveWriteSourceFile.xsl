<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="targetDir"/>

  <!-- Move files that have been written by a source-write transformer (<source>) to $targetDir -->  
  <!-- Example sitemap implementation:
  
        <map:transform type="write-source"/>
        <map:transform src="{cmc2:xslDir}/common/shell_moveWriteSourceFile.xsl">
          <map:parameter name="targetDir" value="{cmc2:gdir}/{1}/inbox"/>
        </map:transform>        
        <map:transform type="shell"/>
   -->  
  
  
  
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="source">
    <xsl:variable name="source">
      <xsl:analyze-string select="." regex="^(.*)/(..*)$">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(2)"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="'ERROR'"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>         
    </xsl:variable>
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="."/></shell:source>
      <shell:target><xsl:value-of select="concat($targetDir,'/',$source)"/></shell:target>
    </shell:move>
  </xsl:template>

</xsl:stylesheet>