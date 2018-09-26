<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
    <xsl:variable name="ct" select="@ct"/>
    <xsl:variable name="l"  select="@l"/>
    <xsl:variable name="o"  select="@o"/>
  
    <!-- New OAL relations -->
    <xsl:variable name="newobjectassetlistrelations">
      <xsl:variable name="node" select="content/Node"/>
      <xsl:for-each-group select="$node/ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product/CSItem/CSValue" group-by="CSValueCode">
        <id><xsl:value-of select="current-grouping-key()"/></id>
      </xsl:for-each-group>
    </xsl:variable>  

    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
      </xsl:apply-templates>
      <secondary>
        <xsl:for-each select="$newobjectassetlistrelations/id">
          <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$l"/>','<xsl:value-of select="$o"/>','ObjectAssetList','master_global','<xsl:value-of select="."/>',1,1</relation>
        </xsl:for-each>
        <!-- Keep existing other relations -->
        <xsl:for-each select="content/sql:rowset[@name='current-secondary-derived-relations']/sql:row[sql:input_content_type != 'ObjectAssetList']">
          <relation>'<xsl:value-of select="$ct"/>','<xsl:value-of select="$l"/>','<xsl:value-of select="$o"/>','<xsl:value-of select="sql:input_content_type"/>','<xsl:value-of select="sql:input_localisation"/>','<xsl:value-of select="sql:input_object_id"/>',1,1</relation>
        </xsl:for-each>
      </secondary>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="content/sql:rowset"/>
  
  <xsl:template match="content">
    <xsl:param name="newobjectassetlistrelations"/> 

    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Node">
    <xsl:param name="newobjectassetlistrelations"/> 

    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()[not(local-name()='ObjectAssetList')]"/>
      <xsl:apply-templates select="ObjectAssetList">
        <xsl:with-param name="newobjectassetlistrelations" select="$newobjectassetlistrelations"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList">
    <xsl:param name="newobjectassetlistrelations"/> 

    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="*"/>
      <xsl:for-each select="$newobjectassetlistrelations/id">
        <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$svcURL}common/get-octl/ObjectAssetList/master_global/{.}"/>
      </xsl:for-each>
    </xsl:copy>    
  </xsl:template>
</xsl:stylesheet>

