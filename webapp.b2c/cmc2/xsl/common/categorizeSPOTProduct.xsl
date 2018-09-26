<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="content/object" />

	<xsl:template match="CTN">
		<xsl:variable name="CTN" select="." />
		<xsl:variable name="cat" select="ancestor::content/object/categorizations/internal-categorization" />

		<xsl:copy>
			<xsl:value-of select="$CTN" />
		</xsl:copy>
		<Categorization>
			<GroupCode>
				<xsl:value-of select="$cat/GroupCode" />
			</GroupCode>
			<CategoryCode>
				<xsl:value-of select="$cat/CategoryCode" />
			</CategoryCode>
			<SubcategoryCode>
				<xsl:value-of select="$cat/SubCategoryCode" />
			</SubcategoryCode>
		</Categorization>
	</xsl:template>


</xsl:stylesheet>