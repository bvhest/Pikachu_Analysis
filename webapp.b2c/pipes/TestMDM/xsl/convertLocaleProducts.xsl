<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testLocaleProduct.xml?>
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
			<xsl:apply-templates/>
		</ProductsMsg>
	</xsl:template>
	<!--  -->
	<xsl:template match="Product" exclude-result-prefixes="cinclude sql">
		<xsl:variable name="a">
			<xsl:call-template name="Assets">
				<xsl:with-param name="ctn" select="CTN"/>
				<xsl:with-param name="language" select="../../sql:language"/>
				<xsl:with-param name="locale" select="@Locale"/>
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
			</xsl:call-template>
			<xsl:apply-templates select="SystemLogo">
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
				<xsl:sort data-type="number" select="SystemLogoRank"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="PartnerLogo">
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
				<xsl:sort data-type="number" select="PartnerLogoRank"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FeatureLogo">
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
				<xsl:sort data-type="number" select="FeatureLogoRank"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FeatureImage">
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
				<xsl:sort data-type="number" select="FeatureImageRank"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="Award">
				<xsl:with-param name="owner" select="ProductOwner"/>
				<xsl:with-param name="status" select="MarketingStatus"/>
				<xsl:with-param name="lastModified" select="@lastModified"/>
				<xsl:sort data-type="number" select="AwardRank"/>
			</xsl:apply-templates>
		</xsl:variable>
		<Products>
			<CTN>
				<xsl:value-of select="CTN"/>
			</CTN>
			<Code12NC>
				<xsl:choose>
					<xsl:when test="Code12NC">
						<xsl:value-of select="Code12NC"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(concat('781',replace(CTN,'[A-Z,a-z,/]',''),'000000'),1,12)"/>
					</xsl:otherwise>
				</xsl:choose>
			</Code12NC>
			<GTIN>
				<xsl:value-of select="GTIN"/>
			</GTIN>
			<xsl:for-each select="$a/Asset">
				<Assets>
					<Creator>
						<xsl:value-of select="@owner"/>
					</Creator>
					<Modified>
						<xsl:value-of select="@lastModified"/>
					</Modified>
					<Description>
						<xsl:value-of select="@description"/>
					</Description>
					<License>
						<xsl:value-of select="@status"/>
					</License>
					<Language>
						<xsl:value-of select="@language"/>
					</Language>
					<Type>
						<xsl:value-of select="@type"/>
					</Type>
					<Title>
						<xsl:value-of select="@key"/>
					</Title>
					<ResourceIdentifier>
						<xsl:value-of select="node()"/>
					</ResourceIdentifier>
				</Assets>
			</xsl:for-each>
		</Products>
	</xsl:template>
	<!--  -->
	<xsl:template name="Assets">
		<xsl:param name="ctn"/>
		<xsl:param name="language"/>
		<xsl:param name="locale"/>
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Marketing Released" ctn="{$ctn}" language="" key="{$ctn}-FTL" type="FTL" description="Product picture front-top 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FTP&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-BPP" type="BPP" description="BPP">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=BPP&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="{$language}" key="{$ctn}-DFU-{$language}" type="DFU" description="UserManual">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=DFU&amp;laco=<xsl:value-of select="$language"/>
		</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="{$language}" key="{$ctn}-PSS-{$language}" type="PSS" description="Product Specification Sheet (Leaflet)">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=PSS&amp;laco=<xsl:value-of select="$language"/>
		</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="{$language}" key="{$ctn}-FAQ-{$language}" type="FAQ" description="Frequently asked questions">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=FAQ&amp;laco=<xsl:value-of select="$language"/>
		</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="{$language}" key="{$ctn}-TIP-{$language}" type="TIP" description="Tips to users">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TIP&amp;laco=<xsl:value-of select="$language"/>
		</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-RTP" type="RTP" description="Product picture front-top-left with reflection 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTP&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-RTF" type="RTF" description="Product picture front-top-left with reflection 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RTF&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-TRP" type="TRP" description="Product picture front-top-right 2196x1795">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRP&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-TRF" type="TRF" description="Product picture front-top-right 396x396">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=TRF&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-RCW" type="RCW" description="Remote control image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=RCW&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="Michiel Klaren" status="Final Published" ctn="{$ctn}" language="" key="{$ctn}-COW" type="COW" description="Connector side image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=COW&amp;alt=1</Asset>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="Final Published" ctn="{$ctn}" language="{$locale}" key="{$ctn}-PMT" type="PMT" description="Product Marketing">http://nlvu045:8888/pipes/LocaleProduct/get?ctnList=<xsl:value-of select="$ctn"/>&amp;locale=Master</Asset>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="Final Published" ctn="{$ctn}" language="{$locale}" key="{$ctn}-PMT-Translated" type="PMT-Translated" description="Product Marketing Translated">http://nlvu045:8888/pipes/LocaleProduct/get?ctnList=<xsl:value-of select="$ctn"/>&amp;locale=<xsl:value-of select="$locale"/></Asset>
		<!--Asset type="EEF" description="Electronics Explained Flash">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="$ctn"/>&amp;doctype=EEF&amp;laco=<xsl:value-of select="$language"/></Asset-->
	</xsl:template>
	<!--  -->
	<xsl:template match="Concept">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{ConceptCode}" type="CLL" description="Concept Logo">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="ConceptCode"/>&amp;doctype=CLL&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="SystemLogo">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{SystemLogoCode}" type="SLW" description="System Logo">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="SystemLogoCode"/>&amp;doctype=SLW&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="PartnerLogo">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{PartnerLogoCode}" type="PLW" description="Partner Logo">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="PartnerLogoCode"/>&amp;doctype=PLW&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="FeatureLogo">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{FeatureCode}" type="FLW" description="Feature Logo">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="FeatureCode"/>&amp;doctype=FLW&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="FeatureImage">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{FeatureCode}" type="FIP" description="Feature Image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="FeatureCode"/>&amp;doctype=FIP&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="AccessoryByPacked">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{AccessoryByPackedCode}" type="ABW" description="Accessory By Packed Image">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="AccessoryByPackedCode"/>&amp;doctype=ABW&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="Award">
		<xsl:param name="owner"/>
		<xsl:param name="status"/>
		<xsl:param name="lastModified"/>
		<Asset lastModified="{$lastModified}" owner="{$owner}" status="{$status}" ctn="{../CTN}" language="N/A" key="{AwardCode}" type="GAW" description="AwardLogoURL">http://www.p4c.philips.com/cgi-bin/dcbint/get?id=<xsl:value-of select="AwardCode"/>&amp;doctype=GAW&amp;alt=1</Asset>
	</xsl:template>
	<!--  -->
	<xsl:template match="@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
