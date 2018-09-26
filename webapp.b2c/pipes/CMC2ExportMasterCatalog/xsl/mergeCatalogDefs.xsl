<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:source="http://apache.org/cocoon/source/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <!-- -->
  <xsl:variable name="objects">
    <objects>
      <xsl:copy-of select="/root/source:write/source:fragment/catalog-definition/object" />
    </objects>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="source:write[1]" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="source:write">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="catalog-definition">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*" copy-namespaces="no" />
      <xsl:copy-of select="$objects/objects/object" copy-namespaces="no" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>