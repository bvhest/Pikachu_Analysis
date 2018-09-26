<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="sql:data">
    <xsl:sequence select="*"/>
  </xsl:template>

</xsl:stylesheet>
