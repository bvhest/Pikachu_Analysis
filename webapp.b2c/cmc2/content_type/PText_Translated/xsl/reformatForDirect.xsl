<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="ItemText">
      <source>
			<xsl:copy-of select="." copy-namespaces="no"/>
		</source>
		<xsl:copy-of select="." copy-namespaces="no"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="@translated">
      <xsl:attribute name="translated">yes</xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
