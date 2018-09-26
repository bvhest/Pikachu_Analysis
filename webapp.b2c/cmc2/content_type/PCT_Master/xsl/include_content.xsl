<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="svcURL"/>
  <xsl:param name="o"/>
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="mlm"/>
  <xsl:param name="reload"/>     
  
    <xsl:template match="@*|node()">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template> 
    
    <xsl:template match="content[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get-octl/{$ct}/none/{$o}"/>
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get-octl/PMT_Master/{$l}/{$o}"/>
      <!-- stripped feed
	  <i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get/AssetList/master_global/{$o}"/>
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0"  src="{$svcURL}common/get-octl/AssetList/{$l}/{$o}"/>
-->
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
