<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- No secondary comparison for B2B so all products that pass through this stage are modified -->
  <xsl:template match="Files2Compare">
    <FilterProduct>
      <modified><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></modified>
    </FilterProduct>
  </xsl:template>  
</xsl:stylesheet>