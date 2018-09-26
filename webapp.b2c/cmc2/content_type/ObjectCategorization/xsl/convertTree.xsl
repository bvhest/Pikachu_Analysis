<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>

  <xsl:template match="/Categorization|Catalog|SubCategory">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="SubCategoryCode|Product">
    <xsl:copy-of copy-namespaces="no" select="." />
  </xsl:template>

  <xsl:template match="CatalogCode">
    <xsl:copy>
      <xsl:variable name="code" select="normalize-space(.)" />
      <xsl:value-of select="if ($code='') then 'MASTER' else $code" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Node[ChildProducts/Product != '' ]">
    <SubCategory status="Active">
      <SubCategoryCode>
        <xsl:value-of select="@Code" />
      </SubCategoryCode>
      <xsl:apply-templates select="node()" />
    </SubCategory>
  </xsl:template>

  <xsl:template match="ProductTree">
    <Catalog Language="en" IsMaster="false">
      <CatalogCode>ProductTree</CatalogCode>
      <xsl:apply-templates select="node()" />
    </Catalog>
  </xsl:template>

  <xsl:template match="ArticleGroup">
    <SubCategory status="active">
      <SubCategoryCode>
        <xsl:value-of select="ArticleGroupCode" />
      </SubCategoryCode>
      <xsl:apply-templates select="node()" />
    </SubCategory>
  </xsl:template>

</xsl:stylesheet>