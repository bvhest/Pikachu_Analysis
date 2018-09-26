<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
   <!-- -->	
	<xsl:template match="/root">
		<root>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</root>
	</xsl:template>
   <!-- -->	
	<xsl:template match="sql:rowset/sql:row">
		<cinclude:include src="cocoon:/createBatches/{sql:content_type}/{sql:localisation}" />
	</xsl:template>
   <!-- -->	
</xsl:stylesheet>