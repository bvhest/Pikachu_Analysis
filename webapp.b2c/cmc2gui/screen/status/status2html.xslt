<?xml version="1.0"?>
<!--+
    | Converts output of the StatusGenerator into HTML page
    | 
    | CVS $Id: status2html.xslt,v 1.5 2006/11/29 09:20:32 gwisselink Exp $
    +-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:status="http://apache.org/cocoon/status/2.0" xmlns:xalan="http://xml.apache.org/xalan"   xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="xalan">
  <xsl:param name="xconfPath"/>
  <xsl:template match="status:statusinfo">
    <html>
      <head>
        <title>Cocoon Status [<xsl:value-of select="@status:host"/>]</title>
      </head>
      <body>
        <table class="gui_context_menu" width="180" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="big">Status</td>
          </tr>
          <tr>
      <td>
      <table class="gui_context_menu" width="180" border="0" cellspacing="0" cellpadding="0">
      <tr>
            <td width="10"/>
            <td width="170">
              <xsl:value-of select="@status:host"/>
              <br/>
              <xsl:value-of select="@status:date"/>
              <br/>
              <xsl:text>Apache Cocoon </xsl:text>
              <xsl:value-of select="@status:cocoon-version"/>
              <br/>
              Connected to:<xxx><cinclude:include src="{$xconfPath}"/></xxx>              
              <br/>
              <xsl:apply-templates/>
            </td>
      </tr>
      </table>
      </td>
          </tr>
          
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="status:group">
    <xsl:apply-templates select="status:value"/>
    <xsl:apply-templates select="status:group"/>
  </xsl:template>
  <xsl:template match="status:value">
    <xsl:choose>
      <xsl:when test="contains(@status:name,'free') or contains(@status:name,'used') or contains(@status:name,'total')">
        <span class="description">
          <xsl:value-of select="@status:name"/>
          <xsl:text>: </xsl:text>
        </span>
        <xsl:call-template name="suffix">
          <xsl:with-param name="bytes" select="number(.)"/>
        </xsl:call-template>
        <br/>
      </xsl:when>
      <!--xsl:when test="count(status:line) &lt;= 1">
          <xsl:value-of select="status:line"/>
        </xsl:when-->
      <xsl:otherwise>
        <!--span class="switch" id="{generate-id(.)}-switch" onclick="toggle('{generate-id(.)}')">[show]</span>
          <ul id="{generate-id(.)}" style="display: none">
             <xsl:apply-templates />
          </ul-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="status:line">
  </xsl:template>
  <xsl:template name="suffix">
    <xsl:param name="bytes"/>
    <xsl:choose>
      <!-- More than 4 MB (=4194304) -->
      <xsl:when test="$bytes &gt;= 4194304">
        <xsl:value-of select="round($bytes div 10485.76) div 100"/> MB
      </xsl:when>
      <!-- More than 4 KB (=4096) -->
      <xsl:when test="$bytes &gt; 4096">
        <xsl:value-of select="round($bytes div 10.24) div 100"/> KB
      </xsl:when>
      <!-- Less -->
      <xsl:otherwise>
        <xsl:value-of select="$bytes"/> B
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
    - Process Xalan extension output
    -->
  <xsl:template match="checkEnvironmentExtension">
  </xsl:template>
  <xsl:template match="item">
  </xsl:template>
</xsl:stylesheet>
