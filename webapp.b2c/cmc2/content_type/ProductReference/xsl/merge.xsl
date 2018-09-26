<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="content/ProductReferenceObject">
		<xsl:variable name="newProductReferences" select="ProductReference"/>
		<xsl:variable name="spreadsheetType" select="@spreadsheetType"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*[not(local-name()='spreadsheetType')] |node()"/>
			<xsl:choose>
				<xsl:when test="$spreadsheetType = 'Accessories'">
					<xsl:apply-templates select="../../currentcontent/octl/sql:rowset/sql:row/sql:data/ProductReferenceObject/ProductReference[@ProductReferenceType = 'Variation']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="../../currentcontent/octl/sql:rowset/sql:row/sql:data/ProductReferenceObject/ProductReference[@ProductReferenceType = 'Accessory' or @ProductReferenceType = 'Performer']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		<!-- exclude obsolete references. 
	<xsl:template match="ProductReference[@delete='yes']"/>   FUTURE POSSIBILITY
	-->
	</xsl:template>
</xsl:stylesheet>
