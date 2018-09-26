<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Content Type '<xsl:value-of select="$channel"/>' - File upload</h2><hr/>
        <xsl:for-each select="sourceResult/source">
          <p>
            <xsl:value-of select="."/>
            <xsl:if test="../message!=''">
              <br/>
              <b>
                <xsl:text>message: </xsl:text>
              </b>
              <xsl:value-of select="../message"/>
              <br/>
            </xsl:if>
          </p>
        </xsl:for-each>
			done.
			</body>
    </html>
  </xsl:template>
</xsl:stylesheet>
