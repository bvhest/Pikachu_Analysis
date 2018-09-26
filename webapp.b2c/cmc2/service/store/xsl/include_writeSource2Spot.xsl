<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:include="http://apache.org/cocoon/include/1.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>

	<xsl:template match="sourceResult">
		<include:include src="cocoon:/UpdateProduct/{source}" />
		<include:include src="cocoon:/UpdateAsset/{source}" />		
    <!-- Disabled at Natasje's request [2008-03-11] 
		<include:include src="cocoon:/UpdateKeyValue/{source}" />
    -->
		<include:include src="cocoon:/UpdateCatalog/{source}" />
		<include:include src="cocoon:/UpdatePMD/{source}" />
		<include:include src="cocoon:/saveEntryFile/{source}" />
	</xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>