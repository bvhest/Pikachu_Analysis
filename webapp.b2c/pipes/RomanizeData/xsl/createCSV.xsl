<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:saxon="http://saxon.sf.net/" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source">
	<!-- -->
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
	<!-- -->
  <xsl:template match="/">
    <root>Master,Reference<xsl:text>
</xsl:text>
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>  
	<!-- -->  
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>  
	<!-- -->
	<xsl:template match="master">
		<xsl:value-of select="."/>,<xsl:value-of select="following-sibling::node()[local-name()='reference']"/><xsl:text>
</xsl:text>    
	</xsl:template>
</xsl:stylesheet>
