<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="mode"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentrelations|newrelations|currentcontent"/>
  <!-- -->
  <xsl:template match="entry[@valid='true' or $mode='reprocessexistingcontent']/store-outputs">
    <!-- Only meddle with relations for an entry if the content has changed or if this is a reprocess of existing content -->
    <xsl:variable name="currentcontent" select="../currentcontent/sql:rowset/sql:row/sql:data/Localization"/>
    <xsl:variable name="newcontent"     select="../content/Localization"/>
    <xsl:variable name="ct" select="../@ct"/>
    <xsl:variable name="l" select="../@l"/>
    <xsl:variable name="o" select="../@o"/>

    <xsl:copy>
      <!-- Deactivate existing PMT_Localised secondary relations where the new content does not support the relationship -->
      <!-- Also trigger the old output OCTL; this is to make sure old references to Localization are removed -->
      <xsl:for-each select="../currentrelations/relation[output_content_type = 'PMT_Localised']">
        <xsl:if test="not(../../newrelations/sql:rowset/sql:row[sql:content_type='PMT_Localised'][sql:localisation = current()/output_localisation][sql:object_id = current()/output_object_id])">
          <trigger-octl ct="PMT_Localised" l="{output_localisation}" o="{output_object_id}"/>
          <drop-relation o-out="{output_object_id}" l-out="{output_localisation}" ct-out="{output_content_type}" ct-in="{$ct}" l-in="{$l}" o-in="{$o}"/>
        </xsl:if>
      </xsl:for-each>

      <!-- Create OCTL_Relations: Localization -> PMT_Localised -->
      <xsl:for-each select="../newrelations/sql:rowset/sql:row[sql:content_type='PMT_Localised']">
        <xsl:if test="not(../../../currentrelations/relation[output_content_type = 'PMT_Localised'][output_localisation = current()/sql:localisation][output_object_id = current()/sql:object_id])">
          <create-relation ct-in="{$ct}" l-in="{$l}" o-in="{$o}" ct-out="PMT_Localised" l-out="{sql:localisation}" o-out="{sql:object_id}" secondary="1"/>
          <trigger-octl ct="PMT_Localised" l="{sql:localisation}" o="{sql:object_id}"/>
        </xsl:if>
      </xsl:for-each>


      <!-- Deactivate existing RangeText_Localized secondary relations where the new content does not support the relationship -->
      <!-- Also trigger the old output OCTL; this is to make sure old references to Localization are removed -->
      <xsl:for-each select="../currentrelations/relation[output_content_type = 'RangeText_Localized']">
        <xsl:if test="not(../../newrelations/sql:rowset/sql:row[sql:content_type='RangeText_Localized'][sql:localisation = current()/output_localisation][sql:object_id = current()/output_object_id])">
          <trigger-octl ct="RangeText_Localized" l="{output_localisation}" o="{output_object_id}"/>
          <drop-relation o-out="{output_object_id}" l-out="{output_localisation}" ct-out="{output_content_type}" ct-in="{$ct}" l-in="{$l}" o-in="{$o}"/>
        </xsl:if>
      </xsl:for-each>

      <!-- Create OCTL_Relations: Localization -> RangeText_Localized -->
      <xsl:for-each select="../newrelations/sql:rowset/sql:row[sql:content_type='RangeText_Localized']">
        <xsl:if test="not(../../../currentrelations/relation[output_content_type = 'RangeText_Localized'][output_localisation = current()/sql:localisation][output_object_id = current()/sql:object_id])">
          <create-relation ct-in="{$ct}" l-in="{$l}" o-in="{$o}" ct-out="RangeText_Localized" l-out="{sql:localisation}" o-out="{sql:object_id}" secondary="1"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
