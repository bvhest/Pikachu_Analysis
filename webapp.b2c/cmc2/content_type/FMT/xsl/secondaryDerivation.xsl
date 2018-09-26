<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="entry">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="empty(secondary)">
        <secondary>
          <xsl:call-template name="secondary">
            <xsl:with-param name="object" select="@o"/>
            <xsl:with-param name="ct" select="@ct"/>
            <xsl:with-param name="locale" select="@l"/>
            <xsl:with-param name="family" select="content/Node"/>
          </xsl:call-template>
        </secondary>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="secondary">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="secondary">
        <xsl:with-param name="object" select="../@o"/>
        <xsl:with-param name="ct" select="../@ct"/>
        <xsl:with-param name="locale" select="../@l"/>
        <xsl:with-param name="family" select="../content/Node"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="secondary">
    <xsl:param name="object"/>
    <xsl:param name="ct"/>
    <xsl:param name="locale"/>
    <xsl:param name="family"/>
    
    <xsl:for-each-group select="$family/secondary-relation" group-by="concat(@o,'/',@l,'/',@ct)">
      <xsl:variable name="r" select="current-group()[1]"/>
      <!-- Always add relation to master_global input.
           Only add relation to localised input if localised ObjectAsset is present -->
      <xsl:if test="$r/@l = 'master_global' or $family/ObjectAssetList/Object[id=$r/@o]/Asset[Language=$r/@l]">
        <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$locale"/>','<xsl:value-of select="$object"/>','<xsl:value-of select="$r/@ct"/>','<xsl:value-of select="$r/@l"/>','<xsl:value-of select="$r/@o"/>',1,1</relation>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>
  
  <!-- Remove saved secondary asset info -->
  <xsl:template match="secondary-relation"/>
</xsl:stylesheet>
