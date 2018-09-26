<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:data">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="concat('file://',text())"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove results from filestore copy operation -->
  <xsl:template match="shellResult" />
</xsl:stylesheet>