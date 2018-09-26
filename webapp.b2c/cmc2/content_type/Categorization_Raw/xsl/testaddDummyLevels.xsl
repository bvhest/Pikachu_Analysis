<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
	<root>
		<groups><xsl:value-of select="count(//GroupCode)"/></groups>
		<categories><xsl:value-of select="count(//CategoryCode)"/></categories>
		<families><xsl:value-of select="count(//SubCategoryCode)"/></families>

	</root>
	</xsl:template>
	</xsl:stylesheet>