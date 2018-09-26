<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:i="http://apache.org/cocoon/include/1.0"
                xmlns:email="http://apache.org/cocoon/transformation/sendmail"
                exclude-result-prefixes="i email sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <entries ct="catalog_definition" ts="{format-dateTime(current-dateTime(),'[Y0001][M01][D01][H01][m01][s01]')}">
      <entry includeinreport="yes">
        <xsl:apply-templates select="@*|node()"/>
      </entry>
    </entries>
  </xsl:template>

  <!-- Process catalogs that were updated -->
  <xsl:template match="catalog[@action='proceed']/counts">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="actual-deleted" select="../root[@name='mark-catalog-deletions']/sql:rowset/sql:row/sql:returncode"/>
      <xsl:if test="exists($actual-deleted)">
        <xsl:attribute name="actual-deleted" select="$actual-deleted"/>
      </xsl:if>
      
      <xsl:variable name="actual-modified" select="../root[@name='merge-catalog']/sql:rowset/sql:row/sql:returncode"/>
      <xsl:if test="exists($actual-modified)">
        <xsl:attribute name="actual-modified" select="$actual-modified"/>
      </xsl:if>      
    </xsl:copy>
  </xsl:template>
  
  <!-- Ignore nested root elements and email results -->
  <xsl:template match="root|email:*"/>
</xsl:stylesheet>
