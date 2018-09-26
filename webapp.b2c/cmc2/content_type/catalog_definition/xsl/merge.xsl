<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:param name="sourcefiles"/>
  
  <!--  -->    
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:if test="$sourcefiles='LCB'">
	    <catalogs>
	      <xsl:attribute name="timestamp" select="catalogs[1]/@timestamp"/>
	      <xsl:apply-templates select="catalogs/catalog"/>
	    </catalogs>
    </xsl:if>
    <xsl:if test="$sourcefiles='CCB'">
	    <Catalogs>
	      <xsl:attribute name="Timestamp" select="Catalogs[1]/@Timestamp"/>
	      <xsl:attribute name="Version" select="Catalogs[1]/@Version"/>
	      <xsl:apply-templates select="Catalogs/Catalog"/>
	    </Catalogs>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>