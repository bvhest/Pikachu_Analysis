<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testMasterProduct.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:joost="http://joost.sf.net/extension" exclude-result-prefixes="sql xsl cinclude joost">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:groupcode|sql:groupname"/>
  <!--  -->
  <xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
  <!--  -->
  <xsl:template match="sql:rowset[@name='cat']"/>
  <!--  -->
  <xsl:template match="sql:rowset[@name='product']">
    <xsl:apply-templates/>
  </xsl:template>
  <!--  -->
  <xsl:template match="Products" exclude-result-prefixes="cinclude sql">
    <ProductsMsg>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:data/Product"/>
    </ProductsMsg>
  </xsl:template>
  <!--  -->
  <xsl:template match="sql:row" exclude-result-prefixes="cinclude sql">
    <xsl:apply-templates select="sql:data/Product"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="Product" exclude-result-prefixes="cinclude sql">
    <xsl:variable name="pt" select="document(concat('http://localhost:8888/pipes/TestMDM/get_AG_doc_',@Division,'_',CTN))"/>
    <Product>
      <CTN>
        <xsl:value-of select="CTN"/>
      </CTN>
      <!--ObjectState>active</ObjectState-->
      <NC>
        <xsl:choose>
          <xsl:when test="Code12NC">
            <xsl:value-of select="Code12NC"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring(concat('781',replace(CTN,'[A-Z,a-z,/]',''),'000000'),1,12)"/>
          </xsl:otherwise>
        </xsl:choose>
      </NC>
      <Sector>CLS</Sector>
      <FormerPD>
        <xsl:value-of select="@Division"/>
      </FormerPD>
      <ArticleGroupCode>
        <xsl:value-of select="$pt/ProductTree/ArticleGroupCode"/>
      </ArticleGroupCode>
      <xsl:for-each select="../../sql:rowset[@name='cat']/sql:row[position() = 1]">
        <SubCategoryCode>
          <xsl:value-of select="sql:subcategorycode"/>
        </SubCategoryCode>
      </xsl:for-each>
    </Product>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
