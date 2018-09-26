<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

  <xsl:strip-space elements="*"/>
  
  <xsl:param name="systemId"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
   
  <xsl:template match="Files2Compare">
    <xsl:variable name="newContent">
      <xsl:apply-templates select="Products[1]/Product"/>
    </xsl:variable>
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="Products[2]/Product"/>
    </xsl:variable>
    <FilterProduct>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></identical>
        </xsl:when>
        <xsl:otherwise>
          <modified><xsl:value-of select="translate(Products[1]/Product/CTN,'/','_')"/></modified>
        </xsl:otherwise>
      </xsl:choose>
    </FilterProduct>
  </xsl:template>  

  <!-- Ignore -->
  <xsl:template match="@lastModified|@masterLastModified"/>
  <xsl:template match="ProductOwner"/>
  
  <!-- Order the KeyValuePairs -->
  <xsl:template match="KeyValuePairs">
    <xsl:apply-templates select="KeyValuePair">
      <xsl:sort select="Key"/>
      <xsl:sort select="Value"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
