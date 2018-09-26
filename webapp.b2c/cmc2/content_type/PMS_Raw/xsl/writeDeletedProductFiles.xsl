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

  <xsl:template match="delete">
    <source:write>
      <source:source>
        <xsl:value-of select="$dir"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$prefix"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="replace(@id, '/', '_')"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
      	<xsl:variable name="timestamp" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]')"/>
        <Products DocTimeStamp="{$timestamp}">
          <xsl:element name="Product">
          	<xsl:attribute name="lastModified"><xsl:value-of select="$timestamp"/></xsl:attribute>
          	<xsl:attribute name="masterLastModified"><xsl:value-of select="$timestamp"/></xsl:attribute>
          	
          	<xsl:element name="MasterData">
          	  <xsl:element name="CTN">
          		<xsl:value-of select="@id"/>
          	  </xsl:element>
          	  <xsl:element name="PMTStatus">
          		<xsl:text>Deleted</xsl:text>	
          	  </xsl:element>
          	</xsl:element>
          </xsl:element>
        </Products>
      </source:fragment>
    </source:write>
  </xsl:template>
</xsl:stylesheet>