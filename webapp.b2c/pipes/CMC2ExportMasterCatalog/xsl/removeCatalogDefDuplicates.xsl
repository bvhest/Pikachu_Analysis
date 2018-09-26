<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no" >
      <xsl:apply-templates select="node()|@*"/>
		</xsl:copy>      
	</xsl:template>											
  <!-- -->
	<xsl:template match="catalog-definition">
		<xsl:copy copy-namespaces="no" >
      <xsl:apply-templates select="@*"/>
      <xsl:for-each-group select="object" group-by="@o">
      <object o="{current-grouping-key()}"/>
      </xsl:for-each-group>
		</xsl:copy>      
	</xsl:template>			  
</xsl:stylesheet>