<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="batchsize">10</xsl:param>
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="country">test</xsl:param>
	<xsl:param name="locale">test</xsl:param>
	<xsl:param name="dir">temp/</xsl:param>
	<xsl:param name="exportdate"/>
	<!-- -->
	<xsl:template match="/root">
				<xsl:variable name="docDate" select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) "/>

		<Categorization DocTimeStamp="{$docDate}" >
			<xsl:apply-templates select="sql:rowset"/>
		</Categorization>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<xsl:for-each-group select="sql:row" group-by="sql:catalogcode">
			<Catalog Language="{$locale}" IsMaster="false">
				<CatalogCode>
					<xsl:value-of select="current-grouping-key()"/>
				</CatalogCode>
				<CatalogName>
					<xsl:value-of select="sql:catalogname"/>
				</CatalogName>
				<CatalogType/>
				<FixedCategorization>
					<xsl:for-each-group select="current-group()" group-by="sql:groupcode">
						<Group>
							<GroupCode>
								<xsl:value-of select="current-grouping-key()"/>
							</GroupCode>
							<GroupName>
								<xsl:value-of select="sql:groupname"/>
							</GroupName>
							<GroupRank>
								<xsl:value-of select="sql:grouprank"/>							
							</GroupRank>
							<xsl:for-each-group select="current-group()" group-by="sql:categorycode">
								<Category>
									<CategoryCode>
										<xsl:value-of select="current-grouping-key()"/>
									</CategoryCode>
									<CategoryName>
										<xsl:value-of select="sql:categoryname"/>
									</CategoryName>
									<CategoryRank>
										<xsl:value-of select="sql:categoryrank"/>							
									</CategoryRank>
									<xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
										<SubCategory>
											<SubCategoryCode>
												<xsl:value-of select="current-grouping-key()"/>
											</SubCategoryCode>
											<SubCategoryName>
												<xsl:value-of select="sql:subcategoryname"/>
											</SubCategoryName>
											<SubCategoryRank>
												<xsl:value-of select="sql:subcategoryrank"/>							
											</SubCategoryRank>											
										</SubCategory>
									</xsl:for-each-group>
								</Category>
							</xsl:for-each-group>
						</Group>
					</xsl:for-each-group>
				</FixedCategorization>
			</Catalog>
		</xsl:for-each-group>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
