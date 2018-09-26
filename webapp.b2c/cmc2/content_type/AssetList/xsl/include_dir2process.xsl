<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:shell="http://apache.org/cocoon/shell/1.0">

  <xsl:param name="timestamp" />
  <xsl:param name="process" />
  <xsl:param name="sourceDir" />
  <xsl:param name="targetDir" />

  <xsl:template match="/">
    <root>
      <xsl:variable name="list">
        <xsl:apply-templates />
      </xsl:variable>
      <xsl:for-each-group select="$list/entry" group-by="substring(@name, 23)">
        <xsl:apply-templates select="current-group()[last()]" mode="process"/>
        <xsl:apply-templates select="current-group()[position() lt last()]" mode="discard"/>
      </xsl:for-each-group>
    </root>
  </xsl:template>
  
  <xsl:template match="//dir:file">
    <entry>
      <xsl:variable name="filebase" select="substring-before(@name, '.')" />
      <xsl:variable name="filedate" select="substring(@name, string-length($filebase)-13, 14)" />
      <xsl:variable name="filetype" select="substring-before(@name, $filedate)" />
      <xsl:attribute name="filedate" select="$filedate" />
      <xsl:attribute name="filetype" select="$filetype" />
      <xsl:attribute name="name" select="@name" />
      <xsl:attribute name="fileExt" select="substring-after(@name, '.')" />
      <xsl:attribute name="filebase" select="$filebase" />
    </entry>
  </xsl:template>
  
  <xsl:template match="entry" mode="process">
    <cinclude:include src="cocoon:/{$process}/{@name}" />
  </xsl:template>

  <xsl:template match="entry" mode="discard">
    <shell:delete>
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
    </shell:delete>
    <!--
    <shell:move overwrite="true">
      <shell:source>
        <xsl:value-of select="concat($sourceDir,'/',@name)" />
      </shell:source>
      <shell:target>
        <xsl:value-of select="concat($targetDir,'/',@name)" />
      </shell:target>
    </shell:move>
    -->
  </xsl:template>
</xsl:stylesheet>