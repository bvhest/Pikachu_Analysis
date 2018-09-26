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
  <xsl:param name="id"/>
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Search for objects by partial object ID</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
        <!--
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, 'search_id_post')"/></xsl:attribute>
        -->  
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'search_id_post/search?id=', @id)"/></xsl:attribute>
          <table>
            <tr>
              <td style="width: 140px">Enter&#160;a&#160;partial&#160;CTN&#160;to&#160;find<br/>matches&#160;and&#160;associated&#160;content&#160;types:</td>
              <td style="width: 205px">
                <input name="SearchID" size="60" type="text" value="{$id}"/>
              </td>
            </tr>
            <tr>
              <td style="width: 140px"></td>
              <td style="width: 205px"></td>
            </tr>
            <tr>
              <td align="center" colspan="2">
                <input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
              </td>
            </tr>
          </table>
        </form>
        <br/><br/>
        <h2>Retrieve detailed information by exact CTN</h2><hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'search_post/search?id=', @id)"/></xsl:attribute>          
          <table>
            <tr>
              <td style="width: 140px">Enter&#160;an&#160;exact&#160;CTN&#160;to&#160;retrieve<br/>detailed&#160;content&#160;type&#160;and&#160;catalog&#160;info:</td>
              <td style="width: 40px">
                <input name="SearchContent" size="60" type="text" value="{$id}"/>
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
