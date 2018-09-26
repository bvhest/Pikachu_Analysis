<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->
	<xsl:import href="../../../xsl/common/xucdm-broker.xsl"/>
	<!--  -->
	<xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:groupcode|sql:groupname"/>
	<!--  -->
	<xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
	<!--  -->
	<xsl:template match="sql:rowset[@name='cat']"/>
	<!--  -->
	<xsl:template name="OptionalHeaderAttributes">
		<xsl:attribute name="StartOfPublication"><xsl:value-of select="../../sql:sop"/></xsl:attribute>
		<xsl:attribute name="EndOfPublication"><xsl:value-of select="../../sql:eop"/></xsl:attribute>
	</xsl:template>
	<!--  -->
	<xsl:template name="OptionalHeaderData">
		<xsl:for-each select="../../sql:rowset[@name='cat']/sql:row">
			<Categorization>
				<GroupCode>
					<xsl:value-of select="sql:groupcode"/>
				</GroupCode>
				<GroupName>
					<xsl:value-of select="sql:groupname"/>
				</GroupName>
				<CategoryCode>
					<xsl:value-of select="sql:categorycode"/>
				</CategoryCode>
				<CategoryName>
					<xsl:value-of select="sql:categoryname"/>
				</CategoryName>
				<SubcategoryCode>
					<xsl:value-of select="sql:subcategorycode"/>
				</SubcategoryCode>
				<SubcategoryName>
					<xsl:value-of select="sql:subcategoryname"/>
				</SubcategoryName>
			</Categorization>
		</xsl:for-each>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
