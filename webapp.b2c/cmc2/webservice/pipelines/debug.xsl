<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0">

  <xsl:import href="service-functions.xsl"/>

  <xsl:variable name="svcdata" select="document('service-data.xml')/service-data" />

  <xsl:template match="/">
    <root>
      <xsl:copy-of select="$svcdata/product-divisions/division[@name='CLS']"/>
      <xsl:copy-of select="svc:division-for-name('CLS')"/>
    </root>
  </xsl:template>
</xsl:stylesheet>
