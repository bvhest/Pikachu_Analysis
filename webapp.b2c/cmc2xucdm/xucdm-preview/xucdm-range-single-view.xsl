<?xml version="1.0" encoding="UTF-8"?>
<!-- version 1.0	nly92453	09.05.2008		added Range -->
<?altova_samplexml xUCDM_Range_Example_R000000004.xml?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
  <!-- -->
  <xsl:import href="xucdm-range-generic.xsl"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:param name="img_link" select="'http://pww.p3c.philips.com/cgi-bin/newmpr/get.pl'"/>
  <xsl:template match="/Products">
    <xsl:call-template name="range_head"/>
    <xsl:apply-templates select="Node" mode="range"/>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
