<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>	  
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <table class="gui_context_menu" width="180px" border="0" cellspacing="0" cellpadding="0">
          <tr width="180px">
            <td class="big" width="180px">
			  <xsl:if test="$section">
				<xsl:value-of select="concat(upper-case(substring($section,1,1)), substring($section,2), ' ')"/>
			  </xsl:if>
			  <xsl:text>Channels</xsl:text>
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
  <xsl:template match="sql:row">
    <tr width="180px">
      <td width="10px">-</td>
      <td width="170px">
        <a>
<!--
        <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_home/', sql:location)"/></xsl:attribute>
-->
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_log_dir/', sql:location, '/logs')"/></xsl:attribute>

          <xsl:value-of select="sql:name"/>
        </a>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
