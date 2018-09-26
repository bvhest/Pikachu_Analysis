<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:template match="sql:rowset">
		<list>
			<xsl:apply-templates/>
		</list>
	</xsl:template>	
	
	<xsl:template match="sql:row">
		<include src="cocoon:/process/{sql:content_type}/{sql:localisation}/{sql:object_id}"/>
		<i:include src="cocoon:/process/{sql:content_type}/{sql:localisation}/{sql:object_id}" xmlns:i="http://apache.org/cocoon/include/1.0"/>
	</xsl:template>	
	
</xsl:stylesheet>