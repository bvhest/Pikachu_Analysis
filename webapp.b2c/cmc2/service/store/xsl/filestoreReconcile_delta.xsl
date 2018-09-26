<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="ct"/>
	<xsl:param name="localisation"/>
	<xsl:param name="not-in-filestore"/>
	
	<xsl:key name="db_key" match="/report/database" use="db_filename"/>
	<xsl:key name="fs_key" match="/report/filestore" use="fs_filename"/>

	
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="filestore">
		<not-in-database>
			<xsl:for-each select="fs_filename">
				<xsl:if  test="not (key('db_key',.) )">
					<fs_filename><xsl:value-of select="."/></fs_filename>
				</xsl:if>
			</xsl:for-each>
		</not-in-database>
	</xsl:template>
	<xsl:template match="database">
		<xsl:if test="$not-in-filestore != 'false'">
			<not-in-filestore>
				<xsl:for-each select="db_filename">
					<xsl:if  test="not (key('fs_key',.) ) ">
						<db_filename><xsl:value-of select="."/></db_filename>
					</xsl:if>
				</xsl:for-each>
			</not-in-filestore>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>


