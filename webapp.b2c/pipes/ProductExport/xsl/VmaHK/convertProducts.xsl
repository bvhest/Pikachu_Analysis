<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="xsl cinclude source4:08 PM 2007-08-16">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="dir"/>
	<xsl:param name="exportdate">test</xsl:param>
	<xsl:param name="subcat">test</xsl:param>
	<xsl:param name="ctn">test</xsl:param>

	<!--  -->
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	<!--  -->
	<xsl:template match="/Products">
		<xsl:apply-templates select="sql:rowset/sql:row/sql:data/Product"/>
	</xsl:template>
	<!--  -->
	<xsl:template match="Product">
		<xsl:variable name="SubCategory" select="../../sql:rowset/sql:row/sql:subcategoryname"/>
		<Product>
			<xsl:apply-templates select="MarketingVersion"/>
			<xsl:apply-templates select="CTN"/>
			<SubCategory>
				<xsl:value-of select="$SubCategory"/>
			</SubCategory>
			<xsl:apply-templates select="CRDateYW"/>
			<xsl:apply-templates select="NamingString/Concept"/>
			<xsl:apply-templates select="NamingString/Descriptor"/>
			<xsl:apply-templates select="ProductName"/>
			<xsl:apply-templates select="WOW"/>
			<xsl:apply-templates select="SubWOW"/>
			<xsl:apply-templates select="MarketingTextHeader"/>
			<xsl:apply-templates select="SupraFeature"/>
			<xsl:apply-templates select="KeyBenefitArea"/>
			<xsl:apply-templates select="FeatureLogo"/>
			<xsl:apply-templates select="FeatureHighlight"/>
			<xsl:apply-templates select="AccessoryByPacked"/>
		</Product>
	</xsl:template>
	<!--  -->
	<xsl:template match="Concept">
		<Concept>
			<xsl:apply-templates select="@*|node()"/>
		</Concept>
		<ConceptLogoURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../ConceptCode"/>&amp;doctype=CLL&amp;alt=1</ConceptLogoURL>
	</xsl:template>
	<!--  -->
	<xsl:template match="AccessoryByPackedName">
		<AccessoryByPackedName>
			<xsl:apply-templates select="@*|node()"/>
		</AccessoryByPackedName>
		<AccessoryByPackedImageURL>http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="../AccessoryByPackedCode"/>&amp;doctype=ABW&amp;alt=1</AccessoryByPackedImageURL>
	</xsl:template>  
	<!--  -->
	<xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:sos|sql:eos|sql:priority|sql:content_type|sql:localisation"/>
	<!--  -->
	<xsl:template match="sql:groupcode|sql:groupname|sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>  
	<!--  -->  
	<!--  -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
