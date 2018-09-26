<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
            >

  <!--  base the transformation on the default xUCDM transformation -->
  <xsl:import href="../xUCDM.1.4.convertProducts.xsl" />
  
  <xsl:param name="doctypesfilepath"/>
  <!-- type indicates whether this is a master, masterlocale or locale export -->
  <xsl:param name="type"/>
  <xsl:param name="locale"/>

  <!--  no selection needed: the assetchannel is for ATG -->
  <xsl:variable name="assetschannel">ATG</xsl:variable>
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
  
  <!-- Override this variable from xucdm-product-external-v1.3.xsl -->
  <xsl:variable name="ignore-award-types" select="('ala_semantic','ala_user')"/>

  <!-- 
     | Country specific modifications because Java 6 (Atg) cannot handle the iso-value for the Israel locale.
     -->
  <xsl:template match="@Locale[.='he_IL']">
     <xsl:attribute name='Locale'><xsl:value-of select="'iw_IL'" /></xsl:attribute>
  </xsl:template>
  <!-- -->
  <xsl:template match="@locale[.='he_IL']">
     <xsl:attribute name='locale'><xsl:value-of select="'iw_IL'" /></xsl:attribute>
  </xsl:template>
  
  <xsl:template name="DocType-attribute">
    <xsl:attribute name="DocType" select="'PMT'"/>
  </xsl:template>
  
  <xsl:template name="OptionalHeaderAttributes">
    <xsl:if test="empty(@Locale)">
      <xsl:attribute name="Locale" select="if ($type='locale') then $locale else concat('en_', substring($locale, 4))"/>
    </xsl:if>
    <xsl:if test="empty(@Country)">
      <xsl:attribute name="Country" select="substring($locale, 4)"/>
    </xsl:if>
  </xsl:template>

  <!-- Copy AwardName into AwardText if it is not there -->
  <xsl:template match="Award[AwardCode='GA_GREEN'][string(AwardText)='']">
    <xsl:copy>
      <xsl:apply-templates select="@*|AwardCode|AwardName|AwardDate|AwardPlace|Title|Issue|Rating|Trend|AwardAuthor|TestPros|TestCons|AwardDescription|AwardAcknowledgement|AwardVerdict"/>
      <AwardText><xsl:value-of select="AwardName"/></AwardText>
      <xsl:apply-templates select="Locales|AwardRank|AwardSourceCode|AwardVideo|AwardCategory|AwardSourceLocale"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Code[parent::PhilipsGreenLogo|parent::EcoFlower|parent::BlueAngel]"/>
  <xsl:template match="Name[parent::PhilipsGreenLogo|parent::EcoFlower|parent::BlueAngel]"/>
  <xsl:template match="Text[parent::PhilipsGreenLogo|parent::EcoFlower|parent::BlueAngel]"/>
  <xsl:template match="ShortDescription[parent::PhilipsGreenLogo|parent::EcoFlower|parent::BlueAngel]"/>
  <xsl:template match="LongDescription[parent::PhilipsGreenLogo|parent::EcoFlower|parent::BlueAngel]"/>
  <xsl:template match="ApplicableFor[parent::EcoFlower|parent::BlueAngel]"/>

</xsl:stylesheet>
