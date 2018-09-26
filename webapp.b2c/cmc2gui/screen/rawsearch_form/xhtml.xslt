<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>
  <xsl:param name="channel"/>
  <xsl:template match="/root/sql:rowset">
    <html>
      <body contentID="content">
        <h2>CMC2.0 Text Search</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'rawsearch_real')"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 140px">Search text</td>
              <td style="width: 205px">
                <input name="Search" size="60" type="text"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px">Locale</td>
              <td style="width: 205px">
                <input name="Locale" size="60" type="text" value="Master"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 205px">
              </td>
            </tr>
            <tr>
              <td style="width: 140px">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
              <td style="width: 205px"/>
            </tr>
          </table>
        </form>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
