<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:pikaf="http://www.philips.com/functions/pikachu/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    >
  
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
  <xsl:param name="dir" select="'test'" as="xs:string"/>
  <xsl:param name="delete-directories" select="'false'"/>
	
  <xsl:include href="dir_functions.xsl"/>
  
  <xsl:variable name="source-dir">
    <xsl:value-of select="$dir"/>
    <xsl:if test="fn:substring($dir, fn:string-length($dir)) != '/'">  
        <xsl:text>/</xsl:text>
    </xsl:if>
  </xsl:variable>
  
  <xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
      <xsl:if test="$delete-directories = 'true'">
        <xsl:for-each select="//dir:directory[parent::dir:directory]">
          <xsl:sort select="pikaf:get-path(., '')" order="descending"/>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </xsl:if>
      <!-- xsl:apply-templates select="//dir:directory"/ -->
		</page>
	</xsl:template>

  <xsl:template match="dir:file">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="fn:concat($source-dir, pikaf:get-file-path(.))"/>
      </shell:source>
    </shell:delete>
  </xsl:template>
  <xsl:template match="dir:directory">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="fn:concat($source-dir, pikaf:get-file-path(.))"/>
      </shell:source>
    </shell:delete>
  </xsl:template>

  <!--
    Get the file path without the top level directory
    IN:   A dir:file element
    OUT:  The path of the file as a string
  -->
  <xsl:function name="pikaf:get-file-path">
    <xsl:param name="file"/>
    <xsl:value-of select="fn:substring-after(pikaf:get-path($file, ''), '/')"/>
  </xsl:function>
</xsl:stylesheet>
