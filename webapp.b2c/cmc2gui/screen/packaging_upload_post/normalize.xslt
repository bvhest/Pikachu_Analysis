<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   | This stylesheet normalizes the white space in text nodes
   -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  
  <xsl:template match="@*|node()[. instance of text() = false()]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:copy-of select="normalize-space(.)"/>
  </xsl:template>
</xsl:stylesheet>
