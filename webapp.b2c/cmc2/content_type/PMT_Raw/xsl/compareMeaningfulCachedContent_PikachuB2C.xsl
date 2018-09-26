<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

  <xsl:import href="compareCachedContent_PikachuB2C.xsl"/>
  
  <!-- Ignore additional elements -->
  <xsl:template match="ProductReferences|ProductRefs"/>    
  
  <!-- Ignore whitespace-only nodes -->
  <xsl:template match="text()[normalize-space() = '']"/>
  
</xsl:stylesheet>
