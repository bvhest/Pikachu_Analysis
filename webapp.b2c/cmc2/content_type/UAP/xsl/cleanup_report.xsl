<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="entry[@valid='false' and result='More recent document exists']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[local-name() != 'valid']  "/>
      <xsl:attribute name="valid">true</xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="result[.='More recent document exists']">
    <xsl:copy copy-namespaces="no">OK</xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
