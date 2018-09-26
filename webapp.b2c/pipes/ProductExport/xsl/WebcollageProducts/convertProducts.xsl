<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                exclude-result-prefixes="xsl sql cinclude source">
  <!--
  FileName    :  convertProducts.xsl
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
  
  <!--
    Added exclude-award-types variable in xucdm-product-external.xsl and overriding the same variable for webcollageproducts export.
    because in webcollage we need ala_semantic and ala_user awards (ie., comments ) so this logic has been implemented as part of
    webcollageproducts change
  -->
  <xsl:import href="../xUCDM.1.1.convertProducts.xsl"/>
  
  <xsl:variable name="exclude-award-types" select="('ala_semantic','ala_user')"/>  
  <xsl:template match="MarketingTextHeader">
    <xsl:element name="MarketingTextHeader"><xsl:value-of select="if(../RichTexts/RichText[@type='ProductDescription']) 
                                                                  then ../RichTexts/RichText[@type='ProductDescription'][1]/Item[1]/Head[1] 
                                                                  else ."/></xsl:element>
  </xsl:template>
  
  <!-- Remove RichTexts -->
  <xsl:template match="RichTexts"/>

	 <xsl:template match="sql:wsf">
		<xsl:element name="ProductRefsList">		  
		<xsl:attribute name="CTN" select="current()/Product/CTN"/>
		  
		  <xsl:apply-templates select="current()/Product/ProductRefs/ProductReference[@ProductReferenceType = 'Performer']"/>				

		</xsl:element>
	 </xsl:template>

</xsl:stylesheet>