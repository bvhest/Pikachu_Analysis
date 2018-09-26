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
  <!-- -->
  <xsl:template match="/root">
    <xsl:variable name="location" select="@location"/>
    <xsl:variable name="channel" select="@channel"/>
    <html>
      <body contentID="content">
        <h2>Add/Edit channel - result</h2>
        <hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_add_directories/', $location, '?channel=', $channel)"/></xsl:attribute>
          <xsl:for-each select="//sql:error">
            <p>
              <xsl:value-of select="node()"/>
            </p>
          </xsl:for-each>
          <p>done</p>
          <input name="Name" size="60" type="hidden">
            <xsl:attribute name="value"><xsl:value-of select="$channel"/></xsl:attribute>
          </input>
          <input id="AddDirectories" style="width: 137px" type="submit" value="Next"/>
        </form>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
