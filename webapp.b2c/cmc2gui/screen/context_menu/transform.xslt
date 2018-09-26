<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="page"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  
  <xsl:variable name="current_url">
    <xsl:if test="$section ne ''">
      <xsl:text>section/</xsl:text>
      <xsl:value-of select="$section"/>
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:value-of select="$page"/>
  </xsl:variable>
  
  <!-- -->
  <xsl:template match="/root">
      <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Gui/GuiPart[(Page/@name=$page) and ((not (@section) and ($section = '')) or ($section = @section))]">
    <Menu>
		<xsl:attribute name="text"><xsl:value-of select="@text"/></xsl:attribute>
		<xsl:apply-templates/>
    </Menu>
  </xsl:template>
  <!-- -->
  <xsl:template match="Gui/GuiPart[(Page/@name=$page) and ((not (@section) and ($section = '')) or ($section = @section))]/Page[(not (@visible)) or (@visible='yes')]">
    <Item>
      <xsl:variable name="section_url">
        <xsl:if test="../@section">
            <xsl:value-of select="concat('section/',../@section, '/')"/>
        </xsl:if>
      </xsl:variable>
      <!-- -->
      <xsl:variable name="p1">
        <xsl:if test="content/@param1">
          <xsl:choose>
            <xsl:when test="content/@param1='yes'">
              <xsl:if test="$param1">
                <xsl:value-of select="concat('/',$param1)"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('/', content/@param1)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:variable>
      <!-- -->
      <xsl:variable name="p2">
        <xsl:if test="not ($p1='')">
          <xsl:if test="content/@param2">
            <xsl:choose>
              <xsl:when test="content/@param2='yes'">
                <xsl:if test="$param2">
                  <xsl:value-of select="concat('/',$param2)"/>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('/', content/@param2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <!-- -->
      <xsl:variable name="p3">
        <xsl:if test="content/@param3='yes'">
          <xsl:value-of select="concat('/',if ($param3) then $param3 else content/@param3)"/>
        </xsl:if>
      </xsl:variable>
      
      <xsl:variable name="target_url" select="concat($section_url, @name)"/>
      
      <xsl:attribute name="url"><xsl:value-of select="concat($gui_url, $target_url, $p1, $p2, $p3)"/></xsl:attribute>
      <xsl:attribute name="text"><xsl:value-of select="@text"/></xsl:attribute>
      <xsl:attribute name="description"><xsl:value-of select="@description"/></xsl:attribute>
      <xsl:if test="$current_url eq $target_url">
        <xsl:attribute name="current" select="'true'"/>
      </xsl:if>
    </Item>
  </xsl:template>
  
  <xsl:template match="Gui/GuiPart[(Page/@name=$page) and ((not (@section) and ($section = '')) or ($section = @section))]/Separator[(not (@visible)) or (@visible='yes')]">
    <xsl:copy-of select="." copy-namespaces="no"/>
  </xsl:template>
  
  <!-- -->
</xsl:stylesheet>