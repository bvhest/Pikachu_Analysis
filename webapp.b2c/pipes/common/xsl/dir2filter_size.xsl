<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:shell="http://apache.org/cocoon/shell/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param as="xs:integer" name="size"/>
  <!--  -->
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="//dir:file">
    <xsl:if test="xs:integer(@size) &lt; $size">
      <dir:file>
        <xsl:apply-templates select="@*|node()"/>
      </dir:file>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
