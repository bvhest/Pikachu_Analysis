<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" exclude-result-prefixes="xsl cinclude source"  extension-element-prefixes="cmc2-f">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:include href="../../../../cmc2/xsl/common/cmc2.function.xsl"/>
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
		<!-- <xsl:variable name="SubCategory" select="../../sql:rowset/sql:row/sql:subcategoryname"/> -->
		<Product>
				<xsl:apply-templates select="CTN"/>
				<xsl:apply-templates select="ProductName"/>
        <FullProductName><xsl:value-of select="cmc2-f:formatFullProductName(NamingString)"/></FullProductName>      
		</Product>
	</xsl:template>
	<!--  -->
	<xsl:template name="FullProductName">
		<xsl:variable name="TempFullNaming">
			<xsl:choose>
				<xsl:when test="string-length(NamingString/BrandString) &gt; 0">
					<xsl:value-of select="NamingString/BrandString"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="if(NamingString/Family/FamilyName != '') then NamingString/Family/FamilyName else NamingString/Concept/ConceptName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/Partner/PartnerProductName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/Alphanumeric"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/VersionString"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/BrandedFeatureString"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/BrandString2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NamingString/MasterBrand/BrandName"/>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="string-length(NamingString/Concept/ConceptName) &gt; 0 and NamingString/Concept/ConceptName != 'NULL'">
							<xsl:value-of select="NamingString/Concept/ConceptName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="NamingString/SubBrand/BrandName"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/Descriptor/DescriptorName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/Alphanumeric"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/VersionString"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="NamingString/BrandedFeatureString"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<FullProductName>
			<xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
		</FullProductName>
	</xsl:template>
	<!--  -->
	<xsl:template match="sql:id|sql:language|sql:sop|sql:eop|sql:sos|sql:eos|sql:priority|sql:content_type|sql:localisation"/>
	<!--  -->
	<xsl:template match="sql:groupcode|sql:groupname|sql:categorycode|sql:categoryname|sql:subcategorycode|sql:subcategoryname"/>  
	<!--  -->    
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
