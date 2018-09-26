<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <!-- -->	
	
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	  <!-- -->
	<xsl:template match="//dir:directory/dir:directory">
		<cinclude:include src="{concat('cocoon:/mergePerLocale/',@name,'/')}" /> 
	</xsl:template>
  <!-- -->
  
</xsl:stylesheet>