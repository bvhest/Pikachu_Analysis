<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" exclude-result-prefixes="sql xsl cinclude" extension-element-prefixes="cmc2-f">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="broker-level">5</xsl:param>
  <xsl:variable name="vbroker-level" select="if($broker-level = 'min') then number(-1) else if($broker-level = '') then number(5) else number($broker-level)"/>
  <!-- -->
  <xsl:template match="/Products">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="Product"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="CTN"/>
        <xsl:copy-of select="Catalog"/>
        <xsl:copy-of select="Categorization"/>
        <xsl:copy-of select="Assets"/>
        <xsl:copy-of select="FullProductName"/>
        <xsl:call-template name="NamingString">
          <xsl:with-param name="ns" select="."/>
        </xsl:call-template>
      <xsl:copy-of select="ShortDescription"/>      
      <xsl:copy-of select="RichTexts"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="NamingString">
    <xsl:param name="ns"/>
    <xsl:copy-of select="$ns/NamingString"/>
  </xsl:template>

  <xsl:template name="KeyBenefitArea">
    <xsl:param name="kba"/>
    <KeyBenefitArea>
      <xsl:copy-of select="$kba/KeyBenefitAreaCode"/>
      <xsl:copy-of select="$kba/KeyBenefitAreaName"/>
      <xsl:copy-of select="$kba/KeyBenefitAreaRank"/>
      <xsl:if test="$vbroker-level ge 3">      
        <xsl:copy-of select="$kba/Feature"/>
      </xsl:if>
    </KeyBenefitArea>
  </xsl:template>

  <xsl:template name="Award">
    <xsl:param name="award"/>
    <Award>
      <xsl:copy-of select="$award/@AwardType"/>
      <xsl:copy-of select="$award/AwardCode"/>
      <xsl:copy-of select="$award/AwardName"/>
      <xsl:copy-of select="$award/AwardDate"/>
      <xsl:copy-of select="$award/AwardPlace"/>
      <xsl:copy-of select="$award/AwardDescription"/>                  
      <xsl:copy-of select="$award/AwardAcknowledgement"/>      
      <xsl:copy-of select="$award/Title"/>
      <xsl:copy-of select="$award/Issue"/>
      <xsl:copy-of select="$award/Rating"/>
      <xsl:copy-of select="$award/Issue"/>
      <xsl:copy-of select="$award/AwardRank"/>
    </Award>
  </xsl:template>

</xsl:stylesheet>