<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  
  <xsl:template match="/Menu">
    <html>
      <body contentID="content">
        <table class="gui_context_menu" width="220px" border="0" cellspacing="0" cellpadding="0">
          <tr width="180px">
            <td class="big" width="180px">
              <xsl:value-of select="@text"/>
            </td>
          </tr>
          <tr width="180px">
            <td width="180px">
              <table class="gui_context_menu_sub" width="180px" border="0" cellspacing="0" cellpadding="0">
                <xsl:apply-templates/>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="Item">
    <tr width="180px">
      <xsl:variable name="prefix">
        <xsl:choose>
          <xsl:when test="@current eq 'true'"><span style="font-family: Arial">&#x25ba;</span></xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <td style="vertical-align: top" width="10px"><xsl:copy-of copy-namespaces="no" select="$prefix"/></td>
      <td width="170px">
        <xsl:if test="@current eq 'true'">
          <xsl:attribute name="class" select="'menu_item_current'"/>
        </xsl:if>
        <a>
          <xsl:attribute name="href" select="concat($gui_url, @url)"/>
          <xsl:if test="@description ne ''"><xsl:attribute name="title" select="@description"/></xsl:if>
          <xsl:value-of select="@text"/>
        </a>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="Separator">
    <tr width="180px">
      <td colspan="2">
        <p class="menu_item_separator">
          <xsl:value-of select="title/text()"/>
        </p>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
