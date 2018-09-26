<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <!-- -->
  <xsl:template match="/Menu">
    <html>
      <body contentID="content">
        <table class="gui_main_menu" width="300px" border="0" cellspacing="0" cellpadding="0">
          <tr>
			<xsl:attribute name="width" select="concat(101*count(Item), 'px')"/>
            <xsl:apply-templates/>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="Item">
    <td width="125px">
      <center>
        <a>
          <xsl:attribute name="href" select="concat($gui_url, @url)"/>
          <xsl:value-of select="@text"/>
        </a>
      </center>
    </td>
    <td>
      <img src="{concat($gui_url, 'themes/images/navsep.gif')}"/>
    </td>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
