<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceFile"/>
	<xsl:param name="sourceDir"/>
	<xsl:param name="targetDir"/>
  <!-- -->
  <xsl:variable name="now" select="current-dateTime()"/>
  <xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
  <!-- -->  
	<xsl:template match="/">
		<page>
			<xsl:call-template name="move"/>
		</page>
	</xsl:template>
  <!-- -->
	<xsl:template name="move">
		<shell:move overwrite="true">
			<shell:source><xsl:value-of select="concat($sourceDir,'/',$sourceFile)"/></shell:source>
			<shell:target><xsl:value-of select="concat($targetDir,'/',substring-before($sourceFile,'.xml'),'.',$snow,'.xml')"/></shell:target>
		</shell:move>
	</xsl:template>
</xsl:stylesheet>