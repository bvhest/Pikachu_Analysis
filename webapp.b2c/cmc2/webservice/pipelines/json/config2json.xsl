<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:import href="xml2json.xsl"/>
  
  <!-- These elements are repetitions and must be exported as a list -->
  <xsl:template match="Column|Country|Locale|Catalog" priority="1">
    <xsl:apply-templates select="." mode="in-list"/>
  </xsl:template>
    
</xsl:stylesheet>
