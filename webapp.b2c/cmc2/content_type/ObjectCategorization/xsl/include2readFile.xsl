<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">
  
  <xsl:param name="dir" select="'.'"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:file"/>
    </root>
  </xsl:template>  

  <xsl:template match="dir:file">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
    </xsl:copy>
    <i:include src="{concat('cocoon:/readFile/',$dir,'/',@name)}"/>
  </xsl:template>
</xsl:stylesheet>