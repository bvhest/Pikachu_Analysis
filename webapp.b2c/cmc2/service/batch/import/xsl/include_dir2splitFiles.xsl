<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="target-ct"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="dir"/>  
  <xsl:param name="latest"/>    
  <xsl:param name="filename"/>    
  <xsl:param name="filestem"/>    
  <!--  -->    
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!--  -->
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
      <cinclude:include><xsl:attribute name="src" select="concat('cocoon:/splitFiles/',$ct,'/',$timestamp,'/',$filestem2,'.',$fileextn, if ($target-ct != '') then concat('?target-ct=',$target-ct) else '')"/></cinclude:include>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>