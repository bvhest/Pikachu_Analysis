<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceDir" as="xs:string"/>
  <xsl:param name="targetDir" as="xs:string"/>
  <xsl:param name="processFilePath"/>
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="action">move</xsl:param>
  <xsl:param name="svcURL"/>
  <!-- -->
  <xsl:variable name="processFile" select="document($processFilePath)"/>
  <xsl:variable name="runts" select="xs:dateTime(concat( substring($ts,1,4)
                                                        ,'-'
                                                        ,substring($ts,5,2)
                                                        ,'-'
                                                        ,substring($ts,7,2)
                                                        ,'T'
                                                        ,substring($ts,9,2)
                                                        ,':'
                                                        ,substring($ts,11,2)
                                                        ,':'
                                                        ,substring($ts,13,2)))" as="xs:dateTime"/>


  <xsl:template match="/">
    <entries ct="{$ct}" ts="{$ts}">
      <entry includeinreport="yes" runts="{$runts}">
    <page>
      <!-- Process catalog.xml files -->
      <xsl:apply-templates select="dir:directory/dir:file"/>
      <!-- Process translation import files -->
      <xsl:call-template name="move">
        <xsl:with-param name="filenames" select="distinct-values($processFile/root/root/entries/originalentriesattributes/filename)"/>
      </xsl:call-template>
    </page>
    </entry>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[not(contains(@name,'catalog'))]"/>
  <!-- -->
  <xsl:template match="dir:file[contains(@name,'catalog')]">
    <xsl:variable name="filets" select="xs:dateTime(concat(replace(@date,' ','T'),':00'))" as="xs:dateTime"/>
    <!--filets><xsl:value-of select="$filets"/></filets-->
    <xsl:if test="$filets &lt; $runts">
      <xsl:choose>
        <xsl:when test="$action='zip'">        
          <cinclude:include	src="{$svcURL}store/ZipFile/{concat($sourceDir,'/',@name)}?sourceFilename={@name}&amp;destFilename={concat($targetDir,'/',@name,'.zip')}"/>
        </xsl:when>
        <xsl:when test="$action='delete'">        
          <shell:delete>
            <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
          </shell:delete>
        </xsl:when>
        <xsl:otherwise><!-- move -->
          <shell:move overwrite="true">
            <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
            <shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
          </shell:move>
        </xsl:otherwise>          
      </xsl:choose>        
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template name="move">
    <xsl:param name="filenames"/>
    <xsl:for-each select="$filenames">
      <xsl:if test="string-length(.) &gt; 0">
        <xsl:choose>
          <xsl:when test="$action='zip'">
             <cinclude:include	src="{$svcURL}store/ZipFile/{concat($sourceDir,'/',.)}?sourceFilename={.}&amp;destFilename={concat($targetDir,'/',.,'.zip')}"/>
          </xsl:when>
          <xsl:when test="$action='delete'">        
            <shell:delete>
              <shell:source><xsl:value-of select="concat($sourceDir,'/',.)"/></shell:source>
            </shell:delete>
          </xsl:when>
          <xsl:otherwise><!-- move -->          
            <shell:move overwrite="true">
              <shell:source><xsl:value-of select="concat($sourceDir,'/',.)"/></shell:source>
              <shell:target><xsl:value-of select="concat($targetDir,'/',.)"/></shell:target>
            </shell:move>          
          </xsl:otherwise>          
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>