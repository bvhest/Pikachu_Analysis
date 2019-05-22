<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="STEP-ProductInformation"/>
  </xsl:template>

  <xsl:template match="STEP-ProductInformation">
    <xsl:text>id,name,locale,rank</xsl:text>
    <xsl:apply-templates select="//Classification[MetaData/ValueGroup[@AttributeID='PH-CATALOG-ProductRank']]"/>
  </xsl:template>

  <xsl:template match="Classification">
    <xsl:variable name="ClassificationID" select="@ID"/>
    <xsl:variable name="ClassificationName" select="Name"/>
    <xsl:apply-templates select="MetaData/ValueGroup[@AttributeID='PH-CATALOG-ProductRank']/Value">
      <xsl:with-param name="ClassificationID" select="$ClassificationID" />
      <xsl:with-param name="ClassificationName" select="$ClassificationName" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- create lines with asset data: -->
  <xsl:template match="Value">
    <xsl:param name = "ClassificationID" />
    <xsl:param name = "ClassificationName" />

"<xsl:value-of select="$ClassificationID" />","<xsl:value-of select="$ClassificationName" />","<xsl:value-of select="@QualifierID" />","<xsl:value-of select="." />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>