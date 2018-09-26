<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="gui_url">/cmc2gui/</xsl:param>
  <xsl:param name="publicSystemId"/>
  <xsl:param name="internalSystemId">UNKNOWN</xsl:param>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
      <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
          <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
          <link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style_Philips.css"/>
          <link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style{$publicSystemId}.css"/>
          <link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style{$internalSystemId}.css"/>
	       <title><xsl:value-of select="$internalSystemId"/> | a Philips CL e-Platform tool</title>
          <script src="{$gui_url}javascript/svg.js" data-path="{$gui_url}javascript" >&#160;</script>
          <script language="javascript">
          function highlightRow(tableRow) {
            tableRow.previousStyleClass = tableRow.className;
            tableRow.className = "highlight";
          }
          function restoreRow(tableRow) {
            tableRow.className = tableRow.previousStyleClass; 
          }
          </script>          
        </head>
        <body>
          <table class="gui_main" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height="80px">
              <td>
                <table class="gui_main" width="950px" height="80px" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table class="gui_main header" width="850px" height="80px" border="0" cellspacing="0" cellpadding="0">
                        <!--Company Bar - logo -->
                        <tr height="21">
                          <td width="500">
                            <img src="{$gui_url}themes/images/Brand_PhilipsLogo.jpg" alt="Philips"/>
                          </td>
                          <td width="150" align="right">
                            <table class="gui_main" width="150px" height="20px" border="0" cellspacing="0" cellpadding="0">
                              <tr height="13px">
                                <td id="guiversion">GUI VERSION</td>
                              </tr>
                              <tr height="13px">
                                <td id="engineversion">ENGINE VERSION</td>
                              </tr>
                            </table>
                          </td>
                          <td class="environment" width="150" align="right">
                            <xsl:value-of select="$internalSystemId"/>
                          </td>
                        </tr>
                        <tr height="3">
                          <td colspan="3">
                            <img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="850px" height="3"/>
                          </td>
                        </tr>
                        <!--Company Bar - department -->
                        <tr height="37">
                          <td>
                            <img src="{$gui_url}themes/images/Brand_PhilipsBar.jpg" alt="Consumer Electronics" width="500px"/>
                          </td>
                          <td align="right" valign="top" colspan="2">
                            <a href="{$gui_url}do-logout">logout</a>
                          </td>
                        </tr>
                        <tr height="3">
                          <td colspan="3">
                            <img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="750px" height="3"/>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td width="80px" align="left">
                      <img src="{$gui_url}themes/images/pikachu.gif" alt="PikaChu"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <!--Menu -->
            <tr>
              <td height="29" background="{$gui_url}themes/images/bg_nav.gif">
                <xsl:copy-of select="//Menu[@partName='MainMenu']/content/node()" copy-namespaces="no"/>
              </td>
            </tr>
            <tr>
              <td height="2"></td>
            </tr>
          </table>
          <table class="gui_main" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td style="vertical-align: top; width: 222px; background-image: url('/cmc2gui/themes/images/home_left_tile.gif'); background-position: -1px 0px;">
                <xsl:copy-of select="//Menu[@partName='ContextMenu']/content/node()" copy-namespaces="no"/>
                <hr/>
                <xsl:copy-of select="//Menu[@partName='SubContextMenu']/content/node()" copy-namespaces="no"/>
                <hr/>
                <xsl:copy-of select="//Menu[@partName='StandardMenu']/content/node()" copy-namespaces="no"/>
                <hr/>
              </td>
              <td valign="top" id="MainPage">
                <xsl:apply-templates select="//Page/content/node()"/>
              </td>
            </tr>
          </table>
        </body>
      </html>
  </xsl:template>

  <!-- main table header row(s) -->
  <xsl:template match="tr[parent::table[@class='main']][position()=1]|tr[parent::thead/parent::table[@class='main']]">
    <xsl:copy copy-namespaces="no">
      <xsl:choose>
        <xsl:when test="empty(@class)">
          <xsl:attribute name="class">header</xsl:attribute>
        </xsl:when>
        <xsl:when test="not(contains(@class,'header'))">
          <xsl:attribute name="class"><xsl:value-of select="concat(@class,' header')"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@class" copy-namespaces="no"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*[local-name(.) ne 'class']|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- main table body rows -->
  <xsl:template match="tr[parent::table[@class='main']][position()&gt;1]|tr[parent::tbody/parent::table[@class='main']]">
    <xsl:copy copy-namespaces="no">
      <xsl:variable name="class" select="if (position() mod 2) then 'odd' else 'even'"/>
      <xsl:choose>
        <xsl:when test="empty(@class)">
          <xsl:attribute name="class" select="$class"/>
        </xsl:when>
        <xsl:when test="not(matches(@class,'odd|even'))">
          <xsl:attribute name="class"><xsl:value-of select="concat(@class,' ',$class)"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="@class" copy-namespaces="no"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="onmouseover">javascript:highlightRow(this);</xsl:attribute>
      <xsl:attribute name="onmouseout">javascript:restoreRow(this);</xsl:attribute>
      <xsl:apply-templates select="@*[local-name(.) ne 'class']|node()"/>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>
