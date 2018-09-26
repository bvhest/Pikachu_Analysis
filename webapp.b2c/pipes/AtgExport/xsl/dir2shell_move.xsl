<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="sourceDir" as="xs:string"/>
	<xsl:param name="targetDir" as="xs:string"/>
	<xsl:param name="archiveFTPDir" as="xs:string"/>
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
					<xsl:value-of select="concat($timestamp,'/',$locale)"/>
				</xsl:otherwise>					
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="filename" select="concat('../',$sourceDir,'/',@name)"/>
		<xsl:variable name="doc" select="document($filename)"/>
		<xsl:choose>
			<xsl:when test="normalize-space($doc/gsa-template/import-items) = '' and not($doc/gsa-template/import-items/add-item/RichTexts)">
				<shell:delete>
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
				</shell:delete>
			</xsl:when>
			<xsl:otherwise>
			     <!-- 2010-10-04, JWE: The explicit copy of the process archive to archive_ftp provides the Pikachu team
                      with a copy of the output to ATG. This copy ensures that we know what we have sent at what time,
                      irrespective of manual modifications of the archive content ;-) -->
                 <shell:copy overwrite="true">
                    <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
                    <shell:target><xsl:value-of select="concat($archiveFTPDir,'/',$subdir,'/',@name)"/></shell:target>
                </shell:copy>
				<shell:move overwrite="true">
					<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
					<shell:target><xsl:value-of select="concat($targetDir,'/',$subdir,'/',@name)"/></shell:target>
				</shell:move>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>