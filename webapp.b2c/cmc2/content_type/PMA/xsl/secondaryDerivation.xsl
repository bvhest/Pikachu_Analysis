<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="ct"/>
  <xsl:variable name="output_ct" select="'PMT'"/>
  <!-- -->
  <xsl:template match="entries">
    <xsl:key name="k_outputoctls" match="globalDocs/currentoctls[@content_type=$output_ct]/object_id" use="."/>
    <xsl:key name="k_octls" match="globalDocs/currentoctls[@content_type=$ct]/object_id" use="."/>    
    <xsl:key name="k_relations" match="globalDocs/currentrelations/relation/output_object_id" use="."/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='true' or (@valid='false' and result='No Placeholder')]/store-outputs">
    <xsl:variable name="l" select="ancestor::entries/@l"/>
    <xsl:variable name="output_l" select="ancestor::entries/@l"/>
    <xsl:copy>
      <xsl:variable name="o" select="../@o"/>
      <!-- Create Placeholder: PMA -->
      <xsl:if test="not(key('k_octls',$o))">
        <placeholder o="{$o}" ct="{$ct}" l="{$l}" needsProcessing="0" />
      </xsl:if>      
      <!-- Create OCTL_Relation : PMA -> PMT but only if there is a PMT octl -->
      <xsl:if test="not(key('k_relations',$o))">
        <xsl:if test="key('k_outputoctls',$o)">
          <create-relation o-in="{$o}" ct-in="{$ct}" l-in="{$l}" ct-out="{$output_ct}" l-out="{$output_l}" o-out="{$o}"  secondary="1"/>
          <trigger-octl ct="{$output_ct}" l="{$output_l}" o="{$o}"/>
        </xsl:if>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="globalDocs"/>
</xsl:stylesheet>