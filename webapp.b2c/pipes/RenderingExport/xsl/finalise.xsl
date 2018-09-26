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
  <xsl:param name="action"/>
  <xsl:template match="/">
    <root>
      <xsl:variable name="runtimestamp" select="/root/sql:rowset[@name='timestamp']/sql:row/sql:startexec"/>
      <xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($runtimestamp),1,19),':',''),'-',''),' ','')"/>    

        <xsl:choose>
          <xsl:when test="$action='CreateContentReady_Master'">
            <xsl:call-template name="CreateContentReady_Master">
              <xsl:with-param name="timestamp" select="$timestamp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$action='CreateContentReady_Locale'">
            <xsl:call-template name="CreateContentReady_Locale">
              <xsl:with-param name="timestamp" select="$timestamp"/>
            </xsl:call-template>
          </xsl:when>          
          <xsl:when test="$action='ArchiveFiles'">          
            <xsl:call-template name="ArchiveFiles">
              <xsl:with-param name="timestamp" select="$timestamp"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:when test="$action='UpdateExportTimestamps'">          
            <xsl:call-template name="UpdateExportTimestamps">
              <xsl:with-param name="timestamp" select="$timestamp"/>
            </xsl:call-template>              
          </xsl:when>          
        </xsl:choose>

    </root>
  </xsl:template>
  
  <!-- Create CONTENT-READY file -->
  <xsl:template name="CreateContentReady_Master">
    <xsl:param name="timestamp"/>
    <cinclude:include>
      <xsl:attribute name="src"><xsl:text>cocoon:/createContentReadysub.Master.</xsl:text><xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>    
  </xsl:template>  

  <!-- Create CONTENT-READY file -->
  <xsl:template name="CreateContentReady_Locale">
    <xsl:param name="timestamp"/>
    <cinclude:include>
      <xsl:attribute name="src"><xsl:text>cocoon:/createContentReadysub.Locale.</xsl:text><xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>    
  </xsl:template>  
  
  <!-- Archive files -->
  <xsl:template name="ArchiveFiles">
    <xsl:param name="timestamp"/>
    <cinclude:include>
      <xsl:attribute name="src"><xsl:text>cocoon:/archiveFiles.</xsl:text><xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>    
  </xsl:template>    

  <!-- Update Export Timestamps-->
  <xsl:template name="UpdateExportTimestamps">
    <xsl:param name="timestamp"/>
    <cinclude:include>
      <xsl:attribute name="src"><xsl:text>cocoon:/updateExportTimestamps.</xsl:text><xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>    
  </xsl:template>    

  
</xsl:stylesheet>