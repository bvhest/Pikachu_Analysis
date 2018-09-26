<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="page">home</xsl:param>
  <xsl:param name="section"/>
  <!-- -->
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="Gui/Menu">
    <Menu>
      <xsl:attribute name="partName"><xsl:value-of select="@name"/></xsl:attribute>
      <cinclude:include>
        <xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/xml_body/',content/@url,'.xml')"/></xsl:attribute>
      </cinclude:include>
    </Menu>
  </xsl:template>
  <!--   -->
  <xsl:template match="Gui/GuiPart[(Page/@name=$page) and ((not (@section) and (not ($section))) or ($section = @section))]/Menu">
    <Menu>
      <xsl:attribute name="partName"><xsl:value-of select="@name"/></xsl:attribute>
      <cinclude:include>
        <xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/xml_body/',content/@url,'.xml')"/></xsl:attribute>
      </cinclude:include>
    </Menu>
  </xsl:template>
  <!--  and ((not ../@section) or ($section = ../@section)) -->
  <xsl:template match="Gui/GuiPart/Page[(@name=$page) and ((not (../@section) and (not ($section))) or ($section = ../@section))]">
    <Page>
      <xsl:attribute name="partName"><xsl:value-of select="@name"/></xsl:attribute>
      <cinclude:include>
        <xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/xml_body/',content/@url,'.xml')"/></xsl:attribute>
      </cinclude:include>
    </Page>
  </xsl:template>
</xsl:stylesheet>
