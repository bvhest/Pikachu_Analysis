<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="store-outputs">
    <xsl:copy>
      <xsl:variable name="o" select="../@o"/>
      <xsl:variable name="newproductreferences" select="../content/Node/ProductReferences/ProductReference/CTN
                                                      | ../content/Node/ProductRefs/ProductReference/CTN
                                                      | ../content/Node/ProductRefs/ProductReference/Product/@ctn"/>
      <xsl:variable name="currentpmtmasterrelations" select="../currentrelations[@output_content_type='PMT_Master']"/>
      <xsl:variable name="currentpmtenrichedrelations" select="../currentrelations[@output_content_type='PMT_Enriched']"/>
  
      <!-- Create OCTL_Relations: RangeText_Raw -> PMT_Enriched -->
      <xsl:for-each select="$newproductreferences">
         <xsl:if test="not($currentpmtmasterrelations/sql:rowset/sql:row[sql:output_object_id = current()])">
  			<create-relation o-in="{$o}" ct-in="RangeText_Raw" l-in="none" ct-out="PMT_Master" l-out="master_global" o-out="{.}"  secondary="1"/>
         </xsl:if>
         <xsl:if test="not($currentpmtenrichedrelations/sql:rowset/sql:row[sql:output_object_id = current()])">
  			<create-relation o-in="{$o}" ct-in="RangeText_Raw" l-in="none" ct-out="PMT_Enriched" l-out="master_global" o-out="{.}"  secondary="1"/>
        </xsl:if>
      </xsl:for-each>
  
      <!-- Deactivate existing RangeText secondary relations to PMT_Master where assigment has been removed (RangeText_Raw -> PMT_Master) -->
      <!-- Trigger the old output OCTL; this is to make sure old references to Range are removed -->
      <xsl:for-each select="$currentpmtmasterrelations/sql:rowset/sql:row">
        <xsl:if test="not($newproductreferences[.=current()/sql:output_object_id])">
          <trigger-octl ct="PMT_Master" l="master_global" o="{sql:output_object_id}"/>
          <drop-relation o-out="{sql:output_object_id}" l-out="{sql:output_localisation}" ct-out="{sql:output_content_type}" o-in="{$o}" l-in="none" ct-in="RangeText_Raw"/>
        </xsl:if>
      </xsl:for-each>
      
      <xsl:for-each select="$currentpmtenrichedrelations/sql:rowset/sql:row">
        <xsl:if test="not($newproductreferences[.=current()/sql:output_object_id])">
          <trigger-octl ct="PMT_Enriched" l="master_global" o="{sql:output_object_id}"/>
          <drop-relation o-out="{sql:output_object_id}" l-out="{sql:output_localisation}" ct-out="{sql:output_content_type}" o-in="{$o}" l-in="none" ct-in="RangeText_Raw"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="currentcontent|currentrelations|currentoctls|assignments"/>
</xsl:stylesheet>
