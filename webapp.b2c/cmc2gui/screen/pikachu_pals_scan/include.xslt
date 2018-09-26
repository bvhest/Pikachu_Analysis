<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml request-include.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="param2"/>
  <!-- -->
  <xsl:template match="/h:request">
    <xsl:apply-templates select="h:requestParameters"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:requestParameters">
    <cinclude:include>
      <xsl:attribute name="src" select="concat('cocoon:/pikachupalsscan!', normalize-space(h:parameter[@name='directory']/h:value),'!',upper-case(normalize-space(h:parameter[@name='CTN']/h:value)),'!', normalize-space(h:parameter[@name='locale']/h:value),'.xml')"/>
    </cinclude:include>
  </xsl:template>
  <!-- -->
  <!-- -->
</xsl:stylesheet>
