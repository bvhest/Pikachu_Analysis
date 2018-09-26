<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i="http://apache.org/cocoon/include/1.0" 
                xmlns:saxon="http://saxon.sf.net/"
   >
  <!-- this template reads all possible xsl-transformations for the different product(family) leaflets 
   +   from a configuration file. When the xpath-expression from the configuration matches, an include 
   +   statement is generated for the generation of the leaflet.
   +-->

  <!-- name of the product(family) file that must be rendered to PDF -->
  <xsl:param name="fileName"/>
  
  <!-- configuration file for choosing the xsl2fo-tempalte.xml -->
  <xsl:variable name="configFile" select="document('../config/templateConfig.xml')" />
  
  <xsl:template match="/">
    <!-- productXML -->
    <xsl:variable name="productXml" select="." />
    
    <root>
        <xsl:for-each select="$configFile/templateconfigs/templateconfig">
          <xsl:variable name="testXPath" select="xpath" />
          <xsl:if test="$productXml/saxon:evaluate($testXPath)">
            <i:include>
              <xsl:attribute name="src"><xsl:text>cocoon:/renderingSub/</xsl:text><xsl:value-of select="$fileName"/><xsl:text>/</xsl:text><xsl:value-of select="doctype"/><xsl:text>/</xsl:text><xsl:value-of select="template"/></xsl:attribute>
            </i:include>
          </xsl:if>
       </xsl:for-each>
    </root>
  </xsl:template>

</xsl:stylesheet>