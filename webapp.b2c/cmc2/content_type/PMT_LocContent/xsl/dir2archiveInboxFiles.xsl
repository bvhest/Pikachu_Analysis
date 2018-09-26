<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:my="http://pww.pikachu.philips.com/functions/local"
  extension-element-prefixes="my"
  exclude-result-prefixes="dir">

  <xsl:param name="sourceDir" />
  <xsl:param name="cacheDir" />
  <xsl:param name="processedDir" />

  <xsl:import href="functions.xsl"/>
  
  <xsl:template match="/root">
    <page>
      <xsl:apply-templates select="dir:directory/dir:file">
        <xsl:with-param name="success-entries" select="root//entry[result=('OK','Identical octl exists')]"/>
      </xsl:apply-templates>
    </page>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="success-entries"/>
    <xsl:variable name="ctn" select="my:ctn-from-filename(@name)"/>
    <xsl:variable name="targetDir">
      <xsl:choose>
        <xsl:when test="$success-entries[@o=$ctn]">
          <xsl:value-of select="$cacheDir"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$processedDir"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <shell:move overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)"/>
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($targetDir,'/',@name)"/>
      </shell:target>
    </shell:move>
  </xsl:template>

</xsl:stylesheet>