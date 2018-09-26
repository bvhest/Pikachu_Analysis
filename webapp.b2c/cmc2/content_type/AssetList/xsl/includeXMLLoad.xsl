<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="path"/>
  <xsl:param name="storeurl"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()"/>  
    </root>
  </xsl:template>      
  <!-- -->
  <xsl:template match="dir:file">
    <xsl:variable name="sourcefile" select="@name"/>
    <xsl:variable name="filename" select="concat($path,'/temp_save/',$sourcefile)"/>
    
     <xsl:variable name="ts" select="substring(@name,7,14)"/>
    <entries>
      <xsl:copy-of select="@*"/>
	   <cinclude:include><xsl:attribute name="src"><xsl:value-of select="concat($storeurl,$filename, '?createPlaceholder=y')"/></xsl:attribute></cinclude:include>
    </entries>
  </xsl:template>
  <!-- -
  <xsl:template match="entry[not(@valid='true' and result = 'OK')]">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="result"/>
    </xsl:copy>
  </xsl:template>  -->
</xsl:stylesheet>