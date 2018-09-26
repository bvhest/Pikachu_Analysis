<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    <xsl:template match="entry">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="object" select="@o"/>
      <xsl:variable name="ct" select="@ct"/>
      <xsl:variable name="locale" select="@l"/>
      <secondary>
        <xsl:for-each select="content/Product">
          <xsl:variable name="product" select="."/>
          <xsl:for-each-group select="RichTexts/RichText/Item" group-by="@code">
            <xsl:for-each select="current-group()">
              <xsl:if test="position() = 1">
                <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','ObjectAssetList','<xsl:value-of select="$locale"/>','<xsl:value-of select="current-grouping-key()"/>',1,1</relation>
                </xsl:if>
            </xsl:for-each>
          </xsl:for-each-group>
        </xsl:for-each>
      </secondary>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>
