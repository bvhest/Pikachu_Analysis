<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="page">home</xsl:param>
  <!-- -->
  <xsl:template match="/">
    <Menu>
      <xsl:apply-templates/>
    </Menu>
  </xsl:template>
  <!-- -->
  <xsl:template match="//Gui/GuiPart[@visible='yes']">
    <Item>
      <xsl:variable name="section">
        <xsl:if test="@section">
            <xsl:value-of select="concat('section/', @section, '/')"/>
        </xsl:if>
      </xsl:variable>
      <!-- -->
      <xsl:variable name="p1">
        <xsl:if test="@param1">
          <xsl:choose>
            <xsl:when test="@param1='yes'">
              <xsl:if test="$param1">
                <xsl:value-of select="concat('/',$param1)"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('/', @param1)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:variable>
      <!-- -->
      <xsl:variable name="p2">
        <xsl:if test="not ($p1='')">
          <xsl:if test="@param2">
            <xsl:choose>
              <xsl:when test="@param2='yes'">
                <xsl:if test="$param2">
                  <xsl:value-of select="concat('/',$param2)"/>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('/', @param2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
	  <!-- -->
      <xsl:attribute name="url"><xsl:value-of select="concat($section, @name, $p1, $p2)"/></xsl:attribute>
      <xsl:attribute name="text"><xsl:value-of select="@text"/></xsl:attribute>
    </Item>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
