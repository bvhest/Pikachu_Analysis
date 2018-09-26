<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:include="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:param name="matcher"/>
	
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>

	<xsl:template match="sql:row">
		<ctl-process>
			<include:include src="{concat('cocoon:/',$matcher,'/',sql:content_type,'/',sql:localisation) }" />
		</ctl-process>
	</xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>