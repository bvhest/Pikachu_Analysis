<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="action"/>
  <xsl:param name="localetype"/>  
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="$action = 'readFile'">
          <xsl:choose>
            <xsl:when test="$localetype !='Master' or ($localetype='Master' and //dir:file[contains(@name,'Master-CTV') and contains(@name,$timestamp)])">
              <xsl:apply-templates select="//dir:file"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$localetype='Master'">
                <xsl:call-template name="createFakeMasterContentReadyLine"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>            
        </xsl:when>
        <xsl:when test="$action = 'archiveFile'">
          <xsl:if test="not(//dir:file[contains(@name,'Master-CTV' and contains(@file,$timestamp))])">
            <!-- There are no master CTV files for this run in the outbox, so create a fake master ctv file -->
            <xsl:call-template name="createFakeMasterFile"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="//dir:file[not(contains(@name,'Master')) and contains(@name,'CTV') and contains(@name,$timestamp)]">
              <xsl:apply-templates select="//dir:file"/>              
            </xsl:when>
            <xsl:otherwise>
              <!-- There are no localized CTV files for this run in the outbox, so don't move the CONTENT-READY file  -->
              <xsl:apply-templates select="//dir:file[not(contains(@name,'Locale_CONTENT-READY'))]"/>              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>     
      </xsl:choose>
    </root>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:choose>
      <xsl:when test="contains(@name, $timestamp) and not($action = 'archiveFile')">          
        <cinclude:include>
          <xsl:attribute name="src"><xsl:text>cocoon:/</xsl:text><xsl:value-of select="$action"/>_<xsl:value-of select="$localetype"/>.<xsl:value-of select="$timestamp"/>.<xsl:value-of select="@name"/></xsl:attribute>
        </cinclude:include>
      </xsl:when>
      <xsl:when test="$action = 'archiveFile'">   
        <cinclude:include>
          <xsl:attribute name="src"><xsl:text>cocoon:/</xsl:text><xsl:value-of select="$action"/>_<xsl:value-of select="$timestamp"/>.<xsl:value-of select="@name"/></xsl:attribute>
        </cinclude:include>      
      </xsl:when>
    </xsl:choose>      
  </xsl:template>
  
  <xsl:template name="createFakeMasterContentReadyLine">
  <!--
    <cinclude:include>
      <xsl:attribute name="src"><xsl:text>cocoon:/createFakeContentReady</xsl:text>.<xsl:value-of select="$localetype"/>.<xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>            
  -->
  <!-- e.g. 20080131184509_Master-CTV-Ctg_1.xml -->
    <xsl:value-of select="concat($timestamp,'_Master-CTV-Ctg_1.xml')"/>
  </xsl:template>
  
  <xsl:template name="createFakeMasterFile">
    <cinclude:include>
      <xsl:attribute name="src">cocoon:/createFakeExportFile.Master.<xsl:value-of select="$timestamp"/></xsl:attribute>
    </cinclude:include>            
  </xsl:template>
  
</xsl:stylesheet>