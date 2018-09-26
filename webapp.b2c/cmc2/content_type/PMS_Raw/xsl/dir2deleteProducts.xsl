<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>
  
  <xsl:template match="/root">
    <root name="delete-products">
      <xsl:if test="exists(dir:directory[@name='inbox']/dir:file)">
	      <xsl:variable name="inbox-files">
	        <xsl:apply-templates select="dir:directory[@name='inbox']/dir:file" mode="clean-file-entry"/>
	      </xsl:variable>
	      <xsl:apply-templates select="dir:directory[@name='cache']/dir:file">
	        <xsl:with-param name="inbox-files" select="$inbox-files"/>
	      </xsl:apply-templates>
      </xsl:if>
    </root>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <xsl:param name="inbox-files"/>
    <xsl:if test="empty($inbox-files/dir:file[@name=current()/@name])">
      <delete id="{replace(substring-before(@name,'.'),'_','/')}" locale="none" ct="{$ct}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dir:file" mode="clean-file-entry">
    <xsl:copy>
      <xsl:attribute name="name" select="concat((tokenize(@name,'\.'))[last() - 1],'.xml')"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>