<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:dir="http://apache.org/cocoon/directory/2.0"
      xmlns:i="http://apache.org/cocoon/include/1.0">
      
  <xsl:param name="config-file-name"/>
  <xsl:param name="stylesheet-file-name"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="lm-config" select="string(dir:directory/dir:file[@name=$config-file-name]/@lastModified)"/>
      <xsl:variable name="lm-stylesheet" select="string(dir:directory/dir:file[@name=$stylesheet-file-name]/@lastModified)"/>
      
      <xsl:choose>
        <xsl:when test="$lm-stylesheet = '' or number($lm-config) > number($lm-stylesheet)">
          <i:include src="cocoon:/generateExtractionStylesheet"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Config not modified</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>