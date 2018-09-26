<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml PhilipsCatalog_da_DK.1.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->
  <xsl:template match="/">
	<root>
	<xsl:apply-templates select="Products/Product"/>
	</root>
  </xsl:template>
  <!--  -->
  <xsl:template match="Product">
	<ctn id="{CTN}"/>
  </xsl:template>
  <!--  -->
  <!--  -->
</xsl:stylesheet>
