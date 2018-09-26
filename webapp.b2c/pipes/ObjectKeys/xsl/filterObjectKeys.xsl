<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">

  <!--
    Merge ObjectKey elements with same @code 
  -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectKeys">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- copy only the first of all distinct codes -->
      <xsl:for-each-group select="ObjectKey" group-by="@code">
        <ObjectKey>
          <xsl:apply-templates select="current-group()[1]/@*[not(local-name() = ('sop','eop'))]"/>

          <!-- Set the sop/eop to the min/max of all ObjectKeys -->
          <xsl:attribute name="sop" select="format-number(min(current-group()/@sop),'00000000')"/>
          <xsl:attribute name="eop" select="format-number(max(current-group()/@eop),'00000000')"/>
          
          <xsl:apply-templates select="current-group()/*"/>
        </ObjectKey>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>