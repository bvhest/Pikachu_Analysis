<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:saxon="http://saxon.sf.net/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="xpaths-file"/>
	<xsl:variable name="xpaths">
		<simplexpath>ProductName</simplexpath>
		<simplexpath>DescriptorName</simplexpath>		
		<simplexpath>VersionString</simplexpath>		
		<simplexpath>BrandedFeatureString</simplexpath>
		<simplexpath>DescriptorBrandedFeatureString</simplexpath>
		<simplexpath>WOW</simplexpath>
		<simplexpath>SubWOW</simplexpath>
		<simplexpath>MarketingTextHeader</simplexpath>
		<!--complexxpath type="nonrepeating">
			<parent>MasterBrand</parent>
			<code>BrandCode</code>
			<xpath>BrandName</xpath>
		</complexxpath-->		
		<complexxpath type="nonrepeating">
			<parent>PartnerBrand</parent>
			<code>BrandCode</code>
			<xpath>BrandName</xpath>
		</complexxpath>		
		<complexxpath type="nonrepeating">
			<parent>ConsumerSegment</parent>
			<code>ConsumerSegmentCode</code>
			<xpath>ConsumerSegmentName</xpath>
		</complexxpath>
		<complexxpath type="nonrepeating">
			<parent>VersionElement1</parent>
			<code>VersionElementCode</code>
			<xpath>VersionElementName</xpath>
		</complexxpath>
		<complexxpath type="nonrepeating">
			<parent>VersionElement2</parent>
			<code>VersionElementCode</code>
			<xpath>VersionElementName</xpath>
		</complexxpath>
		<complexxpath type="nonrepeating">
			<parent>VersionElement3</parent>
			<code>VersionElementCode</code>
			<xpath>VersionElementName</xpath>
		</complexxpath>
    <complexxpath type="nonrepeating">
      <parent>VersionElement4</parent>
      <code>VersionElementCode</code>
      <xpath>VersionElementName</xpath>
    </complexxpath>
		<complexxpath type="repeating">
			<parent>Feature</parent>
			<code>FeatureCode</code>
			<xpath>FeatureName</xpath>
			<!--xpath>FeatureReferenceName</xpath--> <!-- Trigo has no FeatureReferenceName element/attribute -->
			<xpath>FeatureShortDescription</xpath>
			<xpath>FeatureLongDescription</xpath>
			<xpath>FeatureGlossary</xpath>
			<xpath>FeatureWhy</xpath>
			<xpath>FeatureWhat</xpath>
			<xpath>FeatureHow</xpath>
		</complexxpath>
		<complexxpath type="repeating">
			<parent>KeyBenefitArea</parent>
			<code>KeyBenefitAreaCode</code>
			<xpath>KeyBenefitAreaName</xpath>
		</complexxpath>		
		<!--complexxpath type="repeating"> Trigo has no FeatureReferenceName element/attribute on a FeatureLogo
			<parent>FeatureLogo</parent>
			<code>FeatureCode</code>
			<xpath>FeatureReferenceName</xpath>
		</complexxpath>		
		<complexxpath type="repeating">   Trigo has no FeatureReferenceName element/attribute on a FeatureHighlight
			<parent>FeatureHighlight</parent>
			<code>FeatureCode</code>
			<xpath>FeatureReferenceName</xpath>
		</complexxpath-->				
		<complexxpath type="repeating">
			<parent>CSChapter</parent>
			<code>CSChapterCode</code>
			<xpath>CSChapterName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>CSItem</parent>
			<code>CSItemCode</code>
			<xpath>CSItemName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>CSValue</parent>
			<code>CSValueCode</code>
			<xpath>CSValueName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>UnitOfMeasure</parent>
			<code>UnitOfMeasureCode</code>
			<xpath>UnitOfMeasureName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>NavigationGroup</parent>
			<code>NavigationGroupCode</code>
			<xpath>NavigationGroupName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>NavigationAttribute</parent>
			<code>NavigationAttributeCode</code>
			<xpath>NavigationAttributeName</xpath>
		</complexxpath>			
		<complexxpath type="repeating">
			<parent>NavigationValue</parent>
			<code>NavigationValueCode</code>
			<xpath>NavigationValueName</xpath>
		</complexxpath>			
	</xsl:variable>

	<!-- -->	
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>type="text/xsl" </xsl:text>
			<xsl:text>href="/pikachu/preview/XmlDiff.xsl"</xsl:text>
		</xsl:processing-instruction>
		<!-- -->	
		<root>
			<xsl:apply-templates select="//sql:rowset/sql:row/sql:id"/>
		</root>
	</xsl:template>
	<!-- -->	
	<xsl:template match="sql:id">
		<CTN><xsl:value-of select="."/></CTN>
	    <Locale>
    	  <xsl:value-of select="/Product/sql:rowset/sql:row/sql:lpdata/Product/@Locale"/>
	    </Locale>		
		<xsl:variable name="ctn" select="."/>
		<xsl:variable name="lpproduct" select="/Product/sql:rowset/sql:row[sql:id=$ctn]/sql:lpdata/Product"/>
		<xsl:variable name="tlpproduct" select="/Product/sql:rowset/sql:row[sql:id=$ctn]/sql:tlpdata/Product"/>
		<xsl:for-each select="$xpaths/simplexpath">
			<xsl:variable name="elementname"><xsl:value-of select="."/></xsl:variable>
			<xsl:variable name="PikaChuValue" select="$lpproduct//node()[string(node-name(.))=current()]"/>
			<xsl:variable name="TrigoValue" select="$tlpproduct//node()[string(node-name(.))=current()]"/>
			<xsl:choose>
				<xsl:when test="(count($PikaChuValue) gt 1) or (count($TrigoValue) gt 1)">
					<xxx><xsl:element name="{$elementname}"><xsl:copy-of select="$PikaChuValue"/></xsl:element></xxx>
                    <xxx><xsl:element name="{$elementname}"><xsl:copy-of select="$TrigoValue"/></xsl:element></xxx>
                </xsl:when>
                <xsl:otherwise>
					<xsl:if test="normalize-space($PikaChuValue) ne normalize-space($TrigoValue)">                    
						<xsl:element name="{$elementname}">                     
							<PikaChuValue><xsl:value-of select="normalize-space($lpproduct//node()[string(node-name(.))=current()])"/></PikaChuValue>                               
                            <TrigoValue><xsl:value-of select="normalize-space($tlpproduct//node()[string(node-name(.))=current()])"/></TrigoValue>                          
                        </xsl:element>
                    </xsl:if>                       
                </xsl:otherwise>
            </xsl:choose>
		</xsl:for-each>
		<!-- -->
		<xsl:for-each select="$xpaths/complexxpath[@type='nonrepeating']">
			<xsl:variable name="elementname"><xsl:value-of select="./parent"/></xsl:variable>
			<xsl:variable name="lpparent"   select="$lpproduct//node()[string(node-name(.))=current()/parent]"/>
			<xsl:variable name="tlpparent" select="$tlpproduct//node()[string(node-name(.))=current()/parent]"/>
			<xsl:variable name="lpcode"     select="$lpparent/node()[string(node-name(.))=current()/code]"/>
			<xsl:variable name="tlpcode"   select="$lpparent/node()[string(node-name(.))=current()/code]"/>
			<xsl:if test="$lpcode eq $tlpcode">					
				<xsl:variable name="PikaChuValue"     select="$lpparent//node()[string(node-name(.))=current()/xpath]"/>
				<xsl:variable name="TrigoValue"   select="$tlpparent//node()[string(node-name(.))=current()/xpath]"/>
				<xsl:if test="normalize-space($PikaChuValue) ne normalize-space($TrigoValue)">
					<xsl:element name="{$elementname}">
						<xsl:variable name="elementcodename" select="current()/code"/>						
						<xsl:element name="{$elementcodename}"><xsl:value-of select="$lpcode"/></xsl:element>
						<PikaChuValue><xsl:value-of select="normalize-space($PikaChuValue)"/></PikaChuValue>						
						<TrigoValue><xsl:value-of select="normalize-space($TrigoValue)"/></TrigoValue>												
					</xsl:element>											
				</xsl:if>					
			</xsl:if>
		</xsl:for-each>
		<!-- -->		
		<xsl:for-each select="$xpaths/complexxpath[@type='repeating']">
			<xsl:variable name="elementname"><xsl:value-of select="./parent"/></xsl:variable>
			<xsl:variable name="lpparents"   select="$lpproduct//node()[string(node-name(.))=current()/parent]"/>
			<xsl:variable name="tlpparents" select="$tlpproduct//node()[string(node-name(.))=current()/parent]"/>
			<xsl:variable name="xpath2code" select="code"/>
			<xsl:variable name="xpath2value" select="xpath"/>
			<xsl:for-each-group select="$lpparents" group-by="node()[string(node-name(.))=$xpath2code]"> 
				<xsl:for-each select="current-group()">
					<xsl:sort select="node()[string(node-name(.))=$xpath2code]"/>
					<xsl:if test="position() = 1">				
						<xsl:variable name="lpnode" select="."/>
						<xsl:variable name="lpcode" select="./node()[string(node-name(.))=$xpath2code]"/>
						<xsl:variable name="tlpnode" select="saxon:evaluate(concat('$p1[',$xpath2code,'=$p2][position()=1]'),$tlpparents,$lpcode)"/>
						<xsl:variable name="tlpcode" select="$tlpnode/$lpcode"/>
						<xsl:if test="$lpcode eq $tlpcode">
							<xsl:for-each select="$xpaths/complexxpath[@type='repeating'][parent=$elementname]/xpath">
								<xsl:variable name="PikaChuValue"     select="$lpnode/node()[string(node-name(.))=current()]"/>
								<xsl:variable name="TrigoValue"    select="$tlpnode/node()[string(node-name(.))=current()]"/>
								<xsl:if test="normalize-space($PikaChuValue) ne normalize-space($TrigoValue)">
									<xsl:element name="{current()}">
										<xsl:variable name="elementcodename" select="current()/code"/>						
										<xsl:element name="{$xpath2code}"><xsl:value-of select="$lpcode"/></xsl:element>
										<PikaChuValue><xsl:value-of select="normalize-space($PikaChuValue)"/></PikaChuValue>						
										<TrigoValue><xsl:value-of select="normalize-space($TrigoValue)"/></TrigoValue>												
									</xsl:element>																						
								</xsl:if>					
							</xsl:for-each>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>		
			</xsl:for-each-group> 			
		</xsl:for-each>		
	</xsl:template>
</xsl:stylesheet>
	