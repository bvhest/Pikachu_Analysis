<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

  <xsl:import href="../../../xsl/common/xucdm_product_marketing_1_2_normalize.xsl"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:param name="systemId"/>
  
  <xsl:template match="Files2Compare">
    <xsl:variable name="newContent">
      <xsl:apply-templates select="Products[1]/Product"/>
    </xsl:variable>
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="Products[2]/Product"/>
    </xsl:variable>
    <FilterProduct>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></identical>
        </xsl:when>
        <!-- Temporary fix: ignore products with a douhble NamingString element -->
        <xsl:when test="count(Products[1]/Product/NamingString) &gt; 1">
          <identical><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></identical>
        </xsl:when>
        <xsl:otherwise>
          <modified><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></modified>
        </xsl:otherwise>
      </xsl:choose>
    </FilterProduct>
  </xsl:template>  

  <!-- Ignore -->
  <xsl:template match="@lastModified|@masterLastModified"/>
  <xsl:template match="@rank"/>
  <xsl:template match="CRDateYW"/>
  <xsl:template match="ProductOwner"/>
  <xsl:template match="KeyBenefitAreaRank"/>
  <xsl:template match="KeyBenefitAreaCode"/>
  <xsl:template match="CSChapterRank"/>
  <xsl:template match="CSItemRank"/>
  <xsl:template match="CSValueRank"/>
  <xsl:template match="ProductReferences"/>
  <xsl:template match="MasterSEOProductName"/>

  <!-- Normalize whitespace -->
  <xsl:template match="MarketingTextHeader">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Overrides parent match to ignore @rank in ordering, since Prisma sends completely different values in each feed.
  -->
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="RichText[@type!='AssetCaption']" group-by="@type">
        <xsl:sort select="@type"/>
        
        <RichText type="{current-grouping-key()}">
          <xsl:choose>
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
</xsl:stylesheet>
