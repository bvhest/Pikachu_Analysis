<?xml version="1.0" encoding="UTF-8"?>

  <!--
    Normalize report files to a the following format:
      <report>
        <entries>...</entries>
        .. 
        <entries>...</entries>
      </report>
  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="/">
    <report>
      <xsl:apply-templates />
    </report>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="entries">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="entries[entry]">
    <xsl:copy-of select="." />
  </xsl:template>
</xsl:stylesheet>