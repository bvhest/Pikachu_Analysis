<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:param name="sourceDir" as="xs:string" />
  <xsl:param name="targetDir" as="xs:string" />
  <xsl:param name="channel" as="xs:string" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Only move files that are in a subdir to the cache -->
  <xsl:template match="dir:directory/dir:directory/dir:file">
    <file>
      <xsl:apply-templates select="@*"/>
      
      <xsl:if test="@name != 'subcatalog.xml'">
        <shell:move overwrite="true">
          <shell:source>
            <xsl:value-of select="concat($sourceDir,'/',@name)" />
          </shell:source>
          <shell:target>
            <xsl:value-of select="concat($targetDir,'/',@name)" />
          </shell:target>
        </shell:move>
      </xsl:if>
    </file>
  </xsl:template>

</xsl:stylesheet>