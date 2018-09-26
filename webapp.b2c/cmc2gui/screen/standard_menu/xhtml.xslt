<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:template match="/Menu">
    <html>
      <body contentID="content">
        <table class="gui_context_menu" width="180px" border="0" cellspacing="0" cellpadding="0">
          <tr width="180px">
            <td width="180px" class="big"><xsl:value-of select="@text"/></td>
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
      <td width="10px">-</td>
      <td width="170px">
        <a>
          <xsl:attribute name="href" select="concat($gui_url, @url)"/>
          <xsl:value-of select="@text"/>
        </a>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
