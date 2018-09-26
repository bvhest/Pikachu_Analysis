<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
  <xsl:param name="channel"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
	<xsl:if test="$section">
	  <xsl:value-of select="concat('section/', $section, '/')"/>
	</xsl:if>
  </xsl:variable>	
  <!-- -->
  <xsl:template match="/root">
    <xsl:variable name="channelname">
      <xsl:value-of select="$param1"/>
    </xsl:variable>
    <html>
      <body contentID="content">
        <h2>
          <xsl:value-of select="sql:rowset/sql:row/sql:name"/> - Add channel directories</h2>
        <hr/>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_add_directories_real/', $param1, '?channel=', $channelname)"/></xsl:attribute>
          <p>
            <b>When pressing the Next button the following directories will be created:</b>
            <br/>
            <br/>
            <xsl:value-of select="concat($channelname,'/inbox')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/outbox')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/disclaimers')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/temp')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/archive')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/archive_ftp')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/logs')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/processed')"/>
            <br/>
            <xsl:value-of select="concat($channelname,'/cache')"/>
          </p>
          <input name="Name" size="60" type="hidden">
            <xsl:attribute name="value"><xsl:value-of select="$channelname"/></xsl:attribute>
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
