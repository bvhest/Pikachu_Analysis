<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="ctn"/>
  <!-- standard copy template -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	

  <xsl:template match="@CommercialID">
    <xsl:attribute name="CommercialID" select="if ($ctn != '') then $ctn else ." />
  </xsl:template>  
</xsl:stylesheet>