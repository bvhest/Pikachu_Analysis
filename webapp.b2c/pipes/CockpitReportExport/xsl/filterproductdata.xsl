<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="fn saxon sql">
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:import href="xpaths.xsl"/>
  <xsl:variable name="nodes2keep">
    <xsl:for-each select="$ProductEnhancementContent/*/Attribute">
      <xpath>
        <xsl:copy-of select="@*"/>
        <xsl:value-of select="substring-after(.,'Product/')"/>
      </xpath>    
    </xsl:for-each>
    <xpath name="NamingString" copy="Range">NamingString</xpath>      
  </xsl:variable>
  <!-- -->
  <xsl:template match="/root">
    <root>
      <x><xsl:copy-of select="$nodes2keep"/></x>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:data/Product">
    <xsl:variable name="prd" select="."/>
    <xsl:copy>
      <xsl:for-each select="$nodes2keep/xpath">
        <xsl:variable name="xpath" select="."/>
        <xsl:for-each select="$prd">
          <xsl:apply-templates select="saxon:evaluate($xpath)" mode="filter">
            <xsl:with-param name="copy" select="$xpath/@copy"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:variable name="locale" select="./@Locale"/>
      <xsl:copy-of select="./AssetList/Asset[ResourceType='PSS'][Language=$locale]"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="filter">
    <xsl:param name="copy"/>
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$copy = 'text'">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="$copy = 'none'"/>
        <xsl:otherwise>
          <xsl:variable name="node" select="."/>
          <xsl:copy-of select="$node/saxon:evaluate($copy)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
