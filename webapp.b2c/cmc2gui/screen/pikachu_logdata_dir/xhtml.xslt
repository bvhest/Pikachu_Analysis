<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
	  <xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>    
  <xsl:variable name="job">
    <xsl:value-of select="$param1"/>
  </xsl:variable>
  <xsl:variable name="dir">
    <xsl:value-of select="$param2"/>
  </xsl:variable>
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
  <xsl:template match="/dir:directory">
    <html>
      <body contentID="content">
        <h2>Pika-Chu <xsl:value-of select="$dir"/> files for <xsl:value-of select="$job"/>
        </h2>
        <hr/>
        <br/>
        <table>
          <tr>
            <td>Name</td>
            <td>Rawfile</td>
            <td>Size</td>
            <td>Date</td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="setpath">
    <xsl:param name="list"/>
    <xsl:value-of select="$list//@name"/>
    <xsl:choose>
      <xsl:when test="$list">
        <xsl:variable name="first" select="$list[1]"/>
        <xsl:variable name="rest">
          <xsl:call-template name="setpath">
            <xsl:with-param name="list" select="$list[position()!=1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($first,'/',$rest)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file">
    <xsl:variable name="path">
      <xsl:call-template name="setpath">
        <xsl:with-param name="list" select="ancestor::dir:directory/@name"/>
      </xsl:call-template>
    </xsl:variable>
    <tr>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_showlog_file/', $param1, '/', $param2, '/', @name, '?reporttype=',upper-case(substring-before(@name, '_')),'&amp;file=', $param1, '/', $path, @name)"/></xsl:attribute>
          <xsl:value-of select="substring-after(concat($path, @name), '/')"/>
        </a>
      </td>
      <td>
        <a target="_blank">
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'pikachu_get_file/', $param1, '/', $param2, '/', @name, '?file=', $param1, '/', $path, @name)"/></xsl:attribute>
          Raw File
        </a>
      </td>
      <td>
        <xsl:value-of select="@size"/>
      </td>
      <td>
        <xsl:value-of select="@date"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
