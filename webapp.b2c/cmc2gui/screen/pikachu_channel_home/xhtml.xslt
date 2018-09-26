<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>	  
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="not ($param1 = '')">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <html>
          <body contentID="content">
            <h2>
              <xsl:text>Select a channel first!!</xsl:text>
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
        <h2>
          <xsl:value-of select="sql:rowset/sql:row/sql:name"/> locales</h2>
        <hr/>
        <table>
          <tr>
            <td width="100">Locale</td>
            <td width="100">CTN Count</td>
          </tr>
          <xsl:apply-templates select="sql:rowset/sql:row/sql:rowset/sql:row"/>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset/sql:row/sql:rowset/sql:row">
    <tr>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_locale/', $param1, '/', sql:locale)"/></xsl:attribute>
          <xsl:value-of select="sql:locale"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:count"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
