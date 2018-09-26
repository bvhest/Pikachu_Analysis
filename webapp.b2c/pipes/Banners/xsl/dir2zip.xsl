<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:pikaf="http://www.philips.com/functions/pikachu/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    >
      
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="sourceDir" as="xs:string" select="'test/'"/>
	<xsl:param name="zipDir" as="xs:string" select="'test/'"/>
  <xsl:param name="include-path-info" select="'false'"/>

  <xsl:include href="dir_functions.xsl"/>

  <xsl:variable name="source-dir">
    <xsl:value-of select="$sourceDir"/>
    <xsl:if test="fn:substring($sourceDir, fn:string-length($sourceDir)) != '/'">  
        <xsl:text>/</xsl:text>
    </xsl:if>
  </xsl:variable>
  
	<!-- -->
	<xsl:template match="/">
		<xsl:if test="count(//dir:file) &gt; 0">
			<zip:archive>
				<xsl:apply-templates select="//dir:file"/>
			</zip:archive>
		</xsl:if>
		<xsl:if test="count(//dir:file) = 0">
			<zip:archive>
				<zip:entry name="index.html" serializer="html">
					<html>
						<head/>
						<body>Empty</body>
					</html>
				</zip:entry>
			</zip:archive>
		</xsl:if>
	</xsl:template>
	<!-- -->
	<xsl:template match="dir:file">
		<zip:entry>
			<xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="$include-path-info = 'true'">
            <xsl:value-of select="fn:concat($zipDir,pikaf:get-file-path(.))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="fn:concat($zipDir,@name)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
			<xsl:attribute name="src">
        <xsl:value-of select="concat($source-dir,pikaf:get-file-path(.))"/>
      </xsl:attribute>
		</zip:entry>
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
