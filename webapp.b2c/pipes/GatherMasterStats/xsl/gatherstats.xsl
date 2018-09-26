<?xml version="1.0"?>
<?altova_samplexml testData.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="translatedAttributesDoc">../../common/xml/translated_attributes.xml</xsl:param>
	<xsl:variable name="translatedAttributes" select="document($translatedAttributesDoc)//translatedAttribute"/>
	<xsl:strip-space elements="*"/>
	<!-- -->
	<xsl:template match="/Products">
		<Products>
			<xsl:apply-templates select="Product/sql:rowset"/>
		</Products>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<Product CTN="{../@ctn}" Locale="{../@locale}" Division="{../@division}" Brand="{../@brand}">
			<xsl:apply-templates select="sql:row/sql:data/Product"/>
			<SOP>
				<xsl:value-of select="../@sop"/>
			</SOP>
			<EOP>
				<xsl:value-of select="../@eop"/>
			</EOP>
		</Product>
	</xsl:template>
	<!-- -->
	<xsl:template match="Product">
		<HasWow>
			<xsl:value-of select="string-length(WOW) gt 5"/>
		</HasWow>
		<HasSubWow>
			<xsl:value-of select="string-length(SubWOW) gt 5"/>
		</HasSubWow>
		<HasProductName>
			<xsl:value-of select="string-length(ProductName) gt 5"/>
		</HasProductName>
		<HasNamingString>
			<xsl:value-of select="boolean(NamingString)"/>
		</HasNamingString>
		<HasConcept>
			<xsl:value-of select="boolean(NamingString/Concept)"/>
		</HasConcept>
		<HasDescriptor>
			<xsl:value-of select="boolean(NamingString/Descriptor)"/>
		</HasDescriptor>
		<CountKBA>
			<xsl:value-of select="count(KeyBenefitArea)"/>
		</CountKBA>
		<CountFeature>
			<xsl:value-of select="count(KeyBenefitArea/Feature)"/>
		</CountFeature>
		<CountChapter>
			<xsl:value-of select="count(CSChapter)"/>
		</CountChapter>
		<CountSpec>
			<xsl:value-of select="count(CSChapter/CSItem)"/>
		</CountSpec>
		<CountDisclaimer>
			<xsl:value-of select="count(Disclaimer)"/>
		</CountDisclaimer>
		<CountFeatureHighlight>
			<xsl:value-of select="count(FeatureHighlight)"/>
		</CountFeatureHighlight>
		<CountWords>
			<xsl:variable name="all">
				<xsl:apply-templates select="node()" mode="count"/>
			</xsl:variable>
			<xsl:value-of select="sum($all/el/@count)"/>
		</CountWords>
		<HasAward>
			<xsl:value-of select="boolean(Award)"/>
		</HasAward>
		<HasGTIN>
			<xsl:value-of select="boolean(GTIN)"/>
		</HasGTIN>
		<CRDate>
			<xsl:value-of select="CRDate"/>
		</CRDate>
		<Version>
			<xsl:value-of select="MarketingVersion"/>
		</Version>
	</xsl:template>
	<!-- -->
	<xsl:template match="node()" mode="count">
		<xsl:variable name="nodeName" select="local-name()"/>
		<!-- Check if current node is translated attribute by retrieving a translated attribute from the translated attributes list for which the name is equal to the current node name -->
		<!-- Only return the first match. VersionElementName is listed three times in the translated attribute list for instance. We only want one result -->
		<xsl:variable name="translatedAttribute" select="$translatedAttributes[@name eq $nodeName][position() = 1]"/>
		<xsl:choose>
			<!-- Check if current node is a translated attribute and if it's not empty. (Empty nodes are not translated) -->
			<xsl:when test="count($translatedAttribute) > 0 and string() != ''">
				<el>
					<xsl:attribute name="count"><xsl:value-of select="count(tokenize(string(.), '\s'))"/></xsl:attribute>
					<xsl:value-of select="string(.)"/>
				</el>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="node()" mode="count"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
