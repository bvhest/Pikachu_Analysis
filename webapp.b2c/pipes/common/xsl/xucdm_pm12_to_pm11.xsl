<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Convert a xUCM product marketing 1.2 document to 1.1
  -->
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	
  
  <!-- Remove disallowed nodes -->
  <xsl:template match="Products/@DocType|Products/@DocVersion"/>
  <xsl:template match="Product/@IsLocalized"/>
  <xsl:template match="Product/ProductType
                     | Product/LifecylceStatus
                     | Product/FullProductName
                     | Product/ProductClusters"/>
  <xsl:template match="CSValue/CSValueDisplayName"/>
  <xsl:template match="Award[@AwardType=('ala_summary', 'ala_award', 'ala_expert', 'ala_user', 'ala_video', 'bv_summary')]"/>
  <xsl:template match="Award/@isPaid
                     | Award/@awardAlid
                     | Award/@globalSource"/>
  <xsl:template match="Award/Trend
                     | Award/AwardAuthor
                     | Award/TestPros
                     | Award/TestCons
                     | Award/AwardVerdict
                     | Award/AwardText
                     | Award/AwardSourceCode
                     | Award/AwardVideo
                     | Award/AwardCategory
                     | Award/AwardSourceLocale"/>
  <xsl:template match="RichText[not(@type=('LearnMore','Q&amp;A','Testimonial','ProofPoint','ProductDescription'))]"/>
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
  <xsl:template match="ProductRefs">
    <xsl:apply-templates select="ProductReference[@ProductReferenceType=('Accessory','Performer','Variation','CrossSell','Chassis','ChassisOf','RefurbishedOf')]"/>
  </xsl:template>
  
  <xsl:template match="ProductRefs/ProductReference">
    <ProductReferences>
      <xsl:apply-templates select="@ProductReferenceType"/>
      <xsl:apply-templates select="CTN"/>
    </ProductReferences>
  </xsl:template>
  
</xsl:stylesheet>
