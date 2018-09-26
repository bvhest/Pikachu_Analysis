<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:import href="../service-base.xsl"/>
  
  <!-- Override service-base -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="sql:rowset">
    <tns:LocaleLanguageList>
      <xsl:apply-templates select="sql:row"/>
    </tns:LocaleLanguageList>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <tns:LocaleLanguage
        locale="{sql:locale}"
        languageFamily="{sql:languagefamily}"
        country="{sql:country}"
        languageCode="{sql:languagecode}"
        languageName="{sql:languagename}"
        division="{sql:division}"
        isTranslated="{sql:istranslated = 1}"
        isEnabled="{sql:isenabled = 1}"/>
  </xsl:template>
</xsl:stylesheet>
