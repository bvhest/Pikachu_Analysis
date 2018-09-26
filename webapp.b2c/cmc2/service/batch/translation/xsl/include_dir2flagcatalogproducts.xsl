<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <!-- -->  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="//dir:file">
  <!--+ 
      |  E.g.
      |    <dir:file name="catalog.xml" lastModified="1189076460766" date="9/6/07 1:01 PM" size="14027"/>
      +-->      
      <cinclude:include src="cocoon:/flagCatalogProducts/{$ct}/{@name}"/>      
      <!--cinclude:include src="cocoon:/archiveCatalogFile/{$ct}/{@name}"/-->      
  </xsl:template>
</xsl:stylesheet>