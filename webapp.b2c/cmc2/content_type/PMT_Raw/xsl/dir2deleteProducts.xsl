<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>
  
  <xsl:template match="/report">
    <report name="deleted-products">
      <xsl:variable name="inbox-files">
        <xsl:sequence select="dir:directory[@name='inbox']/dir:file"/>
      </xsl:variable>
      <xsl:if test="count($inbox-files/dir:file) &gt; 0">
        <xsl:apply-templates select="dir:directory[@name='cache']/dir:file">
          <xsl:with-param name="inbox-files" select="$inbox-files"/>
        </xsl:apply-templates>
      </xsl:if>
    </report>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:param name="inbox-files"/>
    <xsl:if test="empty($inbox-files/dir:file[@name=current()/@name])">
      <delete ct="{$ct}">
        <xsl:value-of select="substring-before(@name,'.xml')"/>
      </delete>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>