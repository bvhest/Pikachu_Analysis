<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="cmc2-f">
  
  <xsl:param name="objectkeys-config-file"/>
 
  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:import href="base.xsl"/>

  <xsl:variable name="objectkey-sources" select="document($objectkeys-config-file)/ObjectKeysConfig/TreeMapping/Map/Source"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ObjectAssetList">
    <xsl:variable name="l" select="ancestor::entry/@l"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>

      <xsl:variable name="secondary-assets">
        <!-- Include family's product assets -->
        <xsl:for-each select="../ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN">
          <object code="{text()}"/>
        </xsl:for-each>
      </xsl:variable>
      
      <xsl:variable name="secondary-object-assets">
        <!-- Include Feature assets -->
        <xsl:for-each select="../KeyBenefitArea/Feature">
          <object code="{FeatureCode}"/>
        </xsl:for-each>

        <!-- Include assets from ObjectKey sources -->
        <xsl:call-template name="objectkey-assets">
          <xsl:with-param name="context-node" select=".."/>
        </xsl:call-template>
      </xsl:variable>
            
      <!--
        Include the assets.
        Also keep related assets to create secondary relations.
        
        Note: variable $l-master-assets-from is defined in base.xsl
      -->
      <xsl:for-each-group select="$secondary-assets/object" group-by="@code">
        <xsl:if test="$l-master-assets-from = 'assetlist'">
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'AssetList', 'master_global')"/>
          <secondary-relation ct="AssetList" l="master_global" o="{current-grouping-key()}"/> 
        </xsl:if>
        <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'AssetList', $l)"/>
        <secondary-relation ct="AssetList" l="{$l}" o="{current-grouping-key()}"/> 
      </xsl:for-each-group>
      <xsl:for-each-group select="$secondary-object-assets/object" group-by="@code">
        <xsl:if test="$l-master-assets-from = 'assetlist'">
          <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', 'master_global')"/>
          <secondary-relation ct="ObjectAssetList" l="master_global" o="{current-grouping-key()}"/> 
        </xsl:if>
        <xsl:sequence select="cmc2-f:get-octl-sql(current-grouping-key(), 'ObjectAssetList', $l)"/>
        <secondary-relation ct="ObjectAssetList" l="{$l}" o="{current-grouping-key()}"/> 
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <!-- Dynamically determine related assets from objectkey configuration -->
  <xsl:template name="objectkey-assets">
    <xsl:param name="context-node"/>
    
    <xsl:for-each select="$objectkey-sources">
      <xsl:apply-templates select="$context-node" mode="eval-source">
        <xsl:with-param name="source" select="."/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="Node" mode="eval-source">
    <xsl:param name="source"/>
    <xsl:for-each select="saxon:evaluate($source/XPath[@type='object'])">
      <object code="{saxon:evaluate($source/XPath[@type='object-code'])}">
        <!-- xsl:apply-templates select="."/ -->
      </object>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
