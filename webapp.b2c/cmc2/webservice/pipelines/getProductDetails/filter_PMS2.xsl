<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">
  
  <xsl:import href="filter.xsl"/>
  
  <xsl:param name="localeFilter"/>
  
  <xsl:template match="ContentDetail[@placeholder = 'false']">
    <xsl:element name="ContentDetail">
      <xsl:attribute name="placeholder" select="@placeholder"/>
      <xsl:if test="@calcType">
        <xsl:attribute name="calcType" select="@calcType"/>
      </xsl:if>
      <xsl:if test="@columnID">
        <xsl:attribute name="columnID" select="@columnID"/>
      </xsl:if>  
      
      <xsl:call-template name="ContentDetail">
        <xsl:with-param name="localeFilter" select="$localeFilter"/>
      </xsl:call-template>      
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="ContentDetail[@placeholder = 'true']">
    <xsl:variable name="columnID" select="../../@columnID"/>
    <xsl:variable name="completeFlag" select="//sql:row[sql:columnid = $columnID]/sql:complete_flag"/>
    
    <xsl:if test="$completeFlag = '0'">
      <xsl:element name="ContentDetail">
        <xsl:attribute name="placeholder" select="@placeholder"/>
        <xsl:if test="@calcType">
          <xsl:attribute name="calcType" select="@calcType"/>
        </xsl:if>
        
        <xsl:call-template name="ContentDetail">
          <xsl:with-param name="localeFilter" select="$localeFilter"/>
        </xsl:call-template>      
      </xsl:element>
    </xsl:if>
  </xsl:template>   

  <xsl:template name="ContentDetail">
    <xsl:param name="localeFilter"/>
    
    <xsl:choose>
      <xsl:when test="$localeFilter = ''">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- only allow empty locales, and locales from the filter -->
        <xsl:choose>
          <xsl:when test="Language = ''">
            <xsl:apply-templates/>  
          </xsl:when>
          <xsl:when test="contains($localeFilter, Language)"> 
            <xsl:apply-templates/>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- filter out large ThumbnailURLs to improve iPad performance -->
  <xsl:template match="ThumbnailURL">
    <xsl:choose>
      <xsl:variable name="blacklist" select="'A1_, A2_, A3_, A4_, A5_, U3_, U4_, U5_'"/>
    
      <xsl:when test="contains($blacklist, ../ContentType)"> 
        <xsl:element name="ThumbnailURL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
