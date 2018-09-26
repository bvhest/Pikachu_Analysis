<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <xsl:param name="param3"/>
  <xsl:variable name="channel">
    <xsl:value-of select="$param1"/>
  </xsl:variable>
  <xsl:variable name="box">
    <xsl:value-of select="$param2"/>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Content Type '<xsl:value-of select="$channel"/>' - <xsl:value-of select="$box"/> deletion result</h2><hr/>
        <xsl:apply-templates select="//source"/>
        <br/>
        <p>done deleting</p>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="//source">
    <p>
      <xsl:value-of select="node()"/>
      <xsl:if test="../message!=''">
        <br/>
        <b>
          <xsl:text>message: </xsl:text>
        </b>
        <xsl:value-of select="../message"/>
        <br/>
      </xsl:if>
    </p>
  </xsl:template>
</xsl:stylesheet>
