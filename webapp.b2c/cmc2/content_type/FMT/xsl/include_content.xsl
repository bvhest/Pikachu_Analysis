<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="base.xsl"/>
   
  <xsl:param name="svcURL" />
  <xsl:param name="o" />
  <xsl:param name="primary-ct" select="'FMT_Translated'"/>
  <xsl:param name="l" />
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="content[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/{$primary-ct}/{$l}/{$o}" />
      <!-- Note: Family assets are stored as Object assets -->
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{$o}" />
      <xsl:choose>
        <xsl:when test="$l-master-assets-from = 'assetlist'">
          <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{$o}" />
        </xsl:when>
        <xsl:otherwise>
          <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/FMT_Master/master_global/{$o}" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>