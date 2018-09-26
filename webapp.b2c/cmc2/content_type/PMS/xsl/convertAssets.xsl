<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0">
  
  <xsl:import href="pms.functions.xsl" />
  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:param name="pmt-preview-url"/>
  <xsl:param name="pmt-edit-url"/>
  <xsl:param name="asset-edit-url"/>

  <xsl:variable name="GAL-master-types" select="('PPW', 'RFT', 'FTL', 'FTR', 'PUW', '__F', '_FT')"/>
    
  <xsl:template match="Product/ThumbnailURL">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="pms-f:get-derived-asset(../EvaluationData/Assets/Asset, 'Thumbnail', $GAL-master-types)/@Url"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product/MediumImageURL">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="pms-f:get-derived-asset(../EvaluationData/Assets/Asset, 'Medium', $GAL-master-types)/@Url"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product/PreviewURL">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="pms-f:build-pmt-preview-url($pmt-preview-url, ancestor::entry/@o)" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product/OpenInPFS_URL">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="pms-f:build-pmt-edit-url($pmt-edit-url, ancestor::entry/@o)" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product/OpenInCCRUW_URL">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="pms-f:build-asset-edit-url($asset-edit-url, ancestor::entry/@o, '', '')" />
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
