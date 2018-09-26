<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">

	<xsl:template match="root|placeholders">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="dir"/>

	<xsl:template match="sql:row">
		<xsl:variable name="ct" select="sql:content_type"/>
		<xsl:variable name="l" select="sql:localisation"/>
		<xsl:variable name="o" select="sql:object_id"/>

		<xsl:if test="/root/dir/dir:directory[@name=$ct]/dir:directory[@name=$l]/dir:file[substring-before(@name, '.xml')=$o]">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>