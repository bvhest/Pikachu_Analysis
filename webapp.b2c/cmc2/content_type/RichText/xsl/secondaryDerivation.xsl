<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template match="entry[result='No Placeholder']/@valid[.='false']">
    <!-- reset valid attribute to true because we will (try to) create a placeholder -->    
    <xsl:attribute name="valid" select="if(../currentoctls/sql:rowset/sql:row[sql:object_id = current()/../@o]) then 'true' else 'false'"/>
  </xsl:template>

  <xsl:template match="entry/store-outputs">
    <xsl:copy>
      <xsl:variable name="o" select="../@o"/>
      <xsl:variable name="l" select="../@l"/>
      <xsl:variable name="currentoctls" select="../currentoctls"/>
      <xsl:variable name="currentrelations" select="../currentrelations[@output_content_type='PMT']"/>
      <xsl:variable name="currentcontent" select="../currentcontent"/>

      <!-- Create Placeholders: RichText (only if there is a PMT) -->
      <xsl:if test="../result='No Placeholder' and $currentoctls/sql:rowset/sql:row[sql:object_id = $o]">
          <placeholder o="{$o}" ct="RichText" l="{$l}" needsProcessing="0" />
      </xsl:if>

      <!-- Create OCTL_Relations: RichText -> PMT (only if there is a PMT) -->
      <xsl:if test="not($currentrelations/sql:rowset/sql:row[sql:output_object_id = $o]) and $currentoctls/sql:rowset/sql:row[sql:object_id = $o]">
        <create-relation o-in="{$o}" ct-in="RichText" l-in="{$l}" ct-out="PMT" l-out="{$l}" o-out="{$o}"  secondary="1"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="currentcontent|currentrelations|currentoctls|assignments"/>


</xsl:stylesheet>
