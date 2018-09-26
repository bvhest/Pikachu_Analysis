<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!--
    Restore the sql namespace that was "escaped" by escape_sql_ns.xsl 
  -->
  <xsl:template match="node()[starts-with(local-name(),'sql-')]">
    <xsl:element name="{concat('sql:',substring-after(local-name(),'sql-'))}" namespace="http://apache.org/cocoon/SQL/2.0">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
