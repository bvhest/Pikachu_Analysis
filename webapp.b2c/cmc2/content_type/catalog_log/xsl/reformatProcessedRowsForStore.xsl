<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="o"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
    <xsl:variable name="DocTimeStamp" select="content/sql:rowset[@name='selectprocessedrows']/sql:row[1]/sql:masterlastmodified_ts"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <content>
        <catalog-definition DocTimeStamp="{$DocTimeStamp}" ct="catalog_definition" l="none" o="{$o}">
          <xsl:apply-templates select="content/sql:rowset[@name='selectprocessedrows']/sql:row"/>
        </catalog-definition>
      </content>
      <xsl:apply-templates select="node()[not(local-name()='content')]"/>
    </xsl:copy>

  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row">
    <object o="{sql:object}">
      <xsl:for-each select="node()[local-name() != 'masterlastmodified_ts' and local-name() != 'object']">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
      </xsl:for-each>
    </object>
  <!-- -->
  </xsl:template>

</xsl:stylesheet>
