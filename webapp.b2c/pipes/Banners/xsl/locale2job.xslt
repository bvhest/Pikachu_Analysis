<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>
  <xsl:template match="/root">
    <log>
      <xsl:variable name="list">
        <xsl:apply-templates select="*" mode="aa"/>
      </xsl:variable>
      <xsl:variable name="content">
        <xsl:copy-of select="Region"/>
        <xsl:copy-of select="locale"/>
        <xsl:copy-of select="country"/>
        <xsl:copy-of select="Language"/>
        <xsl:copy-of select="Bannertype"/>
        <xsl:copy-of select="landingpage"/>
      </xsl:variable>
      <xsl:for-each select="$list/item">
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
            <xsl:value-of select="concat($dir, $content/locale, '-', @id,'.xml')"/>
          </source:source>
          <source:fragment>
            <root>
              <xsl:copy-of copy-namespaces="no" select="$content"/>
              <item>
                <xsl:value-of select="."/>
              </item>
              <id>
                <xsl:value-of select="@id"/>
              </id>
              <type>
                <xsl:value-of select="@type"/>
              </type>
            </root>
          </source:fragment>
        </source:write>
      </xsl:for-each>
    </log>
  </xsl:template>
  <!-- -->
  <xsl:template match="*" mode="aa">
    <xsl:if test="contains(./name(), '_swf')">
      <item>
        <xsl:attribute name="id"><xsl:value-of select="replace(./name(), '(.*)_swf', '$1')"/></xsl:attribute>
        <xsl:attribute name="type">swf</xsl:attribute>
        <xsl:value-of select="."/>
      </item>
    </xsl:if>
    <xsl:if test="contains(./name(), '_jpg')">
      <item>
        <xsl:attribute name="id"><xsl:value-of select="replace(./name(), '(.*)_jpg', '$1')"/></xsl:attribute>
        <xsl:attribute name="type">jpg</xsl:attribute>
        <xsl:value-of select="."/>
      </item>
    </xsl:if>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
