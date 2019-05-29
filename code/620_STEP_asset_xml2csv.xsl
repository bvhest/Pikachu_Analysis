<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="STEP-ProductInformation"/>
  </xsl:template>

  <xsl:template match="STEP-ProductInformation">
    <xsl:text>type,id,name,locale,dimension,optional,multiValued</xsl:text>
    <xsl:apply-templates select="//UserTypes/UserType[UserTypeLink/@UserTypeID='Asset user-type root']"/>
	<xsl:apply-templates select="//CrossReferenceTypes/AssetCrossReferenceType"/>
  </xsl:template>

  <xsl:template match="UserType">
    <xsl:variable name="assetID" select="@ID"/>
    <xsl:variable name="assetName" select="Name"/>
"asset","<xsl:value-of select="$assetID" />","<xsl:value-of select="$assetName" />","<xsl:value-of select="/STEP-ProductInformation/@ContextID" />","",false,false<xsl:text>&#xD;</xsl:text>
  </xsl:template>

  <xsl:template match="AssetCrossReferenceType">
    <xsl:variable name="assetID" select="@ID"/>
    <xsl:variable name="assetName" select="Name"/>
"asset-ref","<xsl:value-of select="$assetID" />","<xsl:value-of select="$assetName" />","<xsl:value-of select="/STEP-ProductInformation/@ContextID" />","<xsl:value-of select="DimensionLink/@DimensionID" />","<xsl:value-of select="if (@Mandatory='false') then 'true' else 'false'" />","<xsl:value-of select="@MultiValued" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>