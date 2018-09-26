<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    exclude-result-prefixes="sql dir">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <xsl:template match="/dir:directory">
    <report>
      <xsl:apply-templates select="dir:file/dir:xpath/batch/sql:rowset/sql:row" />
    </report>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row">
    <item>
      <xsl:apply-templates select="@*|node()" />
    </item>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:ctn">
    <id>
      <xsl:value-of select="." />
    </id>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale">
    <locale>
      <xsl:value-of select="." />
    </locale>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:result">
    <result>
      <xsl:value-of select="." />
    </result>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:remark">
    <remark>
      <xsl:value-of select="." />
    </remark>
  </xsl:template>
  <!-- -->
  <xsl:template match="batch|batch/@*|sql:rowset[sql:row]">
    <xsl:apply-templates select="@*[not(local-name()=('name'))]|node()" />
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
