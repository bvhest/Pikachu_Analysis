<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	
	<xsl:param name="source" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Filter">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="identical">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="source" select="$source"/>
      
      <shell:delete>
        <shell:source>
          <xsl:value-of select="$source" />
        </shell:source>
      </shell:delete>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sourceResult"/>

</xsl:stylesheet>