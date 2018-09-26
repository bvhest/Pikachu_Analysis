<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
	
	<xsl:template match="/">
			<xsl:apply-templates select="//dir:file"/>
	</xsl:template>

	<xsl:template match="dir:file">
		<cinclude:include src="{concat('cocoon:/fileReport_',$dir,'_',@name)}" />
	</xsl:template>
</xsl:stylesheet>