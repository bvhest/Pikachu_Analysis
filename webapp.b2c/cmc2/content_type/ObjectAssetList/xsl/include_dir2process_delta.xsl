<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="output-folder"/> 
	<xsl:param name="process"/> 
		
	<xsl:template match="/">
		<root>
			<xsl:variable name="list">
				<list>
					<xsl:apply-templates/>
				</list>
			</xsl:variable>
			<xsl:for-each-group select="$list/list/entry" group-by="substring(@name, 23)">
			  <xsl:for-each select="current-group()">
				<xsl:if test="count(current-group()) = position()">
		           <cinclude:include src="cocoon:/{$process}/{$output-folder}/{current-group()/@name}"/>
		        </xsl:if>
		      </xsl:for-each>
			</xsl:for-each-group>
		</root>
	</xsl:template>

	<xsl:template match="//dir:file">
		<entry>
			<xsl:variable name="filebase" select="substring-before(@name, '.')"/>
			<xsl:variable name="filedate" select="substring(@name, string-length($filebase)-13, 14)"/>
			<xsl:variable name="filetype" select="substring-before(@name, $filedate)"/>
			<xsl:attribute name="filedate" select="$filedate"/>
			<xsl:attribute name="filetype" select="$filetype"/>
			<xsl:attribute name="name" select="@name"/>
			<xsl:attribute name="fileExt" select="substring-after(@name, '.')"/>
			<xsl:attribute name="filebase" select="$filebase"/>		
		</entry>
	</xsl:template>
</xsl:stylesheet>