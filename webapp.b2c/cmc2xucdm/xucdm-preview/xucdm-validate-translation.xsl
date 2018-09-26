<?xml version="1.0" encoding="UTF-8"?>
<!-- version 1.1	nly92174	27.03.2007	taking into account optional trans tags in the translated text	-->
<!-- version 1.5	nly90671	26.06.2007		corrected productname display	-->
<!-- version 1.5	nly90671	26.06.2007		corrected popup	-->
<!-- version 1.6	nly90671	19.11.2007		added brandstuff	-->
<!-- version 1.7	nly90671	28.02.2007		added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html>
      <xsl:apply-templates select="//*[@translate='yes'][(string-length(.) &gt; @maxlength and not(trans/text())) or (trans/text() and string-length(trans) &gt; @maxlength)]"/>
    </html>
  </xsl:template>
  <xsl:template match="node()">
    <p id="{@key}">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
</xsl:stylesheet>
