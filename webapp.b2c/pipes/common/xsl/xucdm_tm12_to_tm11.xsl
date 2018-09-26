<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Convert a xUCM treenode marketing 1.2 document to 1.1
  -->
  
  <!-- ProductReferenceType mapping. Types not in this map are not supported in 1.1 and therfore not exported. -->
  <xsl:variable name="prt-map">
    <prt name12="Accessory" name11="hasAsAccessory"/>
    <prt name12="Performer" name11="isAccessoryOf"/>
    <prt name12="assigned" name11="assigned">bar</prt>
  </xsl:variable>
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>	
  
  <!-- Remove disallowed nodes -->
  <xsl:template match="Nodes/@DocType|Nodes/@DocVersion"/>
  <xsl:template match="Node/@displayProductImage
                     | Node/MarketingStatus[.='New']
                     | Node/LifecycleStatus
                     | Node/KeyBenefitArea
                     | Node/CSChapter
                     | Node/SystemLogo
                     | Node/Award
                     | Node/AssetList
                     | Node/ObjectAssetList"/>
  <xsl:template match="Filters/Purpose[@type='Discriminators']"/>
  
  <!-- RichTexts and ProductRefs must be switch in order: 1. RichTexts, 2. ProductReferences -->
  <xsl:template match="RichTexts">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <!-- Copy only Product references of types that are known in xUCDM 1.1 -->
    <xsl:apply-templates select="../ProductRefs/ProductReference[@ProductReferenceType=$prt-map/prt/@name12]" />
  </xsl:template>
  <!-- Ignore ProductRefs because it is handled above -->
  <xsl:template match="ProductRefs"/>
  
  <xsl:template match="RichText[not(@type=('LearnMore','Q&amp;A','Testimonial'))]"/>
  <xsl:template match="RichText/Chapter
                     | RichText/Item/@docType
                     | RichText/Item/BulletList/BulletItem/SubList"/>
  
  <!-- Add mandatory referenceName attribute to RichText/Item -->
  <xsl:template match="RichText/Item">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:if test="empty(@referenceName)">
        <xsl:attribute name="referenceName" select="''"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove any markup elements from RichText items -->
  <xsl:template match="RichText/Item/Body
                     | RichText/Item/BulletList/BulletItem/Text">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="text()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Convert ProductRefs to ProductReferences -->
  <xsl:template match="ProductRefs/ProductReference">
    <ProductReferences>
      <xsl:apply-templates select="CTN|Product"/>
    </ProductReferences>
  </xsl:template>

  <!-- Convert ProductReferenceType -->
  <xsl:template match="@ProductReferenceType">
    <xsl:attribute name="ProductReferenceType" select="$prt-map/prt[@name12=string(current())]/@name11" />
  </xsl:template>

  <xsl:template match="ProductReference/CTN" priority="1">
    <ProductReference>
      <xsl:apply-templates select="../@ProductReferenceType"/>

      <CTN>
        <xsl:value-of select="." />
      </CTN>
      <ProductReferenceRank>
        <xsl:value-of select="if (@rank != '') then @rank else position()" />
      </ProductReferenceRank>
    </ProductReference>
  </xsl:template>

  <xsl:template match="ProductReference/Product">
    <ProductReference>
      <xsl:apply-templates select="../@ProductReferenceType" />
      <CTN>
        <xsl:value-of select="@ctn"/>
      </CTN>
      <ProductReferenceRank>
        <xsl:value-of select="if (@rank != '') then @rank else position()" />
      </ProductReferenceRank>
    </ProductReference>
  </xsl:template>  
</xsl:stylesheet>
