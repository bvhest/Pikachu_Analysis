<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
	<xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//shellResult[action != 'moved']/execution[./text() ne 'success']">
        <html>
          <body>
            <xsl:copy-of select="//result/html/body/*"/>
            <p style="color: red">Some files that already were created could not be deleted:</p>
            <p style="color: red">
              <xsl:for-each select="//shellResult[execution[./text() ne 'success']]">
                <xsl:value-of select="message"/>
              </xsl:for-each>
            </p>
          </body>
        </html>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="//result/*" copy-namespaces="no"/>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>

</xsl:stylesheet>
