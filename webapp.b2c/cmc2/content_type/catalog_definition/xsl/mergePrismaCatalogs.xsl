<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--  -->    
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <Catalogs>
      <xsl:attribute name="Timestamp" select="Catalogs[1]/@Timestamp"/>
      <xsl:apply-templates select="Catalogs/Catalog"/>
    </Catalogs>
  </xsl:template>
</xsl:stylesheet>