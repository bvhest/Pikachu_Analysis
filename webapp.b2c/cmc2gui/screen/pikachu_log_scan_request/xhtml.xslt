<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
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
        <xsl:if test="$param1 = ''">
          <h2>Select a channel first!!</h2>
        </xsl:if>
        <xsl:if test="$param1 != ''">
          <xsl:apply-templates select="sql:rowset"/>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset">
    <h2>
      <xsl:value-of select="$param1"/> - Log file scan</h2>
    <hr/>
    <form method="POST" id="to_form" name="to_form" enctype="multipart/form-data">
      <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_log_scan/', $param1, '/', $param2)"/></xsl:attribute>
      <table>
        <tr>
          <td style="width: 180px">
            <b>CTN</b>
          </td>
          <td style="width: 205px">
            <input name="CTN" size="60" type="text"/>
          </td>
        </tr>
        <tr>
          <td style="width: 180px">
            <b>Locale</b>
          </td>
          <td style="width: 205px">
            <select name="locale">
              <option value="" selected="selected">Select from the following</option>
              <xsl:apply-templates select="./sql:row"/>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2"/>
        </tr>
        <tr>
          <td style="width: 180px"/>
          <td style="width: 205px">
            <input id="SendChannelData" style="width: 137px" type="submit" value="Submit"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  <xsl:template match="sql:row">
    <option>
      <xsl:attribute name="value" select="sql:locale"/>
      <xsl:value-of select="sql:locale"/>
    </option>
  </xsl:template>
</xsl:stylesheet>
