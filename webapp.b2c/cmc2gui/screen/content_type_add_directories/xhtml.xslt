<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="param1"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	  
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
  <xsl:template match="/root">
    <xsl:variable name="channelname">
      <xsl:value-of select="$param1"/>
    </xsl:variable>
    <html>
      <body contentID="content">
        <h2>Create content type directories for '<xsl:value-of select="$param1"/>'</h2>
        <form method="POST" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url,$sectionurl)"/>content_type_add_directories_real/<xsl:value-of select="$param1"/>?channel=<xsl:value-of select="$channelname"/></xsl:attribute>
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
</xsl:stylesheet>
