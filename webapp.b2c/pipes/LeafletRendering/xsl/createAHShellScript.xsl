<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="fo-xml-file"/>
  <xsl:param name="pdf-file"/>
  <xsl:param name="config-file"/>
  <xsl:param name="ahf-home-dir"/>
  <xsl:param name="outbox"/>
  
  <xsl:template match="/">
    <xsl:value-of select="concat($ahf-home-dir, '/run.sh -d ', $fo-xml-file, ' -i ', $config-file, ' -o ', $pdf-file, ' -stdout -x 4')"/><xsl:text>
</xsl:text>
    <!-- Copy the PDF to the outbox -->
    <xsl:text>if [ $? == 0 ]; then </xsl:text>
    <xsl:value-of select="concat('cp ', $pdf-file, ' ', $outbox)"/><xsl:text>; fi
</xsl:text>
    
  </xsl:template>
</xsl:stylesheet>