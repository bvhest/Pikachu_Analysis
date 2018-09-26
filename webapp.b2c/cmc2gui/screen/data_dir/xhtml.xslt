<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  <xsl:variable name="job">
    <xsl:value-of select="$param1"/>
  </xsl:variable>
  <xsl:variable name="dir">
    <xsl:value-of select="$param2"/>
  </xsl:variable>
  <xsl:variable name="max" select="if($job='PP_Translations') then 2000 else 1000" as="xs:number"/>    
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
  <xsl:template match="/dir:directory">
    <html>
      <body contentID="content">
        <h2>Showing the <xsl:value-of select="$max"/> most recent files in the <xsl:value-of select="$dir"/> directory for <xsl:value-of select="$job"/>
        </h2>
        <br/>
        <br/>
         <xsl:choose>
          <xsl:when test="dir:file">
            <b>Do not click on the files, they can be VERY big, use 'Save Target As'!!</b>
            <br/>
            <hr/>
            <table class="main">
              <tr>
                <td>Name</td>
                <td>Size</td>
                <td>Date</td>
              </tr>
              <xsl:apply-templates/>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <p>There are no files in directory <b><xsl:value-of select="$dir"/></b></p>
          </xsl:otherwise>
        </xsl:choose>
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
    <xsl:variable name="v_number">
      <xsl:number level="any"/>
    </xsl:variable>
    <xsl:if test="$v_number &lt; $max">
      <tr>
        <td>
          <a target="_default">
            <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'get_file/', $param1, '/', $param2, '/', @name, '?file=', $param1, '/', $path, @name)"/></xsl:attribute>
            <xsl:value-of select="substring-after(concat($path, @name), '/')"/>
          </a>
        </td>
        <td>
          <xsl:value-of select="@size"/>
        </td>
        <td>
          <xsl:value-of select="@date"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
