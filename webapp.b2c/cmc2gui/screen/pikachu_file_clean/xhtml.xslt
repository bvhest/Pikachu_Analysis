<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
        <xsl:if test="$channel = ''">
          <h2>Select a content type first!!</h2>
        </xsl:if>
        <xsl:if test="$channel != ''">
          <h2>Content Type '<xsl:value-of select="$channel"/>' - confirm clean up of <xsl:value-of select="$box"/></h2>
          <hr/>
          <p>This will move all files in <xsl:value-of select="$box"/> to archive.</p>
          <br/>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl,'pikachu_',$box,'_clean_real/',$param1,'/',$param2)"/></xsl:attribute>Continue</a>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
