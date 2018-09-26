<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:import href="xml2json.xsl"/>
  
  <!-- These elements are repetitions and must be exported as a list -->
  <xsl:template match="CallParameters/columnSelection/column|Columns/Column|Columns/Column/Count" priority="1">
    <xsl:apply-templates select="." mode="in-list"/>
  </xsl:template>
    
  <!-- Force these text nodes to be output as string -->
  <xsl:template match="CallParameters/ctnRestriction/item/text()" priority="1">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>
</xsl:stylesheet>
