<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="content/object" />
  
  <xsl:template match="Disclaimers">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    <xsl:apply-templates select="following-sibling::KeyValuePairs|following-sibling::AccessoryByPacked" mode="copy"/>
    <xsl:copy-of select="following-sibling::Award"/>
    <xsl:copy-of select="ancestor::content/object/Awards/Award" />
  </xsl:template>
  <!-- Copied above -->
  <xsl:template match="KeyValuePairs|AccessoryByPacked|Award"/>

  <xsl:template match="RichTexts">
    <xsl:copy>
      <xsl:copy-of select="ancestor::content/object/RichTexts/RichText" />
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>