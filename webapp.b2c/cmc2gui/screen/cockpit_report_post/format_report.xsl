<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="fn saxon sql">
 >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:import href="xpaths.xsl"/>
	<xsl:template match="sql:sop|sql:eop|sql:mv_localized|sql:status_localized|sql:mv_translated|sql:status_translated|sql:status_pmt|sql:mv_enriched|sql:mv_pmt"/>
	<xsl:template match="/root">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	<xsl:template match="sql:rowset">
		<ROWSET>
			<!--xsl:apply-templates select="@*|node()"/-->
      <xsl:for-each-group select="sql:row" group-by="concat(sql:country,',',sql:customer_id)">
        <xsl:apply-templates select="current-group()"/>
      </xsl:for-each-group>
		</ROWSET>
	</xsl:template>
	<xsl:template match="sql:row">
		<ROW>
			<xsl:apply-templates select="@*|node()"/>
		</ROW>
	</xsl:template>

  
	<xsl:template match="sql:object_id">
		<Commercial-ID>
			<xsl:apply-templates select="@*|node()"/>
		</Commercial-ID>
	</xsl:template>
	<xsl:template match="sql:localisation">
		<Locale>
			<xsl:apply-templates select="@*|node()"/>
		</Locale>
	</xsl:template>
 	<xsl:template match="sql:status_enriched">
		<Mrkt-Rel.>
				<xsl:value-of select="if (. = 'Final Published') then 'Y' else 'N' "/>
		</Mrkt-Rel.>
	</xsl:template>
	<xsl:template match="sql:activity">
		<Active-Inactive>
			<xsl:apply-templates select="@*|node()"/>
		</Active-Inactive>
	</xsl:template>	
	<xsl:template match="sql:translation_status">
		<Localized-content>
			<xsl:apply-templates select="@*|node()"/>
		</Localized-content>
	</xsl:template>
	<xsl:template match="sql:status_fk">
		<Filterkeys>
			<xsl:apply-templates select="@*|node()"/>
		</Filterkeys>
	</xsl:template>
	<xsl:template match="sql:data">
		<Range>
			<xsl:value-of select="if (Product/NamingString/Range/RangeCode != '') then concat(Product/NamingString/Range/RangeCode,' ',Product/NamingString/Range/RangeName) else 'no range' "/>
		</Range>
		<xsl:variable name="prd" select="."/>
		<ProductEnhancementContent>
			<xsl:for-each select="$ProductEnhancementContent/*/Attribute">
				<xsl:variable name="xpath" select="."/>
				<xsl:variable name="ElementName" select="@name"/>
				<xsl:for-each select="$prd">
					<xsl:element name="{$ElementName}">
						<xsl:value-of select="count(saxon:evaluate($xpath))"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
		</ProductEnhancementContent>
		<xsl:for-each select="$Other/Attribute">
			<xsl:variable name="xpath" select="."/>
			<xsl:variable name="ElementName" select="@name"/>
			<xsl:for-each select="$prd">
				<xsl:element name="{$ElementName}">
					<xsl:value-of select="count(saxon:evaluate($xpath))"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:for-each>
		<!-- xsl:apply-templates select="node()"/-->
	</xsl:template>
</xsl:stylesheet>
