<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="dir"/>
	
	<!-- MDM Asset-->	
	<!--Product>
	  <CTN>170C6FS/00</CTN>
		<Catalog>
			<CatalogDestination>NL</CatalogDestination>
			<CatalogType>PMT_NL_Catalog</CatalogType>
			<CatalogDomain>DAP</CatalogDomain>
			<CatalogCustomer>CONSUMER</CatalogCustomer>
			<CatalogChannel>PMT_NL_Catalog</CatalogChannel>
			<CatalogState>active</CatalogState>
			<Publisher>Procoon</Publisher>
			<StartDate>2007-01-01T00:00:00</StartDate>
			<EndDate>2008-12-31T00:00:00</EndDate>
			<Rank/>
		</Catalog>
	</Product-->
	<!-- -->
	<xsl:template match="entries">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/','xSPOT_Marketing_Catalog_010.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
			</source:source>
			<source:fragment>
				<ProductsMsg version="1.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}">
					<xsl:apply-templates select="entry"/>
				</ProductsMsg>
			</source:fragment>
		</source:write>
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/processed/','xSPOT_Marketing_Catalog_010.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
			</source:source>
			<source:fragment>
				<ProductsMsg version="1.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}">
					<xsl:apply-templates select="entry"/>
				</ProductsMsg>
			</source:fragment>
		</source:write>    
	</xsl:template>
	<!-- -->
	<xsl:template match="entry[@valid='true']">
			<xsl:apply-templates select="content/catalog-objects/Product"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product[@catalog='true' and CTN and Catalog]">
		<Product>
			<xsl:copy-of select="CTN"/>
			<xsl:apply-templates select="Catalog"/>
		</Product>
	</xsl:template>	
	<!-- -->
	<xsl:template match="Catalog">
		<Catalog>
			<xsl:copy-of select="CatalogDestination"/>
			<xsl:copy-of select="CatalogType"/>
			<xsl:copy-of select="CatalogDomain"/>
			<xsl:copy-of select="CatalogCustomer"/>
			<xsl:copy-of select="CatalogChannel"/>
			<xsl:copy-of select="Publisher"/>
			<xsl:copy-of select="StartDate"/>
			<xsl:copy-of select="EndDate"/>
			<xsl:copy-of select="Rank"/>
			<xsl:copy-of select="ProductInCatalogState"/>
		</Catalog>
	</xsl:template>	
	<!-- -->
	<xsl:template match="entry[@valid='false']|Product"/><!-- erase everything else -->
</xsl:stylesheet>