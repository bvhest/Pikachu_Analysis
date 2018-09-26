<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	exclude-result-prefixes="cinclude xsl dir xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="dir">
		<xsl:apply-templates select="node()"/>
	</xsl:template>	
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	
</xsl:stylesheet>