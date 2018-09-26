<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../../xsl/common/xucdm_product_marketing_1_2_normalize.xsl" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="Products">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Ignore -->
  <xsl:template match="@lastModified|@masterLastModified|@rank"/>
  <xsl:template match="CRDate|CRDateYW|ProductOwner|KeyBenefitAreaCode|KeyBenefitAreaRank|CSChapterRank|CSItemRank|CSValueRank|SystemLogoRank"/>
  <xsl:template match="MasterSEOProductName" />
  <xsl:template match="RichText[@type='TextTable']/Item/@code|RichText[@type='TextTable']/Item/@referenceName"/>

  <!-- Normalize whitespace -->
  <xsl:template match="MarketingTextHeader">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Overrides parent match to ignore @rank in ordering for RichTexts other than type TextTable,
    since Prisma sends completely different values in each feed.
  -->
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="RichText[@type!='AssetCaption']" group-by="@type">
        <xsl:sort select="@type"/>
        
        <RichText type="{current-grouping-key()}">
          <xsl:choose>
            <xsl:when test="current-grouping-key() = 'TextTable'">
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
                  <xsl:sort data-type="number" select="@rank"/>
                  <xsl:sort select="@code"/>
                </xsl:apply-templates>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="current-group()/Item">
                <xsl:sort select="@code"/>
                <xsl:sort select="@docType"/> <!-- For AssetCaption type -->
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </RichText>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <!-- Ignore @rank for Prisma ProductClusters -->
  <xsl:template match="ProductClusters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ProductCluster">
        <xsl:sort select="@code" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
