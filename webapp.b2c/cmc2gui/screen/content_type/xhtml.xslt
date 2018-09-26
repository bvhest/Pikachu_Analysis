<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="gui_url"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		   
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="(not ($param1 = '')) and ($param1 != 'yes')">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <html>
          <body contentID="content">
            <h2>
              <xsl:text>Select a content type first!!</xsl:text>
            </h2>
          </body>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>'<xsl:value-of select="$param1"/>' localisation</h2>
        <hr/>
        <table class="main">
          <tr>
            <td width="100">Locale</td>
            <td width="100">Count</td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset/sql:row">
    <tr>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl)"/>content_type_localisation/<xsl:value-of select="$param1"/>/<xsl:value-of select="sql:localisation"/></xsl:attribute>
          <xsl:value-of select="sql:localisation"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:count"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
