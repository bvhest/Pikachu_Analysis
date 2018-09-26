<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="content/octl" />

	<xsl:template match="CTN">
		<xsl:variable name="CTN" select="." />
		<xsl:variable name="cat" select="ancestor::content/octl/sql:rowset[@name='categorization']/sql:row" />

		<xsl:copy>
			<xsl:value-of select="$CTN" />
		</xsl:copy>
		<Categorization>
			<GroupCode>
				<xsl:value-of select="$cat/sql:groupcode" />
			</GroupCode>
			<CategoryCode>
				<xsl:value-of select="$cat/sql:categorycode" />
			</CategoryCode>
			<SubcategoryCode>
				<xsl:value-of select="$cat/sql:subcategorycode" />
			</SubcategoryCode>
		</Categorization>
	</xsl:template>


</xsl:stylesheet>