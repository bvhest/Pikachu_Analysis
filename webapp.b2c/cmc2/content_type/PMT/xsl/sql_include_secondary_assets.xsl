<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">

  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:import href="base.xsl"/>

  <xsl:variable name="includesec">yes</xsl:variable>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ObjectAssetList">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      
      <!-- Include Award assets -->
      <!-- variable $l-master-assets-from is defined in base.xsl -->
      <xsl:if test="$includesec='yes'">
        <xsl:for-each-group select="../Award[AwardCode]" group-by="AwardCode">
          <xsl:if test="$l-master-assets-from = 'assetlist'">
            <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
          </xsl:if>
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
        </xsl:for-each-group>
        <xsl:for-each-group select="../Award[AwardSourceCode]" group-by="AwardSourceCode">
          <xsl:if test="$l-master-assets-from = 'assetlist'">
            <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
          </xsl:if>
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
        </xsl:for-each-group>   
       </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
