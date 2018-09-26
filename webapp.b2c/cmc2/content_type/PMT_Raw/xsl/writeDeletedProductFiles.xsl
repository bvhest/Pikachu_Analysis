<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0"
    exclude-result-prefixes="source">

  <xsl:param name="target-path"/>
  
  <xsl:variable name="now" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]')"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
      
  <xsl:template match="/">
    <source:write>
      <source:source>
        <xsl:value-of select="$target-path"/>
      </source:source>
      <source:fragment>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="Products/@DocTimeStamp">
    <xsl:attribute name="DocTimeStamp" select="$now"/>
  </xsl:template>

  <xsl:template match="Product/@lastModified">
    <xsl:attribute name="lastModified" select="$now"/>
  </xsl:template>

  <xsl:template match="Product/@masterLastModified">
    <xsl:attribute name="masterLastModified" select="$now"/>
  </xsl:template>
  
  <xsl:template match="MarketingStatus">
    <xsl:copy>
      <xsl:text>Deleted</xsl:text>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>