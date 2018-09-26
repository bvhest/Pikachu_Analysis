<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="content/object[Asset]" />

  <xsl:template match="AssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset|ancestor::content/object/Asset"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>