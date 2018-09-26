<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="dir"/>
	
	<!-- MDM key vlaue pairs-->	
	<!--Product>
		<CTN>100WT10P/27</CTN> 								OK
		<KeyValuePairs>
			<Code>F300007263</Code>							Feature/FeatureCode
			<Key>Instant power on</Key>							Feature/FeatureName
			<Value>Yes</Value>									??CSItem/CSValue??
			<Publisher>PikaChu</Publisher> 						OK (hardcoded?)
		</KeyValuePairs>
		</KeyValuePairs>
		</KeyValuePairs>
	</Product-->
	<!-- -->
	<xsl:template match="entries">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/',@ct,'/outbox/','xSPOT_Marketing_KeyValuePair_010.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')"/> 
			</source:source>
			<source:fragment>
				<ProductsMsg version="2.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}" docSource="ProCoon">
					<xsl:apply-templates select="entry"/>
				</ProductsMsg>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="entry[@valid='true']">
			<xsl:apply-templates select="content/Product[@keyvalue='true' and CTN]"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product[@keyvalue='true' and CTN and KeyValuePair/Values]">
		<Product>
			<xsl:copy-of select="CTN"/>
			<xsl:copy-of select="Publisher"/>
			<xsl:copy-of select="KeyValuePair[Code and Key]"/>
		</Product>
	</xsl:template>	
	<!-- -->
	<xsl:template match="entry|Product"/><!-- erase everything else -->
</xsl:stylesheet>