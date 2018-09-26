<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ws="http://apache.org/cocoon/source/1.0">
  
  <xsl:import href="prepareComparison.xsl"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:param name="temp-dir" select="'/tmp'"/>
  <xsl:param name="overrideCheck"/>
  
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
          <identical ctn="{Products[1]/Product/CTN}"/>
        </xsl:when>
        <!-- Temporary fix: ignore products with a douhble NamingString element -->
        <xsl:when test="count(Products[1]/Product/NamingString) &gt; 1">
          <identical ctn="{Products[1]/Product/CTN}"/>
        </xsl:when>
        <xsl:otherwise>
          <changed ctn="{Products[1]/Product/CTN}"/>
          <xsl:if test="$overrideCheck != 'yes'">
            <ws:write>
              <ws:source><xsl:value-of select="concat($temp-dir,'/',Products[1]/Product/CTN,'.xml')"/></ws:source>
              <ws:fragment>
                <xsl:copy-of select="$newContent"/>
              </ws:fragment>
            </ws:write>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </FilterProduct>
  </xsl:template>  
    
</xsl:stylesheet>
