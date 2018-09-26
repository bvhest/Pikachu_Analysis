<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2" 
	xmlns:shell="http://apache.org/cocoon/shell/1.0">

	<xsl:param name="recycle"/>
	<xsl:param name="ct"/>
	<xsl:param name="localisation"/>
	<xsl:param name="dir"/>
	<xsl:variable name="l-recycle" select="$recycle != 'false'"/>
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	<xsl:template match="sql:rowset/sql:row/sql:content_type"/>
	<xsl:template match="sql:rowset/sql:row/sql:localisation"/>
	<xsl:template match="sql:rowset/sql:row/sql:object_id"/>
	<xsl:template match="sql:rowset/sql:row/sql:filelocation">
		<xsl:choose>
			<xsl:when test="$l-recycle">			
				<shell:move overwrite="true">
					<shell:source>
						<xsl:value-of select="concat($dir,'/',sql:filelocation,.,'.xml')"/>
					</shell:source>
					<shell:target>
						<xsl:value-of select="concat($dir,'/RecycleBin/',sql:filelocation,.,'.xml')"/>
					</shell:target>
				</shell:move> 
			</xsl:when>
			<xsl:otherwise>
				<shell:delete>
					<shell:source>
						<xsl:value-of select="concat($dir,'/',sql:filelocation,.,'.xml')"/>
					</shell:source>
				</shell:delete>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
