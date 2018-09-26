<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    exclude-result-prefixes="dir sql">

  <!--
    Merge aggregated result batches into an ObjectKeys tree. 
  -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/">
    <ObjectKeys>
      <xsl:for-each-group select="dir:directory/dir:file/dir:xpath/ObjectKeys/ObjectKey" group-by="@code">
        <xsl:sort select="@code"/>
        <ObjectKey>
          <xsl:apply-templates select="current-group()[1]/@*[not(local-name() = ('sop', 'eop'))]" mode="copy"/>
          <!-- Set the sop/eop to the min/max of all ObjectKeys -->
          <xsl:attribute name="sop" select="format-number(min(current-group()/@sop),'00000000')"/>
          <xsl:attribute name="eop" select="format-number(max(current-group()/@eop),'00000000')"/>
          
          <!-- Copy the distinct ObjectRefs for the ObjectKey -->
          <xsl:for-each-group select="current-group()/ObjectRef" group-by="concat(@id,'|',@locale)">
            <xsl:sort select="@id"/>
            <xsl:sort selecr="@locale"/>
            <xsl:apply-templates select="current-group()[1]" mode="copy"/>
          </xsl:for-each-group>
        </ObjectKey>
      </xsl:for-each-group>
    </ObjectKeys>
  </xsl:template>
  
</xsl:stylesheet>