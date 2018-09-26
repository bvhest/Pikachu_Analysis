<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:b2b="http://pww.pikachu.philips.com/b2b/function/1.0" 
    extension-element-prefixes="b2b"
  >
  
  <xsl:import href="../../../xsl/common/xucdm_product_marketing_1_3_normalize.xsl"/>

  <xsl:param name="system"/>

  <xsl:include href="../../../xsl/common/b2b.functions.xsl"/>
  
  <xsl:template match="Filters">
    <Filters>
      <Purpose type="Comparison">
        <Features>
          <xsl:apply-templates select="../KeyBenefitArea/Feature" mode="Filters">
            <xsl:sort data-type="number" select="FeatureTopRank"/>
            <xsl:sort select="FeatureCode"/>
          </xsl:apply-templates>
        </Features>                
        <CSItems>
          <xsl:apply-templates select="../CSChapter/CSItem" mode="Filters">
            <xsl:sort data-type="number" select="CSItemRank"/>
            <xsl:sort select="CSItemCode"/>
          </xsl:apply-templates>
        </CSItems>                         
      </Purpose>
      <Purpose type="Detail">
        <Features>
          <xsl:apply-templates select="../KeyBenefitArea/Feature" mode="Filters">
            <xsl:sort data-type="number" select="FeatureTopRank"/>
            <xsl:sort select="FeatureCode"/>
          </xsl:apply-templates>
        </Features>                
        <CSItems>
          <xsl:apply-templates select="../CSChapter/CSItem" mode="Filters">
            <xsl:sort data-type="number" select="CSItemRank"/>
            <xsl:sort select="CSItemCode"/>
          </xsl:apply-templates>
        </CSItems>                  
      </Purpose>                
      <xsl:apply-templates select="Purpose[@type='Discriminators']" mode="FiltersDiscriminators"/>
    </Filters>
  </xsl:template>    

  <xsl:template match="Feature" mode="Filters">
    <Feature>
      <xsl:attribute name="code" select="FeatureCode"/>
      <xsl:attribute name="referenceName" select="FeatureReferenceName"/>
      <xsl:attribute name="rank" select="FeatureTopRank"/>
    </Feature>
  </xsl:template>

  <xsl:template match="CSItem" mode="Filters">
    <CSItem>
      <xsl:attribute name="code" select="CSItemCode"/>
      <xsl:attribute name="referenceName" select="concat(ancestor::CSChapter/CSChapterName, ' - ', CSItemName)"/>
      <xsl:attribute name="rank" select="CSItemRank"/>
    </CSItem>
  </xsl:template>

  <xsl:template match="Purpose" mode="FiltersDiscriminators">  
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="FiltersDiscriminators"/>
      <xsl:apply-templates select="Features" mode="FiltersDiscriminators"/>
      <xsl:apply-templates select="CSItems" mode="FiltersDiscriminators"/>
    </xsl:copy>  
  </xsl:template>

  <xsl:template match="Features" mode="FiltersDiscriminators">  
    <xsl:copy>
      <xsl:apply-templates select="Feature" mode="FiltersDiscriminators">
        <xsl:sort data-type="number" select="@rank"/>
      </xsl:apply-templates>        
    </xsl:copy>  
  </xsl:template>

  <xsl:template match="CSItems" mode="FiltersDiscriminators">  
    <xsl:copy>
      <xsl:apply-templates select="CSItem" mode="FiltersDiscriminators">
        <xsl:sort data-type="number" select="@rank"/>
      </xsl:apply-templates>        
    </xsl:copy>  
  </xsl:template>

  <xsl:template match="BrandName|BrandString">
    <xsl:element name="{node-name(.)}">
      <xsl:value-of select="replace(.,'PHILIPS','Philips')"/>
    </xsl:element>
  </xsl:template>

  <!-- Fix family codes for B2B. See b2b.functions.xsl -->
  <xsl:template match="NamingString/Family/FamilyCode[$system='PikachuB2B']">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="b2b:fix-family-code(text())"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="ProductClusters/ProductCluster[@type='family']/@code[$system='PikachuB2B']">
    <xsl:attribute name="code">
      <xsl:value-of select="b2b:fix-family-code(.)"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
