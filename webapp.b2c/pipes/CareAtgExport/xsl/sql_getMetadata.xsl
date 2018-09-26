<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="table">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
				<sql:execute-query >
					<sql:query>
		select table_name,column_name, DATA_TYPE, DATA_LENGTH from all_tab_columns where table_name = upper('<xsl:value-of select="@name"/>') order by column_id
					</sql:query>
				</sql:execute-query>			
		</xsl:copy>

</xsl:template>
</xsl:stylesheet>