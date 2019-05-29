<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="STEP-ProductInformation"/>
  </xsl:template>

  <xsl:template match="STEP-ProductInformation">
    <xsl:text>type,id,spec_id</xsl:text>
    <xsl:apply-templates select="//UserTypes/UserType[UserTypeLink/@UserTypeID='Asset user-type root']"/>
  </xsl:template>

  <xsl:template match="UserType">
    <xsl:variable name="assetID" select="@ID"/>

    <xsl:apply-templates select="AttributeLink">
      <xsl:with-param name="assetID" select="$assetID" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- create lines with asset data: -->
  <xsl:template match="AttributeLink">
    <xsl:param name = "assetID" />
"asset","<xsl:value-of select="$assetID" />","<xsl:value-of select="@AttributeID" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>