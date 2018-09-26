<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <xsl:param name="ts"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:copy copy-namespaces="no">
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source>
          <xsl:value-of select="concat($dir,'/pcu_pct_deduplicated_input.',$ts,'.xml')"/>
        </source:source>
        <source:fragment>
          <Products>
            <xsl:apply-templates select="node()|@*"/>
          </Products>
        </source:fragment>
      </source:write>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:directory">
    <xsl:for-each-group select="dir:file/dir:xpath/Products/Product" group-by="concat(CTN,'_',@Locale)">
      <xsl:sort select="current-grouping-key()"/>
      <xsl:for-each select="current-group()">
        <xsl:sort select="@masterLastModified" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>