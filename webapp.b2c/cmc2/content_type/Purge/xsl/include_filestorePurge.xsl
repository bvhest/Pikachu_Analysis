<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="filestorePurgeService" />
  
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:directory"/>
    </root>
  </xsl:template>

  <xsl:template match="dir:directory">
    <i:include src="{$filestorePurgeService}/{@name}" />
  </xsl:template>
</xsl:stylesheet>