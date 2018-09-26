<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:my="http://pww.pikachu.philips.com/functions/local"
    extension-element-prefixes="my">

  <xsl:function name="my:get-external-table-name">
    <xsl:param name="destination"/>
    <xsl:choose>
      <xsl:when test="$destination = 'catalog_objects_lcb.dat'">
        <xsl:text>catalog_objects_lcb_ext</xsl:text>
      </xsl:when>
      <xsl:when test="$destination = 'catalog_objects_ccb.dat'">
        <xsl:text>catalog_objects_ccb_ext</xsl:text>
      </xsl:when>
      <xsl:when test="$destination = 'catalog_objects_productmasterdata.dat'">
        <xsl:text>catalog_objects_pmd_ext</xsl:text>
      </xsl:when>
      <xsl:when test="$destination = 'catalog_objects_care_master.dat'">
        <xsl:text>catalog_objects_care_mstr_ext</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>