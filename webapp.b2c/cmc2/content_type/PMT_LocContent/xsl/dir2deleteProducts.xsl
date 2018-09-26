<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:my="http://pww.pikachu.philips.com/functions/local"
    extension-element-prefixes="my">

  <xsl:param name="ct"/>
  
  <xsl:import href="functions.xsl"/>
  
  <xsl:template match="/root">
    <root name="delete-products">
      <xsl:variable name="inbox-files" select="dir:directory[@name='inbox']/dir:file"/>
      <xsl:apply-templates select="dir:directory[@name='cache']/dir:file">
        <xsl:with-param name="inbox-files" select="$inbox-files"/>
      </xsl:apply-templates>
      <files-in-cache n="{count(dir:directory[@name='cache']/dir:file)}"/>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:param name="inbox-files"/>
    <xsl:if test="empty($inbox-files[@name=current()/@name])">
      <xsl:variable name="ctn" select="my:ctn-from-filename(@name)"/>
      <delete file="{@name}" id="{$ctn}" locale="{replace(@name,'^.+_(.._..)\.xml$','$1')}" ct="{$ct}"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>