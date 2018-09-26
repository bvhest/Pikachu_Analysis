<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
	  <xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>  
  <xsl:variable name="channel" select="/root/sql:rowset/sql:row/sql:id"/>  
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <xsl:if test="$param1 = ''">
          <h2>Select a channel first!!</h2>
        </xsl:if>
        <xsl:if test="$param1 != ''">
          <h2>
            <xsl:value-of select="sql:rowset/sql:row/sql:name"/> - confirm delete export history</h2>
          <hr/>
          <p>Deletion of the export history means that all data is deleted that contained information over when the product was transmitted last.</p>
          <p>In addition it means the next export will include the selected product, because the information needed to find the delta is deleted.</p>
          <br/>
          <form method="POST" enctype="multipart/form-data">
            <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_product_clean_real/', $param1,'?channel=', $channel)"/></xsl:attribute>
            <table>
              <tr>
                <td style="width: 140px">Product CTN</td>
                <td style="width: 205px">
                  <input name="Search" size="60" type="text"/>
                </td>
              </tr>
              <tr>
                <td style="width: 140px">Channel</td>
                <td style="width: 205px">
                  <input name="Channel" size="60" type="text">
                    <xsl:attribute name="value"><xsl:value-of select="sql:rowset/sql:row/sql:name"/></xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td style="width: 140px"/>
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
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
