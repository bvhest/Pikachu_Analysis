<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                exclude-result-prefixes="info">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="@*[not(starts-with(name(.),'info:'))]|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*[starts-with(name(.),'info:')]"/>
</xsl:stylesheet>
