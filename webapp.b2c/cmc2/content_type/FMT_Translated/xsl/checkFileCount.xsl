<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:i="http://apache.org/cocoon/include/1.0">

  <xsl:param name="threshold" />
  <xsl:param name="ts" />
  <xsl:param name="locale" />
  <xsl:param name="overrideCheck"/>
  
  <xsl:template match="/root">
    <root name="check-file-count" locale="{$locale}">
      <xsl:variable name="files-in-cache" select="count(dir:directory[@name='cache']/dir:file)"/>
      <xsl:variable name="files-modified" select="count(dir:directory[@name=$locale]/dir:file)"/>
      <xsl:variable name="relative-modified-count" select="if ($files-in-cache &gt; 0) then 100 * ($files-modified div $files-in-cache) else 0"/>
      <xsl:choose>
        <xsl:when test="$relative-modified-count gt number($threshold) and not($overrideCheck = 'yes')">
          <xsl:variable name="rel-mod-fmt" select="format-number($relative-modified-count, '##0.0')"/>
          <i:include src="cocoon:/stop/{$locale}?filecount={$files-modified}&amp;rel-count={$rel-mod-fmt}" />
        </xsl:when>
        <xsl:when test="$files-modified gt 0">
          <i:include src="cocoon:/go/{$ts}/{$locale}" />
        </xsl:when>
      </xsl:choose>
      <i:include src="cocoon:/cleanupInboxFiles/{$locale}" />
    </root>
  </xsl:template>
</xsl:stylesheet>