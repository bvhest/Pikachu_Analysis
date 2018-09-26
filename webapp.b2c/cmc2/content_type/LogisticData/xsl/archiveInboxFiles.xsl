<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="sourceDir" />
  <xsl:param name="targetDir" />
  <xsl:param name="ignoredDir" />
  
  <xsl:template match="/root">
    <page>
      <xsl:apply-templates select="dir:directory/dir:file">
        <xsl:with-param name="success-entries" select="root//entry[result=('OK','Identical octl exists')]"/>
      </xsl:apply-templates>
    </page>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="success-entries"/>
    <!-- format BE_19PFL3606H_12.xml -->
    <xsl:variable name="country" select="substring(@name,0,3)" /><!-- BE -->
    <xsl:variable name="ctn" select="replace(substring-before(substring(@name,4),'.xml'),'_','/')" /><!-- 19PFL3606H/12 -->
    <xsl:variable name="dstDir" select="if ($success-entries[@o=$ctn]) then concat($targetDir,'/',$country) else $ignoredDir"/>
    <shell:move overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($dstDir,'/',@name)" />
      </shell:target>
    </shell:move>
  </xsl:template>

</xsl:stylesheet>