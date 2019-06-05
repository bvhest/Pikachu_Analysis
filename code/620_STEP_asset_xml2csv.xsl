<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="STEP-ProductInformation"/>
  </xsl:template>

  <xsl:template match="STEP-ProductInformation">
    <xsl:text>type,id,name,locale,dimension,optional,multiValued,parentID</xsl:text>
    <xsl:apply-templates select="//UserTypes/UserType[UserTypeLink/@UserTypeID='Asset user-type root']"/>
	<xsl:apply-templates select="//CrossReferenceTypes/AssetCrossReferenceType"/>
  </xsl:template>

  <xsl:template match="UserType">
    <xsl:variable name="assetID" select="@ID"/>
    <xsl:variable name="assetName" select="Name"/>
"asset","<xsl:value-of select="$assetID" />","<xsl:value-of select="$assetName" />","<xsl:value-of select="/STEP-ProductInformation/@ContextID" />","",false,false,""<xsl:text>&#xD;</xsl:text>
  </xsl:template>

  <xsl:template match="AssetCrossReferenceType">
    <xsl:variable name="id" select="@ID"/>
    <xsl:variable name="name" select="Name"/>
    <xsl:variable name="locale" select="/STEP-ProductInformation/@ContextID"/>
    <xsl:variable name="dimension" select="DimensionLink/@DimensionID"/>
    <xsl:variable name="optional" select="if (@Mandatory='false') then 'true' else 'false'"/>
    <xsl:variable name="multiValued" select="@MultiValued"/>
	
    <xsl:apply-templates select="TargetUserTypeLink">
      <xsl:with-param name="id" select="$id" />
      <xsl:with-param name="name" select="$name" />
      <xsl:with-param name="locale" select="$locale" />
      <xsl:with-param name="dimension" select="$dimension" />
      <xsl:with-param name="optional" select="$optional" />
      <xsl:with-param name="multiValued" select="$multiValued" />
    </xsl:apply-templates>
  </xsl:template>
	
  <xsl:template match="TargetUserTypeLink">
    <xsl:param name = "id" />
    <xsl:param name = "name" />
    <xsl:param name = "locale" />
    <xsl:param name = "dimension" />
    <xsl:param name = "optional" />
    <xsl:param name = "multiValued" />

"asset-ref","<xsl:value-of select="$id" />","<xsl:value-of select="$name" />","<xsl:value-of select="$locale" />","<xsl:value-of select="$dimension" />","<xsl:value-of select="$optional" />","<xsl:value-of select="$multiValued" />","<xsl:value-of select="@UserTypeID" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>