<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="process"/>
  <!-- $catalogfilename will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->  
  <xsl:param name="catalogfilename"/>
  <xsl:param name="workflow"/>
	
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>

	<xsl:template match="sourceResult">
				<cinclude:include src="{$process}/{source}?catalogfilename={$catalogfilename}&amp;workflow={$workflow}" />
	</xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>