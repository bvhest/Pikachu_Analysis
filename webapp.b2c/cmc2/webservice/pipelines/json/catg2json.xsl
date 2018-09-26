<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:import href="xml2json.xsl"/>
  
  <!-- These elements are repetitions and must be exported as a list -->
  <xsl:template match="ProductDivision|BusinessGroup|Group|Category|SubCategory" priority="1">
    <xsl:apply-templates select="." mode="in-list"/>
  </xsl:template>
    
  <!-- Code attribute appears numeric, but may contain leading zero's, which get lost when parsed as integer values.
       Therefore, force string value -->  
  <xsl:template match="ProductDivision/@code|BusinessGroup/@code|Group/@code|Category/@code|SubCategory/@code" priority="1">
    <xsl:text>"code":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>",</xsl:text>
  </xsl:template>  
    
</xsl:stylesheet>
