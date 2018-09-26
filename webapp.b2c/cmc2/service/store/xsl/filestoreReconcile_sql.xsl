<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:param name="ct"/>
	<xsl:param name="localisation"/>
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="/">
		<report>
			<xsl:apply-templates/>
			<sql:execute-query>
				<sql:query>
              select substr(data,7) as fpath 
              from octl_store 
              where content_type = '<xsl:value-of select="$ct"/>' 
                and localisation = '<xsl:value-of select="$localisation"/>'
                and data is not null
          </sql:query>
			</sql:execute-query>
		</report>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
