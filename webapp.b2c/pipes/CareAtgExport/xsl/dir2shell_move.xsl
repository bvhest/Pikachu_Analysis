<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="sourceDir" as="xs:string"/>
	<xsl:param name="targetDir" as="xs:string"/>
	<xsl:param name="timestamp" as="xs:string"/>
	<xsl:param name="locale"    as="xs:string"/>
	<xsl:template match="/">
		<page>
			<xsl:apply-templates select="//dir:file"/>
		</page>
	</xsl:template>

	<xsl:template match="dir:file">
		<xsl:variable name="subdir">
			<xsl:choose>
				<xsl:when test="contains(@name,'-master-')">
					<xsl:value-of select="concat($timestamp,'/master-data')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($timestamp,'/',tokenize(@name,'-')[position()=3])"/>
				</xsl:otherwise>					
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="filename" select="concat('../',$sourceDir,'/',@name)"/>
		<xsl:variable name="doc" select="document($filename)"/>
		<xsl:variable name="ext" select="substring-after(@name,'.') "/>
		<xsl:choose>
			<xsl:when test="$ext = 'dat' ">
				<shell:move overwrite="true">
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
					<shell:target><xsl:value-of select="concat($targetDir,'/',$subdir,'/',@name)"/></shell:target>
				</shell:move>
			</xsl:when>
			<xsl:when test="count($doc/gsa-template/import-items/add-item) = 0 ">
				<shell:delete>
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
				</shell:delete>
			</xsl:when>
			<xsl:when test="contains(@name,'master_global')">
				<shell:delete>
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
				</shell:delete>
			</xsl:when>
			<xsl:otherwise>
				<shell:move overwrite="true">
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
					<shell:target><xsl:value-of select="concat($targetDir,'/',$subdir,'/',@name)"/></shell:target>
				</shell:move>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>