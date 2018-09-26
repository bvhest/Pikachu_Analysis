<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:philips="http://www.philips.com/catalog/recat" 
                exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="locales" select="/root/sql:rowset"/>
  <!-- -->
  <xsl:template match="/root">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- -->
  <xsl:template match="philips:seoName">
    <xsl:variable name="locale" select="substring(../catalog_locale,1,5)"/>
    <!--xsl:if test="$locales/sql:row[sql:locale=$locale][sql:islatin=1]"-->
      <philips:seoName romanize="true" locale="{$locale}"><xsl:value-of select="."/></philips:seoName>
    <!--/xsl:if-->
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset"/>
  <!-- -->
</xsl:stylesheet>
