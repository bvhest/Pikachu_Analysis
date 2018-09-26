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
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <table class="gui_context_menu" width="180px" border="0" cellspacing="0" cellpadding="0">
          <tr width="180px">
            <td class="big" width="180px">
              <xsl:text>Content Types</xsl:text>
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
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'content_type/', sql:content_type,'/jobs/',sql:id)"/></xsl:attribute>
          <xsl:value-of select="sql:description"/>
        </a>
      </td>
    </tr>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
