<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="zipSourceDir"/>  
	<xsl:param name="zipDestDir"/>
	<!-- -->
	<xsl:template match="/">
		<xsl:if test="count(//dir:file) &gt; 0">
		  <xsl:apply-templates select="//dir:file"/>
		</xsl:if>
	</xsl:template>
	<!-- -->
	<xsl:template match="dir:file">
    <!-- Call ZipFile -->
    <cinclude:include	src="cocoon:/ZipFile/{concat($zipSourceDir,'/',@name)}?sourceFilename={@name}&amp;destFilename={concat($zipDestDir,'/',@name,'.zip')}"/>
  </xsl:template>
</xsl:stylesheet>
