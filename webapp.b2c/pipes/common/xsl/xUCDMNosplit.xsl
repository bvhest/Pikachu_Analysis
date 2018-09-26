<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:param name="dir" />
  <xsl:param name="prefix" />
  <xsl:param name="ext" select="'.xml'"/>

  <xsl:template match="/">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="$dir" />
        <xsl:value-of select="$prefix" />
        <xsl:value-of select="$ext" />
      </source:source>
      <source:fragment>
         <xsl:apply-templates select="@*|node()" />
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
