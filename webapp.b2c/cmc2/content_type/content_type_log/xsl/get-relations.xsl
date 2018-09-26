<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="sql:data">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="sql:*">
		<xsl:apply-templates select="sql:*"/>
	</xsl:template>
	

	<xsl:template match="ctl">
			<xsl:copy>
			<xsl:copy-of select="@*"/>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
select *
from ctl_relations
connect by prior input_content_type = output_content_type and prior input_localisation = output_localisation
start with output_content_type = '<xsl:value-of select="@ct"/>' and output_localisation = '<xsl:value-of select="@l"/>'
			</sql:query>
		</sql:execute-query>
		</xsl:copy>	
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>