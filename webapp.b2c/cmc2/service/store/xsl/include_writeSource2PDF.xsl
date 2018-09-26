<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:include="http://apache.org/cocoon/include/1.0">  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="zip">no</xsl:param> 
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sourceResult">
    <include:include src="cocoon:/PDF/{$ct}/{source}" />  
    <xsl:if test="$zip='yes'">
      <include:include src="cocoon:/ZipFiles/{$ct}" />  
    </xsl:if>
    <include:include src="cocoon:/XML/{source}" />  
    <include:include src="cocoon:/emailPDF/{source}" />    
    <include:include src="cocoon:/saveEntryFile/{source}" />
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
