<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:txt="http://chaperon.sourceforge.net/schema/text/1.0" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0" 
    xmlns:autn="http://schemas.autonomy.com/aci/"    
>

  <xsl:import href="xml2json.xsl"/>
  
  <!-- These elements are repetitions and must be exported as a list -->
  <xsl:template match="autn:hit" priority="1">
    <xsl:apply-templates select="." mode="in-list"/>
  </xsl:template>
  
  <xsl:template match="autn:engines"/>
    
</xsl:stylesheet>
