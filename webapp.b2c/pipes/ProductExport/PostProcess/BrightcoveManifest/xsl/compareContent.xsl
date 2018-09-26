<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="delta">
    <xsl:choose>
      <xsl:when test="deep-equal(new/title,cache/title)">
        <matched ctn="{new/title/@refid}" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="new/title" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
