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
  <xsl:template match="PackagingText">
      <xsl:copy>
        <!--xsl:attribute name="Locale" select="../../@l"/-->
        <xsl:attribute name="Country" select="substring(ancestor::entry/@l,4,2)"/>
        <xsl:attribute name="languageCode" select="ancestor::entry/@l"/>
        <xsl:apply-templates select="@*[not(local-name()='Country' or local-name()='languageCode')]|node()[not(local-name()='originalentriesattributes')]"/>
      </xsl:copy>        
  </xsl:template>
</xsl:stylesheet>
