<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:include="http://apache.org/cocoon/include/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>  
  <xsl:param name="batchnumber"/>
  <xsl:param name="ctURL"/>
  <xsl:param name="reload"/>    
  <!-- -->
  <xsl:template match="/root">
    <entries ct="{$ct}" l="none" ts="{$ts}" batchnumber="{$batchnumber}">
      <process/>
      <globalDocs/>    
      <xsl:apply-templates select="file"/>
      <store-outputs/>
    </entries>        
  </xsl:template>
  <!-- -->
  <xsl:template match="file">
    <xsl:choose>
      <xsl:when test="not($reload='true')">
        <include:include src="{$ctURL}/process/{$batchnumber}/{$ts}/{@name}?reload={$reload}"/>
      </xsl:when>
      <xsl:otherwise>
        <include:include src="{$ctURL}/processReload/{$batchnumber}/{$ts}/{@name}?reload={$reload}"/>      
      </xsl:otherwise>      
    </xsl:choose>
  </xsl:template>
  <!-- -->

</xsl:stylesheet>