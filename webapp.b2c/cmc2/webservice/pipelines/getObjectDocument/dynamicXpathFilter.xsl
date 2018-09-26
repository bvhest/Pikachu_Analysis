<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:saxon="http://saxon.sf.net/"
                >
                
  <xsl:param name="xpath"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Product">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      
      <xsl:choose>
        <xsl:when test="$xpath != ''">
          <!-- Always output the CTN -->
          <xsl:copy-of select="CTN"/>
          <!-- Output whatever matches the supplied XPath exprssion -->
          <xsl:apply-templates select="saxon:evaluate($xpath)"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Output everything -->
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
