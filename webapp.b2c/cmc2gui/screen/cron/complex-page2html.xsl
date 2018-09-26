<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="contextPath" select="string('/cocoon')"/>

  <xsl:template match="/">
    <html>
      <head>
        <!--link href="main.css" type="text/css" rel="stylesheet"/-->
        <xsl:apply-templates select="document/header/style"/>
        <xsl:apply-templates select="document/header/script"/>
      </head>
      <body contentID="content">

        <p>
          <xsl:choose>
            <xsl:when test="document/body/row">
              <table width="100%">
                <xsl:apply-templates select="document/body/*"/>
              </table>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="document/body/*"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>

      </body>
    </html>
  </xsl:template>

  <xsl:template match="style">
    <link type="text/css" rel="stylesheet" href="{@href}"/>
  </xsl:template>
 
  <xsl:template match="script">
    <script type="text/javascript" src="{@href}"/>
  </xsl:template>
 
  <xsl:template match="tab">
    <a href="{@href}"><i><xsl:value-of select="@title"/></i></a>&#160;
  </xsl:template>
 
  <xsl:template match="row">
    <tr>
      <xsl:apply-templates select="column"/>
    </tr>
  </xsl:template>
 
  <xsl:template match="column">
    <td valign="top">
      <h4 class="samplesGroup"><xsl:value-of select="@title"/></h4>
      <p class="samplesText"><xsl:apply-templates/></p>
    </td> 
  </xsl:template>

  <xsl:template match="section">
    <xsl:choose> <!-- stupid test for the hirachy deep -->
      <xsl:when test="../../../section">
        <h5><xsl:value-of select="title"/></h5>
      </xsl:when>
      <xsl:when test="../../section">
        <h4><xsl:value-of select="title"/></h4>
      </xsl:when>
      <xsl:when test="../section">
        <h2 class="samplesGroup"><xsl:value-of select="title"/></h2><hr/>
      </xsl:when>
    </xsl:choose>
    <p>
      <xsl:apply-templates select="*[name()!='title']"/>
    </p>
  </xsl:template>

  <xsl:template match="source">
    <div style="background: #b9d3ee; border: thin; border-color: black; border-style: solid; padding-left: 0.8em; 
                padding-right: 0.8em; padding-top: 0px; padding-bottom: 0px; margin: 0.5ex 0px; clear: both;">
      <pre>
        <xsl:value-of select="."/>
      </pre>
    </div>
  </xsl:template>
 
  <xsl:template match="link">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="strong">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>
 
  <xsl:template match="anchor">
    <a name="{@name}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*|@*|node()|text()" priority="-1">
    <xsl:copy><xsl:apply-templates select="*|@*|node()|text()"/></xsl:copy>
  </xsl:template>

</xsl:stylesheet>
