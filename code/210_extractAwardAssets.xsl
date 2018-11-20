<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
  <xsl:output method="text" indent="no"/>
   
  <!-- create headers and call tree-nodes to convert into lines: -->
  <xsl:template match="/">
    <xsl:text>id,type,locale,description,extension,parent_id</xsl:text>
    <xsl:apply-templates select="//Product"/>
  </xsl:template>

  <xsl:template match="Product">
    <xsl:variable name="productID" select="CTN"/>
    <xsl:apply-templates select="/Assets/Asset[@type = ['KA1','KA2','KA3','KA4','KA5','KA6','KA7','KA8','GFA','AWL','GAP','GAZ']]">
      <xsl:with-param name="productID" select="$productID" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- create lines with tree-node data: -->
  <xsl:template match="Asset">
    <xsl:param name = "productID" />
"<xsl:value-of select="@code" />","<xsl:value-of select="@type" />","<xsl:value-of select="@locale" />","<xsl:value-of select="@description" />","<xsl:value-of select="@extension" />","<xsl:value-of select="$productID" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>