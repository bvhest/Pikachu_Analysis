<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml content_overview.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:variable name="item" select="upper-case(replace(/root/main/root/Language, ' |/s|[()]|- ', ''))"/>
  <xsl:variable name="locale" select="upper-case(/root/main/root/locale)"/>
  <!-- -->
  <xsl:template match="main[root]">
        <xsl:copy-of  copy-namespaces="no" select="root/*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="root[row]">
        <xsl:apply-templates select="row/*" mode="aa"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="*" mode="aa">
    <xsl:if test="upper-case(./name()) = $item">
       <xsl:value-of select="."/>
    </xsl:if>
    <xsl:if test="upper-case(./name()) = $locale">
       <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
