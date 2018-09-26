<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml D:\dev\data\TestMDM\inbox\DAP_ProductTree.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ctn">HR1453/70</xsl:param>
  <!--  -->
  <xsl:template match="/ProductTree">
    <ProductTree>
      <xsl:apply-templates select="ProductDivision/BusinessGroup/BusinessUnit/MainArticleGroup/ArticleGroup[BasicType/Product = $ctn]"/>
    </ProductTree>
  </xsl:template>
  <!--  -->
  <xsl:template match="ArticleGroup">
    <ArticleGroupCode>
      <xsl:value-of select="ArticleGroupCode"/>
    </ArticleGroupCode>
    <ArticleGroupName>
      <xsl:value-of select="ArticleGroupName"/>
    </ArticleGroupName>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
