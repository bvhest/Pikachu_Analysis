<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes" />
  <xsl:param name="batch-size" select="1" />
  <xsl:variable name="l-batch-size" select="number($batch-size)"></xsl:variable>

  <xsl:param name="dir" />
  <xsl:param name="prefix" />
  <xsl:param name="postfix" />
  <xsl:param name="ext" select="'.xml'"/>

  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="yes">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Products">
    <xsl:copy copy-namespaces="yes">
      <xsl:apply-templates select="@*" />
      <xsl:for-each-group select="Product" group-by="position() idiv $l-batch-size">
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
            <xsl:value-of select="$dir" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$prefix" />
            <xsl:text>.</xsl:text>
            <xsl:value-of select="current-grouping-key()" />
            <xsl:value-of select="$postfix" />
            <xsl:value-of select="$ext" />
          </source:source>
          <source:fragment>
            <Products>
              <xsl:apply-templates select="../@*" />
              <xsl:apply-templates select="current-group()" />
            </Products>
          </source:fragment>
        </source:write>
       
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>