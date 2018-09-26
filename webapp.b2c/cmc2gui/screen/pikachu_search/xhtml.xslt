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
        <h2>Search by Partial CTN</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_id_post/search?id=', @id)"/></xsl:attribute>
          <table>
            <tr>
							<td style="width: 140px">Enter&#160;a&#160;CTN&#160;or&#160;partial&#160;CTN<br/>(minimum&#160;3&#160;characters):</td>
							<td style="width: 40px">
                <input name="SearchID" size="60" type="text" value="{$id}"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 40px"></td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 40px"></td>
            </tr>            
            <tr>
              <td colspan="2" align="center">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
            </tr>
          </table>
        </form>
        <br/><br/>
        <!--
        <h2>Exact Catalog Search</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post/', $param1)"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 100px">CTN</td>
              <td style="width: 205px">
                <input name="Search" size="60" type="text" value="{$id}"/>
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
        -->
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
