<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- standard copy template -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	

  <xsl:template match="source/*/attribute::*[lower-case(local-name()) = 'doctimestamp']" />
  <xsl:template match="cache/*/attribute::*[lower-case(local-name()) = 'doctimestamp']" />
</xsl:stylesheet>