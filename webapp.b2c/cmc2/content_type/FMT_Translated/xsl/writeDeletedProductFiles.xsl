<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:source="http://apache.org/cocoon/source/1.0"
    exclude-result-prefixes="sql source">

  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  <xsl:param name="locale"/>
  
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
  
  <!--
    Write the deleted family to the inbox with its MarketingStatus as 'Deleted' so it will be set to deleted when imported.
    Families from NA and AP are ignored because these do not exist in Pikachu and the import would delete the EU counterparts.
  -->
  <xsl:template match="Node[ends-with(@code,'_EU')]">
    <source:write>
      <source:source>
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$prefix"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="@code"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <Nodes DocStatus="approved" DocTimeStamp="{format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]')}">
          <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </Nodes>
      </source:fragment>
    </source:write>
  </xsl:template>
  <xsl:template match="Node[not(ends-with(@code,'_EU'))]">
    <root/>
  </xsl:template>
  
  <xsl:template match="MarketingStatus">
    <xsl:copy>
      <xsl:text>Deleted</xsl:text>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>