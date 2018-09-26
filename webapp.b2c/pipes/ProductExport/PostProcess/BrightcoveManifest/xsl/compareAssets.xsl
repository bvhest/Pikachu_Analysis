<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    <!-- -->
  <xsl:template match="delta|new">
  <xsl:apply-templates/>
  </xsl:template>
  <!-- -->  
  <!-- -->
  <xsl:template match="cache"/>
  <!-- -->  
  <xsl:template match="title">
	  <xsl:copy>
		   <xsl:apply-templates select="@*[not(local-name()=('video-full-refid', 'video-still-refid'))] "/>
		   <xsl:if test="not(@video-full-refid = ../../cache/title/@video-full-refid)"><xsl:apply-templates select="@video-full-refid"/>
		   </xsl:if>
		   <xsl:if test="not(@video-still-refid = ../../cache/title/@video-still-refid)"><xsl:apply-templates select="@video-still-refid"/>
		   </xsl:if>
		<xsl:apply-templates select="node()"/>
	  </xsl:copy>
  </xsl:template>

 
</xsl:stylesheet>
