<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="dir"/>  
  <xsl:param name="latest"/>    
  <xsl:param name="includefilepattern"/>      
  <!--  -->    
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="$latest='yes'">
          <xsl:for-each select="sourceResult/source">
            <xsl:variable name="v_file" select="document(.)"/>
            <xsl:variable name="list">
              <list>
                <xsl:apply-templates select="$v_file/root/group/file[@select='yes']"/>
              </list>
            </xsl:variable>
            <xsl:for-each-group select="$list/list/entry" group-by="@filetype">
              <xsl:for-each select="current-group()">
                <xsl:sort select="@filedate" order="ascending"/>
                <xsl:if test="$includefilepattern = '' or contains(@filebase,$includefilepattern)">
                  <cinclude:include src="cocoon:/createFileEntryRecords/{$ct}/{$timestamp}/{@filebase}.{@fileExt}"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each-group>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="list">
            <list>
              <xsl:apply-templates/>
            </list>
          </xsl:variable>
          <!--list><xsl:copy-of select="$list"/></list-->
          <xsl:for-each-group select="$list/list/entry" group-by="@filetype">
            <xsl:for-each select="current-group()">
              <xsl:sort select="@filedate" order="ascending"/>
                <xsl:if test="$includefilepattern = '' or contains(@filebase,$includefilepattern)">
                  <cinclude:include src="cocoon:/createFileEntryRecords/{$ct}/{$timestamp}/{@filebase}.{@fileExt}"/>
                </xsl:if>                
            </xsl:for-each>
          </xsl:for-each-group>    
        </xsl:otherwise>    
      </xsl:choose>    
    </root>
  </xsl:template>
  <!--  -->
  <xsl:template match="node()[local-name()='file']">
    <entry>
      <xsl:variable name="filebase" select="substring-before(@name, '.')"/>
      <xsl:variable name="filedate" select="substring(@name, string-length($filebase)-13, 14)"/>
      <xsl:variable name="filetype" select="substring-before(@name, $filedate)"/>
      <xsl:attribute name="filedate" select="$filedate"/>
      <xsl:attribute name="filetype" select="$filetype"/>
      <xsl:attribute name="name" select="@name"/>
      <xsl:attribute name="fileExt" select="substring-after(@name, '.')"/>
      <xsl:attribute name="filebase" select="$filebase"/>      
    </entry>
  </xsl:template>
</xsl:stylesheet>