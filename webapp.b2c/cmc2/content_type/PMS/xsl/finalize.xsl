<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove Internal elements -->
  <xsl:template match="Internal">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  <xsl:template match="Internal/TextDescription"/>

  <!-- Fix ContentDetail empty Descriptions -->
  <xsl:template match="ContentDetail/Description[. = '']">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="../Internal[StatusAlert]">
          <xsl:value-of select="../Internal[StatusAlert]/TextDescription"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string-join(../Internal/TextDescription, ' / ')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
    
  <!-- Ignored content -->
  <xsl:template match="EvaluationData|StatusAlert|content/Product/@is-deleted" />
  
  <!-- Keep StatusAlert in LastTranslation -->
  <xsl:template match="LastTranslation/StatusAlert">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Add seq and placeholder attributes to ContentDetails -->
  <xsl:template match="ContentDetail">
    <xsl:variable name="status-alert" select="StatusAlert|Internal/StatusAlert"/>
    <xsl:variable name="content-exists" select="($status-alert/CompleteFlag='1' and $status-alert/@restrictionType='min') 
                                             or ($status-alert/CompleteFlag='0' and $status-alert/@restrictionType='max')"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="seq" select="position()"/>
      <xsl:if test="empty(@placeholder)">
        <xsl:attribute name="placeholder" select="empty($status-alert) or not($content-exists)"/>
      </xsl:if>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
