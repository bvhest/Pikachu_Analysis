<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:param name="usergroup">normal</xsl:param>
  <xsl:variable name="chk_usergroup" select="concat(';',$usergroup,';')"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Gui">
    <Gui>
      <xsl:attribute name="usergroup" select="$usergroup"/>
      <xsl:attribute name="chk_usergroup" select="$chk_usergroup"/>
      <xsl:apply-templates/>
    </Gui>
  </xsl:template>
  <!--  -->
  <xsl:template match="GuiPart">
    <xsl:if test="contains(@usergroup, $chk_usergroup)">
      <GuiPart>
        <xsl:apply-templates select="@*|node()"/>
      </GuiPart>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="Page">
    <xsl:if test="contains(@usergroup, $chk_usergroup)">
      <Page>
        <xsl:apply-templates select="@*|node()"/>
      </Page>
    </xsl:if>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
