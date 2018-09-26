<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="filename"/>    
  <xsl:param name="filestem"/>  
  <!--  -->    
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
  <xsl:template match="node()[local-name()='file']">
    <xsl:if test="($filename='' and $filestem = '') or @name = $filename or ($filestem != '' and starts-with(@name,$filestem))">
    <!-- IF $FILENAME IS SET remove only that file, otherwise remove all files -->
      <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>