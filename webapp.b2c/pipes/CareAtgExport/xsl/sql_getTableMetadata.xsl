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
<!--		select table_name,column_name, DATA_TYPE, DATA_LENGTH from all_tab_columns where table_name = '<xsl:value-of select="upper-case(@name)"/>' order by column_id -->
		
select  atc.table_name,atc.column_name, atc.DATA_TYPE, atc.DATA_LENGTH, v.constraint_type, v.position 
from all_tab_columns atc
left outer join (select dcc.owner, dcc.table_name, dcc.column_name, dcc.position, dc.constraint_type from all_cons_columns dcc
                 inner join all_constraints dc on dc.constraint_name = dcc.constraint_name and dc.constraint_type ='P'
                 where dcc.table_name = '<xsl:value-of select="upper-case(@name)"/>'
                            ) v on   v.table_name = atc.table_name and v.column_name = atc.column_name
where atc.table_name = '<xsl:value-of select="upper-case(@name)"/>'
order by column_id

					</sql:query>
				</sql:execute-query>			
		</xsl:copy>

</xsl:template>
</xsl:stylesheet>