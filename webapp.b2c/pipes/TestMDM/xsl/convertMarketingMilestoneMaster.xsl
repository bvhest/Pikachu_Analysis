<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testMasterProduct.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->
	<xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:groupcode|sql:groupname"/>
	<!--  -->
	<xsl:template match="sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>
	<!--  -->
	<xsl:template match="sql:rowset[@name='cat']"/>
	<!--  -->
	<xsl:template match="sql:rowset[@name='product']">
		<xsl:apply-templates/>
	</xsl:template>
	<!--  -->
	<xsl:template match="Products" exclude-result-prefixes="cinclude sql">
		<ProductsMsg>
			<xsl:apply-templates select="sql:rowset/sql:row/sql:data/Product"/>
		</ProductsMsg>
	</xsl:template>
	<!--  -->
	<xsl:template match="sql:row" exclude-result-prefixes="cinclude sql">
		<xsl:apply-templates select="sql:data/Product"/>
	</xsl:template>
	<!--  -->
	<xsl:template match="Product" exclude-result-prefixes="cinclude sql">
		<xsl:if test="CRDate">
			<Product>
				<CTN>
					<xsl:value-of select="CTN"/>
				</CTN>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="World"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="CRDate"/>
							</MilestoneDate>
							<MilestoneWeeknumber><xsl:value-of select="CRDateYW"/></MilestoneWeeknumber>
						</Milestone>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="World"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="CRDate"/>
							</MilestoneDate>
							<MilestoneWeeknumber><xsl:value-of select="CRDateYW"/></MilestoneWeeknumber>
						</Milestone>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="World"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="CRDate"/>
							</MilestoneDate>
							<MilestoneWeeknumber><xsl:value-of select="CRDateYW"/></MilestoneWeeknumber>
						</Milestone>
			</Product>
		</xsl:if>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
