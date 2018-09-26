<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

	<xsl:param name="source" />
  <!-- -->
	<xsl:template match="Product/CTN">
    		  <shell:delete>
    			  <shell:source><xsl:value-of select="concat($source,replace(.,'/','_'),'.xml')"/></shell:source>
    		  </shell:delete>
	</xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates select="node()|@*"/>
    </root>
	</xsl:template>
</xsl:stylesheet>