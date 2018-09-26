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
    <xsl:variable name="a">
      <xsl:apply-templates select="KeyBenefitArea/Feature/FeatureName"/>
      <xsl:apply-templates select="CSChapter/CSItem/CSItemName"/>
    </xsl:variable>
    <Product>
      <CTN>
        <xsl:value-of select="CTN"/>
      </CTN>
      <Alphanumeric>
        <xsl:value-of select="NamingString/Alphanumeric"/>
      </Alphanumeric>
      <BrandString>
        <xsl:value-of select="NamingString/BrandString"/>
      </BrandString>
      <BrandString2>
        <xsl:value-of select="NamingString/BrandString2"/>
      </BrandString2>
      <DescriptorCode>
        <xsl:value-of select="NamingString/Descriptor/DescriptorCode"/>
      </DescriptorCode>
      <DescriptorReferenceName>
        <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
      </DescriptorReferenceName>
      <xsl:call-template name="FullNamingString"/>
      <ProductName>
        <xsl:value-of select="ProductName"/>
      </ProductName>
      <ConceptCode>
        <xsl:value-of select="NamingString/Concept/ConceptCode"/>
      </ConceptCode>
      <ConceptReferenceName>
        <xsl:value-of select="NamingString/Concept/ConceptName"/>
      </ConceptReferenceName>
      <FamilyCode>
        <xsl:value-of select="NamingString/Family/FamilyCode"/>
      </FamilyCode>
      <FamilyReferenceName>
        <xsl:value-of select="NamingString/Family/FamilyName"/>
      </FamilyReferenceName>
      <ConsumerSegmentCode>
        <xsl:value-of select="ConsumerSegment/ConsumerSegmentCode"/>
      </ConsumerSegmentCode>
      <ConsumerSegmentReferenceName>
        <xsl:value-of select="ConsumerSegment/ConsumerSegmentName"/>
      </ConsumerSegmentReferenceName>
      <MIPClassificationCode/>
      <MIPClassificationReferenceName/>
    </Product>
  </xsl:template>
  <!--  -->
  <xsl:template name="FullNamingString">
    <xsl:variable name="TempFullNaming">
      <xsl:choose>
        <xsl:when test="string-length(NamingString/BrandString) &gt; 0">
          <xsl:value-of select="NamingString/BrandString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Concept/ConceptName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Partner/PartnerProductName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Alphanumeric"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/VersionString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandedFeatureString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandString2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="NamingString/MasterBrand/BrandName"/>
          <xsl:choose>
            <xsl:when test="string-length(NamingString/Concept/ConceptName) &gt; 0 and NamingString/Concept/ConceptName != 'NULL'">
              <xsl:value-of select="NamingString/Concept/ConceptName"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="NamingString/SubBrand/BrandName"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/Alphanumeric"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/VersionString"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="NamingString/BrandedFeatureString"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <FullNamingString>
      <xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
    </FullNamingString>
  </xsl:template>
  <!--  -->
  <!--  -->
  <xsl:template match="ConceptName">
    <xsl:if test="string-length(node()) &gt; 0">
      <KeyValue key="{../ConceptCode}" type="CNA" ctn="{../../../CTN}" name="{node()}" value="Yes"/>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="DescriptorName">
    <xsl:if test="string-length(node()) &gt; 0">
      <KeyValue key="{../DescriptorCode}" type="DNA" ctn="{../../../CTN}" name="{node()}" value="Yes"/>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="VersionElementName">
    <xsl:if test="string-length(node()) &gt; 0">
      <KeyValue key="{../VersionElementCode}" type="VEN" ctn="{../../../CTN}" name="{node()}" value="Yes"/>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="FeatureName">
    <KeyValue key="{../FeatureCode}" type="FNA" ctn="{../../../CTN}" name="{node()}" value="Yes"/>
  </xsl:template>
  <!--  -->
  <xsl:template match="CSItemName">
    <KeyValue key="{../CSItemCode}" type="CIN" ctn="{../../../CTN}" name="{node()}">
      <xsl:variable name="CSItem">
        <xsl:for-each select="../CSValue/CSValueName">
          <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="node()"/>
        </xsl:for-each>
        <xsl:value-of select="concat(' ',../UnitOfMeasure/UnitOfMeasureSymbol)"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string-length($CSItem) &gt; 0">
          <xsl:attribute name="value"><xsl:value-of select="substring($CSItem,1,255)"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:text>Yes</xsl:text></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </KeyValue>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
