<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
    <xsl:template match="root">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>
    
    <xsl:template match="language/group">
      <export>
      <xsl:apply-templates select="@*|node()"/>
      </export>
    </xsl:template>
    
    <xsl:template match="@locales">
      <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="group">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
    
    <xsl:template match="source|execution">
      <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
  
    <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
    
</xsl:stylesheet>