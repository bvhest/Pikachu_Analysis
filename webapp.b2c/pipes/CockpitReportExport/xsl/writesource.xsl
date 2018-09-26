<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="dir"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Workbook">
    <xsl:variable name="filename" select="concat($dir,country,'_',customer_id,'.xml')"/>
    <source:write>
      <source:source><xsl:value-of select="$filename"/></source:source>
      <source:fragment>
        <xsl:copy-of select="."/>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
