<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <!-- -->
	<xsl:template match="/">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
   <!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
   <!-- -->
	<xsl:template match="entry">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="*"/>
			<sql:execute-query>
				<sql:query>
					select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts 
					  from octl 
                where content_type = '<xsl:value-of select="@ct"/>' 
					   and localisation = '<xsl:value-of select="@l"/>' 
					   and object_id    = '<xsl:value-of select="@o"/>'
				</sql:query>
			</sql:execute-query>
		</xsl:element>
	</xsl:template>
   <!-- -->
</xsl:stylesheet>
