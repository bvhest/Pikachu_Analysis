<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cinclude="http://apache.org/cocoon/include/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ctURL"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>  
  <xsl:param name="division"/>  <!--only passed in by directimport-->
  <xsl:param name="isdirect"/>  
  <!-- -->  
  <xsl:template match="/root">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="entries">
    <xsl:variable name="div">
      <xsl:choose>
        <xsl:when test="$isdirect != '1'"><xsl:value-of select="sql:rowset[@name='notdirect']/sql:row[1]/sql:division"/></xsl:when>
        <xsl:when test="$isdirect = '1'"><xsl:value-of select="$division"/></xsl:when>
      </xsl:choose>   
    </xsl:variable>  
    <entries>
      <xsl:copy-of select="@*"/>         
      <xsl:attribute name="division" select="$div"/>
      <xsl:attribute name="routingCode" select="concat(sql:rowset/sql:row[1]/sql:groupcode,'/',sql:rowset/sql:row[1]/sql:internal_category)"/>
      <xsl:attribute name="routingName" select="concat(sql:rowset/sql:row[1]/sql:groupname,'/',sql:rowset/sql:row[1]/sql:categoryname)"/>
      <!-- PMT_Translated-process: if the seo-attribute is true, this info must be passed along to be included in the translation request to SDL. 
         | PText_Translated-process: the seo-attribute is already present in the entries-element at this point. 
         |-->
      <xsl:if test="sql:rowset/sql:row[1]/sql:seo_translation='yes'">
         <xsl:attribute name="seo">yes</xsl:attribute>
      </xsl:if>

      <xsl:copy-of select="node()[not(local-name() = 'rowset')]"/>
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </entries>      
  </xsl:template>
  <!-- -->  
  <xsl:template match="sql:rowset/sql:row">
    <xsl:choose>  
      <xsl:when test="$isdirect != '1'">    
        <cinclude:include src="{$ctURL}{sql:content_type}/process/{sql:localisation}/{$ts}/{sql:internal_category}/{sql:object_id}" />
      </xsl:when>
      <xsl:when test="$isdirect = '1'">          
        <cinclude:include src="{$ctURL}{sql:content_type}/process/{sql:localisation}/{$ts}/null/{sql:object_id}" />      
      </xsl:when>      
    </xsl:choose>  
  </xsl:template>
</xsl:stylesheet>