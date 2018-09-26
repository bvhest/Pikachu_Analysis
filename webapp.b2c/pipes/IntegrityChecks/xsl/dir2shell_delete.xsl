<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
	<xsl:param name="leaf"/>
	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>

	<xsl:template match="dir:file">
		<shell:delete>
			<xsl:variable name="fulldirectorypath">
				<xsl:choose>
					<xsl:when test="../@name != $leaf">
						<xsl:value-of select="concat($dir,'/',../@name)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$dir"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<shell:source><xsl:value-of select="concat($fulldirectorypath,'/',@name)"/></shell:source>			
		</shell:delete>
	</xsl:template>

</xsl:stylesheet>
