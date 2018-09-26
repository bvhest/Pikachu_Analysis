<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:param name="filename"/>
 
 <xsl:variable name="now" select="concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2)) "/>

  <!-- -->  
  <xsl:template match="Product">
    <!-- catalogcode, object_id, subcategory, source, isautogen, object_type, deleted, lastmodified -->  
<xsl:value-of select="../../CatalogCode"/>|<xsl:value-of select="."/>|<xsl:value-of select="../SubCategoryCode"/>|<xsl:value-of select="$filename"/>|<xsl:value-of select="0"/>|<xsl:value-of select="'Product'"/>|<xsl:value-of select="0"/>|<xsl:value-of select="$now"/><xsl:text>&#x0A;</xsl:text>
</xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">  
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>  
</xsl:stylesheet>
