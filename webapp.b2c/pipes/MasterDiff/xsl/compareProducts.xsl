<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:saxon="http://saxon.sf.net/" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="xpaths-file"/>
  <xsl:variable name="termbase_file" select="document('../../common/xml/termbase.xml')"/>
  <!-- -->
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
      <!--xpath>FeatureReferenceName</xpath-->
      <!-- Trigo has no FeatureReferenceName element/attribute -->
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
      <xsl:text>href="/pikachu/preview/MasterDiff.xsl"</xsl:text>
    </xsl:processing-instruction>
    <!-- -->
    <root>
      <xsl:apply-templates select="//sql:rowset/sql:row/sql:id"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:id">
    <CTN>
      <xsl:value-of select="."/>
    </CTN>
    <Locale>
      <xsl:value-of select="/Product/sql:rowset/sql:row/sql:lpdata/Product/@Locale"/>
    </Locale>
    <xsl:variable name="ctn" select="."/>
    <xsl:variable name="lpproduct" select="/Product/sql:rowset/sql:row[sql:id=$ctn]/sql:lpdata/Product"/>
    <xsl:variable name="tlpproduct" select="/Product/sql:rowset/sql:row[sql:id=$ctn]/sql:tlpdata/Product"/>
    <xsl:for-each select="$xpaths/simplexpath">
      <xsl:variable name="elementname">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:variable name="LocaleValue" select="$lpproduct//node()[string(node-name(.))=current()]"/>
      <xsl:variable name="MasterValue" select="$tlpproduct//node()[string(node-name(.))=current()]"/>
      <xsl:choose>
        <xsl:when test="(count($LocaleValue) gt 1) or (count($MasterValue) gt 1)">
          <xxx>
            <xsl:element name="{$elementname}">
              <xsl:copy-of select="$LocaleValue"/>
            </xsl:element>
          </xxx>
          <xxx>
            <xsl:element name="{$elementname}">
              <xsl:copy-of select="$MasterValue"/>
            </xsl:element>
          </xxx>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="me:compString($LocaleValue, $MasterValue)">
            <xsl:element name="{$elementname}">
              <LocaleValue>
                <xsl:value-of select="normalize-space($lpproduct//node()[string(node-name(.))=current()])"/>
              </LocaleValue>
              <MasterValue>
                <xsl:value-of select="normalize-space($tlpproduct//node()[string(node-name(.))=current()])"/>
              </MasterValue>
            </xsl:element>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="$xpaths/complexxpath[@type='nonrepeating']">
      <xsl:variable name="elementname">
        <xsl:value-of select="./parent"/>
      </xsl:variable>
      <xsl:variable name="lpparent" select="$lpproduct//node()[string(node-name(.))=current()/parent]"/>
      <xsl:variable name="tlpparent" select="$tlpproduct//node()[string(node-name(.))=current()/parent]"/>
      <xsl:variable name="lpcode" select="$lpparent/node()[string(node-name(.))=current()/code]"/>
      <xsl:variable name="tlpcode" select="$lpparent/node()[string(node-name(.))=current()/code]"/>
      <xsl:if test="$lpcode eq $tlpcode">
        <xsl:variable name="LocaleValue" select="$lpparent//node()[string(node-name(.))=current()/xpath]"/>
        <xsl:variable name="MasterValue" select="$tlpparent//node()[string(node-name(.))=current()/xpath]"/>
        <xsl:if test="me:compString($LocaleValue, $MasterValue)">
          <xsl:element name="{$elementname}">
            <xsl:variable name="elementcodename" select="current()/code"/>
            <xsl:element name="{$elementcodename}">
              <xsl:value-of select="$lpcode"/>
            </xsl:element>
            <LocaleValue>
              <xsl:value-of select="normalize-space($LocaleValue)"/>
            </LocaleValue>
            <MasterValue>
              <xsl:value-of select="normalize-space($MasterValue)"/>
            </MasterValue>
          </xsl:element>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="$xpaths/complexxpath[@type='repeating']">
      <xsl:variable name="elementname">
        <xsl:value-of select="./parent"/>
      </xsl:variable>
      <xsl:variable name="lpparents" select="$lpproduct//node()[string(node-name(.))=current()/parent]"/>
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
                <xsl:variable name="LocaleValue" select="$lpnode/node()[string(node-name(.))=current()]"/>
                <xsl:variable name="MasterValue" select="$tlpnode/node()[string(node-name(.))=current()]"/>
                <xsl:if test="me:compString($LocaleValue, $MasterValue)">
                  <xsl:element name="{current()}">
                    <xsl:variable name="elementcodename" select="current()/code"/>
                    <xsl:element name="{$xpath2code}">
                      <xsl:value-of select="$lpcode"/>
                    </xsl:element>
                    <LocaleValue>
                      <xsl:value-of select="normalize-space($LocaleValue)"/>
                    </LocaleValue>
                    <MasterValue>
                      <xsl:value-of select="normalize-space($MasterValue)"/>
                    </MasterValue>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:function name="me:compString" as="xs:boolean">
    <xsl:param name="LocaleValue" as="xs:string"/>
    <xsl:param name="MasterValue" as="xs:string"/>
    <xsl:variable name="L" select="normalize-space($LocaleValue)" as="xs:string"/>
    <xsl:variable name="M" select="normalize-space($MasterValue)" as="xs:string"/>
    <xsl:variable name="LL" select="string-length($LocaleValue)" as="xs:int"/>
    <xsl:variable name="LM" select="string-length($MasterValue)" as="xs:int"/>
    <xsl:choose>
      <xsl:when test="$L = $M">
        <xsl:copy-of select="false()"/>
      </xsl:when>
      <!-- Check if the string length does not differ too much-->
      <xsl:when test="$LL div 10 gt $LM">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <!-- Check if the string length does not differ too much-->
      <xsl:when test="$LM div 10 gt $LL">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <!-- Check if the string length does not differ too much-->
      <xsl:when test="($LM = 0) and ($LL ne 0)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <!-- Check if the string length does not differ too much-->
      <xsl:when test="($LL = 0) and ($LM ne 0)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <!-- Check for correct use of terms -->
      <xsl:when test="me:checkTermString(lower-case($L), lower-case($M))">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <!-- Check numbers -->
      <xsl:when test="me:checkNumbers($L, $M)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:checkNumbers" as="xs:boolean">
    <xsl:param name="L" as="xs:string"/>
    <xsl:param name="M" as="xs:string"/>
    <!-- Check for codes like 2 87 12581 32800 3 -->
    <xsl:variable name="NM1" as="xs:string" select="replace($M, '(\d)\s(\d)','$1$2')"/>
    <!-- Check for items like '.2' and change into '0.2' -->
    <xsl:variable name="NM2" as="xs:string" select="replace($NM1, '(^|[^0-9])[.,]([0-9])','0.$2')"/>
    <!-- Remove all '.' and ','-->
    <xsl:variable name="NM" as="xs:string" select="replace($NM2,'[.,]','')"/>
    <!-- Check for codes like 2 87 12581 32800 3 -->
    <xsl:variable name="NL1" as="xs:string" select="replace($L, '(\d)\s(\d)','$1$2')"/>
    <!-- Check for no-break space characters in the locale content -->
    <xsl:variable name="NL2" as="xs:string" select="replace($NL1,'(\d)&#160;(\d)','$1$2')"/>
    <!-- Check for items like '.2' and change into '0.2' -->
    <xsl:variable name="NL3" as="xs:string" select="replace($NL2, '(^|[^0-9])[.,]([0-9])','0.$2')"/>
    <!-- Remove all '.' and ','-->
    <xsl:variable name="NL" as="xs:string" select="replace($NL3,'[.,]','')"/>
    <xsl:variable name="eval">
      <xsl:analyze-string select="$NM" regex="[0-9]{2,}|^[0-9]$">
        <xsl:matching-substring>
          <xsl:choose>
            <xsl:when test="contains($NL, .)">
              <xsl:text>false </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>true </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring/>
      </xsl:analyze-string>
      <xsl:analyze-string select="$NL" regex="[0-9]{2,}|^[0-9]$">
        <xsl:matching-substring>
          <xsl:choose>
            <xsl:when test="contains($NM, .)">
              <xsl:text>false </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>true </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring/>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($eval, 'true')">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:checkTermString" as="xs:boolean">
    <xsl:param name="L" as="xs:string"/>
    <xsl:param name="M" as="xs:string"/>
    <xsl:variable name="eval" as="xs:string">
      <xsl:value-of select="me:stringTermString($L, $M)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($eval) = 0">
        <xsl:copy-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:stringTermString" as="xs:string">
    <xsl:param name="L" as="xs:string"/>
    <xsl:param name="M" as="xs:string"/>
    <xsl:variable name="terms" select="$termbase_file/termbase"/>
    <xsl:variable name="eval2">
      <xsl:for-each select="$terms/term">
        <xsl:value-of select="me:stringTermDef($L, $M, .)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$eval2"/>
  </xsl:function>
  <!-- -->
  <xsl:function name="me:stringTermDef" as="xs:string">
    <xsl:param name="L" as="xs:string"/>
    <xsl:param name="M" as="xs:string"/>
    <xsl:param name="term" as="element()*"/>
    <xsl:variable name="eval3">
      <xsl:choose>
        <xsl:when test="matches($M, concat('(^|[^a-zA-Z0-9])',$term/def,'($|[^a-zA-Z0-9])'))">
          <xsl:if test="matches($L, concat('(^|[^a-zA-Z0-9])',$term/def,'($|[^a-zA-Z0-9])'))">
            <xsl:text>x</xsl:text>
          </xsl:if>
          <xsl:for-each select="$term/alt">
            <xsl:if test="matches($L, concat('(^|[^a-zA-Z0-9])',.,'($|[^a-zA-Z0-9])'))">
              <xsl:text>y</xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>z</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="string-length($eval3) = 0">
      <xsl:text>F</xsl:text>
    </xsl:if>
  </xsl:function>
</xsl:stylesheet>
