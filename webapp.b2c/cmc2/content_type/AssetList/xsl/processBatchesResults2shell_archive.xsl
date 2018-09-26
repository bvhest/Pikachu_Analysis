<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">
  
  <xsl:param name="sourceDir" />
  <xsl:param name="cacheDir" />
  <xsl:param name="errorDir" />
  
  <xsl:variable name="files" select="/root/dir:directory/dir:file" />
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="root/entry" group-by="@o">
        <xsl:choose>
          <xsl:when test="count(current-group()[@valid='true' or result='Identical octl exists']) = count(current-group())">
            <!-- All locales valid or not modified: store source file in cache -->
            <xsl:call-template name="archive">
              <xsl:with-param name="id" select="current-grouping-key()" />
              <xsl:with-param name="target-dir" select="$cacheDir" />
              <xsl:with-param name="store-full-name" select="false()" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- store in the error dir -->
            <xsl:call-template name="archive">
              <xsl:with-param name="id" select="current-grouping-key()" />
              <xsl:with-param name="target-dir" select="$errorDir" />
              <xsl:with-param name="store-full-name" select="true()" />
            </xsl:call-template>            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="archive">
    <xsl:param name="id"/>
    <xsl:param name="target-dir"/>
    <xsl:param name="store-full-name"/>
    
    <xsl:variable name="file-name" select="concat(replace($id, '/', '_'),'.xml')" />
    <xsl:variable name="file" select="$files[ends-with(@name,concat('.',$file-name))]/@name"/>
    
    <xsl:if test="exists($file)">
      <shell:move overwrite="true">
        <shell:source><xsl:value-of select="concat($sourceDir,'/',$file)"/></shell:source>
        <shell:target><xsl:value-of select="concat($target-dir,'/', if ($store-full-name) then $file else $file-name)"/></shell:target>
      </shell:move>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>