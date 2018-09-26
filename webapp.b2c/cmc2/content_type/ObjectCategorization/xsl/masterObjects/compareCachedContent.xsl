<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:template match="ObjectCategorizationToCompare">
    <xsl:variable name="cachedContent">
      <xsl:apply-templates select="object[1]/*" mode="copy"/>
    </xsl:variable>
    <xsl:variable name="newContent">
      <xsl:apply-templates select="object[2]/*" mode="copy"/>
    </xsl:variable>
    <FilterObjectCategorization>
      <xsl:choose>
        <xsl:when test="deep-equal($cachedContent,$newContent)">
          <identical><xsl:value-of select="object[1]/id"/></identical>
        </xsl:when>
        <xsl:otherwise>not equal</xsl:otherwise>
      </xsl:choose>
    </FilterObjectCategorization>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
