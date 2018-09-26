<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="timestamp"/>
  <xsl:param name="isdirect"/>
  <!-- $priority will have a value only in the case of a Priority Translation request. If it does not have a value, then default the value to 3 -->
  <xsl:param name="priority"/>
  <xsl:param name="workflow"/>
  <xsl:param name="phase2"/>
  <!-- $runcatalogexport will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>

  <xsl:variable name="v_priority" select="if ($priority) then $priority else '3'"/>
  
  <!-- -->
  <xsl:template match="/root">
    <root>
    <xsl:attribute name="phase2" select="$phase2"/>
    <xsl:attribute name="workflow" select="$workflow"/>
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset/sql:row">
    <xsl:variable name="v_seo" select="if (sql:seo_translation) then sql:seo_translation else 'false'"/>
    <xsl:choose>
      <xsl:when test="$isdirect != '1'">
        <cinclude:include src="cocoon:/createEntryRecords/{sql:content_type}/{sql:localisation}/{sql:categorycode}/{$timestamp}/{sql:batch_number}?priority={$v_priority}&amp;seo={$v_seo}" />
      </xsl:when>
      <xsl:when test="$isdirect = '1'">
        <!-- Direct import -->
        <cinclude:include src="cocoon:/createEntryRecords/{sql:content_type}/{sql:localisation}/{sql:division}/{$timestamp}?priority=3&amp;seo={$v_seo}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>