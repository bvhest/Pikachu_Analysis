<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="reload"/>
  <xsl:param name="basefilename"/>
  <xsl:param name="dir"/>  
  <!-- -->
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$reload='1'"><xsl:value-of select="concat('../',$dir,'Reload',$basefilename)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat('../',$dir,$basefilename)"/></xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>  
  <!-- -->  
  <xsl:template match="/">
    <xsl:copy-of select="document($filename)"/>
  </xsl:template>
</xsl:stylesheet>
