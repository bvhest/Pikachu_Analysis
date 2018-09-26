<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="now" select="current-dateTime()"/>
  <xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>

  <xsl:template match="/">
    <root>
      <!-- Export Locale-specific Assets -->
      <xsl:apply-templates mode="export"/>
      <!-- Export Global Assets -->
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/exportGlobal.<xsl:value-of select="$snow"/>.master_global</xsl:attribute>
      </cinclude:include>
      <!-- Update locale timestamps -->
      <xsl:apply-templates mode="updatets"/>
      <!-- Update global (ProductAsset) timestamps -->
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/updateTimestamps.<xsl:value-of select="$snow"/>.master_global</xsl:attribute>
      </cinclude:include>
      <!-- Update global (ObjectAsset) timestamps -->
      <!-- cinclude:include>
        <xsl:attribute name="src">cocoon:/updateTimestamps.<xsl:value-of select="$snow"/>.master_global</xsl:attribute>
      </cinclude:include -->      
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale" mode="export">
    <cinclude:include>
      <xsl:attribute name="src">cocoon:/exportLocale.<xsl:value-of select="$snow"/>.<xsl:value-of select="."/></xsl:attribute>
    </cinclude:include>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale" mode="updatets">
    <cinclude:include>
      <xsl:attribute name="src">cocoon:/updateTimestamps.<xsl:value-of select="$snow"/>.<xsl:value-of select="."/></xsl:attribute>
    </cinclude:include>
  </xsl:template>

</xsl:stylesheet>