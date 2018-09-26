<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:source="http://apache.org/cocoon/source/1.0"
    exclude-result-prefixes="sql source">

  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:*">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="sql:object_id"/>
  
  <xsl:template match="Product">
    <source:write>
      <source:source>
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$prefix"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="CTN"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <Products DocTimeStamp="{format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]')}">
          <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </Products>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="MarketingStatus">
    <xsl:copy>
      <xsl:text>Deleted</xsl:text>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>