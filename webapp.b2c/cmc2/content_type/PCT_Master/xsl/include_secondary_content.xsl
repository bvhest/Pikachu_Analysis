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
  
  <xsl:template match="Product">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <ObjectAssetList>
        <xsl:for-each-group select="RichTexts/RichText/Item" group-by="@code">
          <xsl:for-each select="current-group()">
            <xsl:if test="position() = 1">
              <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{current-grouping-key()}"/>
            </xsl:if>            
          </xsl:for-each>
        </xsl:for-each-group>
      </ObjectAssetList>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList">
	   <xsl:copy>
	   <xsl:apply-templates select="@*|node()"/>
	   <xsl:for-each-group select="RichTexts/RichText/Item" group-by="@code">
          <xsl:for-each select="current-group()">
            <xsl:if test="position() = 1">
              <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/{$l}/{current-grouping-key()}"/>
            </xsl:if>            
          </xsl:for-each>
        </xsl:for-each-group>
        </xsl:copy>
  </xsl:template>
  
  
  
</xsl:stylesheet>
