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
  <xsl:param name="param1" select="search"/>
  <xsl:param name="id"/>
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Quick Catalog Search</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/', $param1)"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 140px">Enter&#160;an&#160;exact&#160;CTN&#160;to&#160;retrieve<br/>catalog&#160;and&#160;subcat&#160;info:</td>
              <td style="width: 40px">
                <input name="Search" size="60" type="text" value="{$id}"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 40px">
              </td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
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
