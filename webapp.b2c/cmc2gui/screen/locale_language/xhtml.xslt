<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id">0</xsl:param>
  <xsl:variable name="sectionurl">
    <xsl:if test="$section">
      <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>
  <xsl:template match="/root">
  <html>
  <body contentID="content">
  <h2>CMC2 locale language map</h2><hr/>
  <table class="main">
  <tr>
      <td width="100">Locale</td>
      <td width="100">Language Family</td>
      <td width="100">Country</td>
      <td width="100">CCR Language Code</td>
      <td width="100">CCR Language Name</td>
      <td width="100">Division</td>
      <td width="100">Is Translated</td>
      <td width="100">Is Enabled</td>
      <td width="100">Is Latin</td>
  </tr>
  <xsl:apply-templates/>
  </table>
  </body>
  </html>
  </xsl:template>

  <xsl:template match="sql:row">
  <tr>
      <td><xsl:value-of select="sql:locale"/></td>
      <td><xsl:value-of select="sql:languagecode"/></td>
      <td><xsl:value-of select="sql:country"/></td>
      <td><xsl:value-of select="sql:ccr_language_code"/></td>
      <td><xsl:value-of select="sql:ccr_language_name"/></td>
      <td><xsl:value-of select="sql:division"/></td>
      <td><xsl:value-of select="if(sql:isdirect = 'Yes') then 'No' else 'Yes'"/></td>
      <td><xsl:value-of select="sql:enabled"/></td>
      <td><xsl:value-of select="sql:islatin"/></td>
  </tr>
  </xsl:template>
</xsl:stylesheet>