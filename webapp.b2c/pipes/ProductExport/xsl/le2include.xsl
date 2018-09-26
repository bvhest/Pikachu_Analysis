<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  >

  <!-- -->
  <xsl:param name="exportdate"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:localeenabled">
    <xsl:if test=".=1">
      <cinclude:include>
        <xsl:attribute name="src">
          <xsl:text>cocoon:/gotoLocaleFiles.</xsl:text>
          <xsl:value-of select="$exportdate"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$country"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$locale"/>
        </xsl:attribute>
      </cinclude:include>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:masterlocaleenabled">
    <xsl:if test=".=1">
      <cinclude:include>
        <xsl:attribute name="src">
          <xsl:text>cocoon:/gotoMasterLocaleFiles.</xsl:text>
          <xsl:value-of select="$exportdate"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$country"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$locale"/>
        </xsl:attribute>
      </cinclude:include>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>