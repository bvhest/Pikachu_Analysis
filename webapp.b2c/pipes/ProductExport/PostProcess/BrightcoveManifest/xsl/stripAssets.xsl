<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    <!-- -->
  <xsl:template match="asset">
	  <xsl:if test="@type='VIDEO_STILL' and @refid = ../title/@video-still-refid">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
	  </xsl:if>
	  <xsl:if test="@type='VIDEO_FULL' and @refid = ../title/@video-full-refid">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
	  </xsl:if>
	  
	  
  </xsl:template>

 
</xsl:stylesheet>
