<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	exclude-result-prefixes="cinclude xdt fn dir">
	<!-- -->
	<xsl:param name="channel" />
	<xsl:param name="locale" />
	<xsl:param name="exportdate" />
	<xsl:variable name="ismaster"
		select="if($locale = 'MASTER') then 'true' else 'false'" />
	<!-- -->
	<xsl:template match="/root">
		<xsl:variable name="docDate"
			select="concat(substring($exportdate,1,4),'-',substring($exportdate,5,2),'-', substring($exportdate,7,2),'T',substring($exportdate,10,2),':',substring($exportdate,12,2),':00' ) " />
		<Products DocTimeStamp="{$docDate}">
			<xsl:apply-templates select="sql:rowset" />
		</Products>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<xsl:for-each-group select="sql:row" group-by="sql:catalogcode">
		<xsl:variable name="catalogCode" select="current-grouping-key()" />

			<xsl:for-each-group select="current-group()" group-by="sql:groupcode">
			
				<Product Country="{substring-after($locale,'_')}" Locale="{$locale}" >
				<xsl:attribute name="LastModified" select="current()/sql:lastmodified"/>
					<ID><xsl:value-of select="concat(sql:groupcode,'_',$locale)" /></ID>
					<CTN><xsl:value-of select="sql:groupcode" /></CTN>
					<ProductType>Group</ProductType>
					<Status>Active</Status>
					<Categorization Type="{$catalogCode}">
						<GroupCode><xsl:value-of select="sql:groupcode" /></GroupCode>
						<GroupName><xsl:value-of select="sql:groupname" /></GroupName>
					</Categorization>
					<ProductName><xsl:value-of select="concat('Group:',sql:groupname)" /></ProductName>
				</Product>
				<xsl:for-each-group select="current-group()" group-by="sql:categorycode">
				
					<Product Country="{substring-after($locale,'_')}" Locale="{$locale}" >
					<xsl:attribute name="LastModified" select="current()/sql:lastmodified"/>
						<ID><xsl:value-of select="concat(sql:categorycode,'_',$locale)" /></ID>
						<CTN><xsl:value-of select="sql:categorycode" /></CTN>
						<ProductType>Category</ProductType>
						<Status>Active</Status>
						<Categorization Type="{$catalogCode}">
							<GroupCode><xsl:value-of select="sql:groupcode" /></GroupCode>
							<GroupName><xsl:value-of select="sql:groupname" /></GroupName>
							<CategoryCode><xsl:value-of select="sql:categorycode" /></CategoryCode>
							<CategoryName><xsl:value-of select="sql:categoryname" /></CategoryName>
						</Categorization>
						<ProductName><xsl:value-of select="concat('Category:',sql:categoryname)" /></ProductName>
					</Product>
					<xsl:for-each-group select="current-group()" group-by="sql:subcategorycode">
						<Product Country="{substring-after($locale,'_')}" Locale="{$locale}">
						 <xsl:attribute name="LastModified" select="current()/sql:lastmodified"/>
							<ID><xsl:value-of select="concat(current-grouping-key(),'_',$locale)" /></ID>
							<CTN><xsl:value-of select="current-grouping-key()" /></CTN>
							<ProductType>Subcategory</ProductType>
							<Status>Active</Status>
							<Categorization Type="{$catalogCode}">
								 <GroupCode><xsl:value-of select="sql:groupcode" /></GroupCode> 
									<GroupName><xsl:value-of select="sql:groupname" /></GroupName> 
									<CategoryCode><xsl:value-of select="sql:categorycode" /></CategoryCode> 
									<CategoryName><xsl:value-of select="sql:categoryname" /></CategoryName> 
								<SubcategoryCode><xsl:value-of select="current-grouping-key()" /></SubcategoryCode>
								<SubcategoryName><xsl:value-of select="sql:subcategoryname" /></SubcategoryName>
							</Categorization>
							<ProductName><xsl:value-of select="concat('Subcategory:',sql:subcategoryname)" /></ProductName>
						</Product>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</xsl:for-each-group>

	</xsl:template>
</xsl:stylesheet>