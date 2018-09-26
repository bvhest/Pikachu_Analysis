<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testMasterProduct.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
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
    <Product>
      <CTN>
        <xsl:value-of select="CTN"/>
      </CTN>
      <xsl:apply-templates select="KeyBenefitArea/Feature"/>
      <xsl:apply-templates select="CSChapter/CSItem"/>
    </Product>
  </xsl:template>
  <!--  -->
  <xsl:template match="Feature">
    <KeyValuePair>
      <Code>
        <xsl:value-of select="FeatureCode"/>
      </Code>
      <Key>
        <xsl:value-of select="FeatureName"/>
      </Key>
      <Publisher>PikaChu</Publisher>
      <Values/>
    </KeyValuePair>
  </xsl:template>
  <!--  -->
  <xsl:template match="CSItem">
    <KeyValuePair>
      <Code>
        <xsl:value-of select="CSItemCode"/>
      </Code>
      <Key>
        <xsl:value-of select="CSItemName"/>
      </Key>
      <Publisher>PikaChu</Publisher>
      <Values>
        <xsl:for-each select="CSValue">
          <Value>
            <xsl:value-of select="CSValueName"/>
          </Value>
        </xsl:for-each>
      </Values>
    </KeyValuePair>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
