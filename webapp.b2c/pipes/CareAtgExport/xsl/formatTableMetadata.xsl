<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="external_only"/>
	<!-- -->
	<!--
Directory requirements
drop directory ATG;
create directory ATG as ' ';
grant read on directory trigo to cmc2_dev1_schema;
grant write on directory trigo to cmc2_dev1_schema;

-->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sql:rowset|column"/>
	<xsl:template match="table">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="column">
				<xsl:variable name="column-name" select="upper-case(@name)"/>
				<xsl:for-each select="../sql:rowset/sql:row[sql:column_name=$column-name]">
					<xsl:element name="column">
						<xsl:attribute name="name"><xsl:value-of select="sql:column_name"/></xsl:attribute>
						<xsl:attribute name="data-type"><xsl:value-of select="sql:data_type"/></xsl:attribute>
						<xsl:attribute name="data-length"><xsl:value-of select="sql:data_length"/></xsl:attribute>
						<xsl:attribute name="primary-key"><xsl:value-of select="sql:constraint_type"/></xsl:attribute>
						<xsl:attribute name="position"><xsl:value-of select="sql:position"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
