<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->      
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
   <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Award">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()[not(local-name='AwardLogoURL')]"/>
	  <xsl:variable name="LogoCode" select="AwardLogoCode"/>
	  <AwardLogoURL><xsl:value-of select="ancestor::entry/octl/sql:rowset/sql:row/sql:data/logo[Code=$LogoCode]/URL"/></AwardLogoURL>
	  <AwardLogoType><xsl:value-of select="ancestor::entry/octl/sql:rowset/sql:row/sql:data/logo[code=$LogoCode]/type"/></AwardLogoType>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
