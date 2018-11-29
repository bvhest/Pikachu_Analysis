<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
<!--	
  <xsl:output method="text" indent="no"/>
-->
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <output>
      <xsl:copy-of select="//Product[Asset[ResourceType = ['KA1','KA2','KA3','KA4','KA5','KA6','KA7','KA8','KA9','GFA','AWL','GAP','GAZ','ala_award']]]"/>
    </output>
    <!--
    <xsl:apply-templates select="//Object[Asset[ResourceType = ['ABM','KA1','KA2','KA3','KA4','KA5','KA6','KA7','KA8','KA9','GFA','AWL','GAP','GAZ','ala_award']]]"/>
    -->
  </xsl:template>


</xsl:stylesheet>