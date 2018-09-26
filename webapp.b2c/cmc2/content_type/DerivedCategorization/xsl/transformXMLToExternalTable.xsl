<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:template match="@*|node()">  
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row">
    <xsl:value-of select="sql:object_id"/>|<xsl:value-of select="sql:subcategory"/>|<xsl:value-of select="sql:catalogcode"/>|<xsl:value-of select="sql:source"/>|<xsl:value-of select="sql:isautogen"/>|<xsl:value-of select="sql:object_type"/>|
</xsl:template>
</xsl:stylesheet>
