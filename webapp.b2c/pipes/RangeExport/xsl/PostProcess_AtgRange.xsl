<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">

  <xsl:variable name="csvalue-image-doctype" select="'VIM'"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
   <!-- 2010-sep-03: 
      | Implemented in the AtgExport, AtgMerchandise, AtgProducts and AtgRanges.
      | Quick Fix because Atg can't deal with the Iso 'he_IL' locale (Java bug): replace 'he_IL' with 'iw_IL'. 
      -->
  <xsl:template match="@Locale[.='he_IL']">
     <xsl:attribute name='Locale'><xsl:value-of select="'iw_IL'" /></xsl:attribute>
  </xsl:template>

  <xsl:template match="@locale[.='he_IL']">
     <xsl:attribute name='locale'><xsl:value-of select="'iw_IL'" /></xsl:attribute>
  </xsl:template>

  <!-- For Atg the send product references in a custom format (based on xUCDM treenode 1.1) -->
  <xsl:template match="ProductRefs">
    <ProductReferences>
      <xsl:apply-templates select="ProductReference/CTN|ProductReference/Product"/>
    </ProductReferences>
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

  <xsl:template match="ProductReference/CTN/@group|ProductReference/CTN/@groupRank"/>

  <xsl:template match="ProductReference/Product">
    <ProductReference>
      <xsl:apply-templates select="../@ProductReferenceType"/>
      
      <CTN>
        <xsl:value-of select="@ctn"/>
      </CTN>
      <ProductReferenceRank>
        <xsl:value-of select="if (@rank != '') then @rank else position()" />
      </ProductReferenceRank>
      
      <xsl:apply-templates select="CSItem"/>
    </ProductReference>
  </xsl:template>
  
  <!-- Remove assigned product CSValue images if not all CSValues have an image and there is at least one image -->
  <xsl:template match="Assets[ancestor::Node/@nodeType='variation']">
    <xsl:variable name="csvalues" select="../ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product/CSItem/CSValue" />
    <xsl:variable name="csvalue-count" select="count($csvalues)" />
    <xsl:variable name="csvalue-image-count" select="count(Asset[@type=$csvalue-image-doctype][@code=$csvalues/CSValueCode])" />
    
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Asset[@type!=$csvalue-image-doctype]" />
      
      <xsl:if test="$csvalue-image-count gt 0 and $csvalue-count=$csvalue-image-count">
        <xsl:apply-templates select="Asset[@type=$csvalue-image-doctype]" />
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

