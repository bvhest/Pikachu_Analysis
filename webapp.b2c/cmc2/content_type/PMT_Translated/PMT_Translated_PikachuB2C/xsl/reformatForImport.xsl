<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Set the correct Locale and Country -->
  <xsl:template match="content/Product">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="Locale" select="../../@l"/>
      <xsl:attribute name="Country" select="substring(../../@l,4,2)"/>
      <xsl:apply-templates select="@*[not(local-name()='Country' or local-name()='Locale' or local-name()='StoreLocales')]|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- 
    Take the energy class of the PMT_Localised content if it was retrieved, since PMT_Translated exports only one locale per language.
    For direct imports the energy class is taken from the source directly.
  -->
  <xsl:template match="EnergyClass">
    <xsl:variable name="energyclass" select="ancestor::entry/currentcontent/octl/sql:rowset/sql:row/sql:data/Product/GreenData/EnergyLabel/EnergyClasses/EnergyClass" />
    <xsl:choose>
      <xsl:when test="exists($energyclass)">
        <xsl:sequence select="$energyclass"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="currentcontent/octl" />
  
</xsl:stylesheet>
