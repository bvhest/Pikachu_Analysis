<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="filename"/>    
  <xsl:param name="filestem"/>    
  <xsl:param name="work-folder"/>

  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>

  <xsl:template match="node()[local-name()='file']">
    <xsl:if test="($filename='' and $filestem = '') or @name = $filename or ($filestem != '' and starts-with(@name,$filestem))">
      <!-- IF $FILENAME IS SET split only that file, otherwise split all files -->
      <xsl:variable name="fileextn">
        <xsl:analyze-string select="@name" regex="^(.*)\.(..*)$">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(2)"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <!-- Shouldn't be possible -->
            <xsl:value-of select="'ERROR'"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:variable name="filestem2" select="substring-before(@name,concat('.',$fileextn))"/>
      <cinclude:include><xsl:attribute name="src" select="concat('cocoon:/splitCacheFile/',$ct,'/',$timestamp,'/',$filestem2,'.',$fileextn, '/', 'cache')"/></cinclude:include>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>