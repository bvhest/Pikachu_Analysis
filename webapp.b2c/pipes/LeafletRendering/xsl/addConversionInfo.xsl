<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="image-config-pmt" select="document('../config/doctypeConfig_PMT.xml')/imageconfigs" />
  <xsl:variable name="image-config-fmt" select="document('../config/doctypeConfig_FMT.xml')/imageconfigs" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="asset[@owner='PMT']">
    <xsl:call-template name="add-convert-cmd">
      <xsl:with-param name="image-config" select="$image-config-pmt"/>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template match="asset[@owner='FMT']">
    <xsl:call-template name="add-convert-cmd">
      <xsl:with-param name="image-config" select="$image-config-fmt"/>
    </xsl:call-template>
  </xsl:template>  

  <xsl:template name="add-convert-cmd">
    <xsl:param name="image-config"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="convertcmd" select="$image-config/imageconfig[doctype=current()/@type]/convertstring"/>
      <xsl:if test="$convertcmd != ''">
        <xsl:attribute name="convertcmd" select="$convertcmd"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>  
</xsl:stylesheet>