<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceFilename"/>
	<xsl:param name="sourceFilePath"/>
	<xsl:template match="/">
    <zip:archive>
  		<zip:entry>
  			<xsl:attribute name="name"><xsl:value-of select="$sourceFilename"/></xsl:attribute>
  			<xsl:attribute name="src"><xsl:value-of select="$sourceFilePath"/></xsl:attribute>
  		</zip:entry>		
	  </zip:archive>
	</xsl:template>
</xsl:stylesheet>
