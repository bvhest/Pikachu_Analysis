<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                exclude-result-prefixes="xsl sql cinclude source">
   <!--
  FileName    :  productRefsFilter.xsl
  Author      :  CJ
  Description :  Create WebcollageProducts feed with given XSD format
  XSD         :  xUCDM_product_external_1_1_2
  Date        :  30-MAY-2014
  ***************
  Change History
  ***************************************************************************
  NO          Author          Date          Description
  ***************************************************************************
  01          CJ              30-MAY-2014   Added additional code to insert 
                                            ProductReference -Performer.
  ***************************************************************************
  --> 
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="Product">
      <xsl:element name="Product">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="CTN" select="CTN"/>
          
          <xsl:apply-templates select="child::node()[local-name() != 'RichTexts'][local-name() != 'GreenData'][local-name() != 'AssetList'][local-name() != 'ObjectAssetList']"/>

          <xsl:apply-templates select="ancestor::Products/ProductRefsList[@CTN = $CTN]/ProductReference"/>
                    
          <xsl:apply-templates select="child::node()[local-name() = 'RichTexts' ]"/>
          <xsl:apply-templates select="child::node()[local-name() = 'GreenData']"/>
          <xsl:apply-templates select="child::node()[local-name() = 'AssetList']"/>
          <xsl:apply-templates select="child::node()[local-name() = 'ObjectAssetList']"/> 
          
      </xsl:element>
  </xsl:template>
  
  <!-- Remove ProductRefsList -->
  <xsl:template match="ProductRefsList"/>

  <!-- Last modified empty filtering -->
  <!-- 
  <xsl:template match="Asset">
	    <xsl:element name="Asset">
				  <xsl:attribute name="code" select="@code"/>
				  <xsl:attribute name="type" select="@type"/>
				  <xsl:attribute name="locale" select="@locale"/>
				  <xsl:attribute name="number"  select="@number"/>
				  <xsl:attribute name="description" select="@description"/>
				  <xsl:attribute name="extension" select="@extension"/>
				  <xsl:if test="@lastModified !='' ">
				      <xsl:attribute name="lastModified"  select="@lastModified"/>
          </xsl:if>
		      <xsl:value-of select="current()"/>		  
		  </xsl:element>
  </xsl:template>
   -->
</xsl:stylesheet>