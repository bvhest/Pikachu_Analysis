<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../xsl/common/xucdm_treenode_marketing_1_2_normalize.xsl" />
  <xsl:strip-space elements="*"/>

  <!--
    Overrides parent matchs to ignore some data and use a different ordering for some elements.
  -->

  <!-- Ignore -->
  <xsl:template match="@lastModified|@masterLastModified|@rank|@groupRank"/>
  <xsl:template match="Owner|KeyBenefitAreaCode|KeyBenefitAreaRank|CSChapterRank|CSItemRank|SystemLogoRank"/>
  <xsl:template match="RichText[@type=('FeatureText','TextTable','ApplicationText')]/Item/@code|RichText[@type=('FeatureText','TextTable','ApplicationText')]/Item/@referenceName"/>
  
  <xsl:template match="Nodes">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="RichText[not(@type=('AssetCaption'))]" group-by="@type">
        <xsl:sort select="@type"/>
        
        <RichText type="{current-grouping-key()}">
          <xsl:choose>
            <xsl:when test="current-grouping-key() = ('FeatureText','TextTable','ApplicationText')">
              <xsl:apply-templates select="current-group()/Item">
                <xsl:sort data-type="number" select="@rank"/>
                <xsl:sort select="@code"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="current-group()/Chapter">
              <xsl:for-each-group select="current-group()/*" group-starting-with="Chapter">
                <xsl:sort select="self::Chapter/@code"/>
                <xsl:apply-templates select="self::Chapter"/>
                <xsl:apply-templates select="current-group()[self::Item]">
                  <xsl:sort select="@code"/>
                </xsl:apply-templates>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="current-group()/Item">
                <xsl:sort select="@code"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </RichText>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="RichText[@type='DimensionDiagramTable']/Item/BulletList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="BulletItem">
        <xsl:sort select="Text"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
