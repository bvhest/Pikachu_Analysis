<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="source">

  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  <xsl:param name="postfix"/>
  <xsl:param name="ext">.xml</xsl:param>

  <xsl:template match="Node">
    <xsl:if test="empty(following-sibling::Node[@code=current()/@code])">
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source>
          <xsl:value-of select="$dir"/>
          <xsl:value-of select="$prefix"/>
          <xsl:value-of select="translate(@code,'/','_')"/>
          <xsl:value-of select="$postfix"/>
          <xsl:value-of select="$ext"/>
        </source:source>
        <source:fragment>
          <Nodes>
            <xsl:apply-templates select="../@*"/>
            <!-- Copy any Families for the same family but a different catalog type -->
            <xsl:apply-templates select="preceding-sibling::Node[@code=current()/@code]" mode="copy"/>
            <!-- Copy this Family -->
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </Nodes>
        </source:fragment>
      </source:write>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Node" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
