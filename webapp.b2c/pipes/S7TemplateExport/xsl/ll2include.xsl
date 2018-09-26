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
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates mode="export"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale" mode="export">
    <cinclude:include>
      <xsl:attribute name="src">cocoon:/<xsl:value-of select="if(.='MASTER') then 'exportGlobal' else 'exportLocale'"/>.<xsl:value-of select="$snow"/>.<xsl:value-of select="if(.='MASTER') then 'master_global' else ."/></xsl:attribute>
    </cinclude:include>
  </xsl:template>
</xsl:stylesheet>