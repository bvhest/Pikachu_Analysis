<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:source="http://apache.org/cocoon/source/1.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:philips="http://www.philips.com/catalog/recat"
    exclude-result-prefixes="sql source">
  
  <xsl:param name="ts" />
  <xsl:param name="dir" />
  
  <xsl:template match="@*|node()">
    <xsl:param name="locale" />
    <xsl:param name="catalog-types" />
    
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="locale" select="$locale" />
        <xsl:with-param name="catalog-types" select="$catalog-types" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:if test="mastertree/@original-filename != ''">
        <xsl:apply-templates select="masterlocales/sql:rowset/sql:row/sql:locale" />
        <xsl:apply-templates select="mastertree/@original-filename" />
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <!-- Write an en_* file for each locale -->
  <xsl:template match="sql:locale">
    <xsl:variable name="target-name" select="replace(/root/mastertree/@original-filename
                                                   , '_MASTER\.xml$'
                                                   , concat('_en_', substring(., 4), '.xml')
                                                   )" />    
    <source:write>
      <source:source>
        <xsl:value-of select="concat($dir, '/', $target-name)" />
      </source:source>
      <source:fragment>
        <xsl:apply-templates select="/root/mastertree/*">
          <xsl:with-param name="locale" select="." />
          <xsl:with-param name="catalog-types" select="../sql:catalog_types" />
        </xsl:apply-templates>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <!-- Delete master category elements that are not configured for the locale -->
  <xsl:template match="philips:category">
    <xsl:param name="locale" />
    <xsl:param name="catalog-types" />
    
    <xsl:if test="contains($catalog-types, philips:catalogType)">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()">
          <xsl:with-param name="locale" select="$locale" />
          <xsl:with-param name="catalog-types" select="../sql:catalog_types" />
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
  <!-- Fix the country part of the philips:id -->
  <xsl:template match="philips:id">
    <xsl:param name="locale" />
    
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="replace(., '_GLOBAL_SHOP', concat('_', substring($locale, 4), '_SHOP'))" />
    </xsl:copy>
  </xsl:template>
  
  <!-- Convert the locale to the master version -->
  <xsl:template match="philips:locale">
    <xsl:param name="locale" />
    <xsl:param name="catalog-types" />

    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="concat('en_', substring($locale, 4))" />
    </xsl:copy>
  </xsl:template>
  
  <!-- Delete the orginal MASTER file -->
  <xsl:template match="@original-filename">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($dir,'/',.)" />
      </shell:source>
    </shell:delete>
  </xsl:template>
</xsl:stylesheet>