<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testProduct.xml?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  exclude-result-prefixes="xsl cinclude">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  
  <!--  -->
  <xsl:template match="/ROWSET">
    <root>
      <xsl:apply-templates select="sourceResult/source"/>
    </root>
  </xsl:template>
  <!--  -->
  <xsl:template match="sourceResult/source">
      <cinclude:include>
        <xsl:attribute name="src">cocoon:/includeFile.<xsl:value-of select="."/>?filename=<xsl:value-of select="replace(replace(.,'xml','xls'),'temp','outbox')"/></xsl:attribute>
      </cinclude:include>
  </xsl:template>
  <!--  -->

  <!--  -->
</xsl:stylesheet>
