<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">

  <!-- Note: as of writing (25 Apr 2008) a product is stated as belonging to a maximum of one range, so we take the first range secondary only -->
  
  <xsl:variable name="CTN" select="entry/@o"/>
  <xsl:variable name="RangeText" select="entry/content/secondary/octl/sql:rowset/sql:row[sql:content_type='RangeText_Raw']/sql:data/Node[@nodeType='range']"/>
  <xsl:variable name="escapedCTN" select="replace(entry/@o,'/','_')"/>
  <xsl:variable name="Features">
    <xsl:copy-of select="entry/content/Product/FeatureLogo/FeatureCode"/>
    <xsl:copy-of select="entry/content/Product/FeatureImage/FeatureCode"/>
    <xsl:for-each select="entry/content/Product/FeatureImage[contains(FeatureCode,$escapedCTN)]">
      <FeatureCode><xsl:value-of select="substring-before(FeatureCode,concat('_',$escapedCTN))"/></FeatureCode>
    </xsl:for-each>
    <xsl:copy-of select="entry/content/Product/FeatureHighlight/FeatureCode"/>
    <xsl:copy-of select="entry/content/Product/KeyBenefitArea/Feature/FeatureCode"/>
  </xsl:variable>
  <xsl:variable name="FeatureMap">
    <Features>
      <xsl:for-each select="entry/content/Product/FeatureImage[contains(FeatureCode,$escapedCTN)]">
        <Feature>
          <original><FeatureCode><xsl:value-of select="FeatureCode"/></FeatureCode></original>
          <mappedto><FeatureCode><xsl:value-of select="substring-before(FeatureCode,concat('_',$escapedCTN))"/></FeatureCode></mappedto>
        </Feature>
      </xsl:for-each>
    </Features>
  </xsl:variable>
  <xsl:variable name="CSItems">
    <xsl:copy-of select="entry/content/Product/CSChapter/CSItem/CSItemCode"/>  
  </xsl:variable>
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!-- copied explicitly to maintain order -->
  <xsl:template match="AccessoryByPacked|Award|ProductClusters|ProductRefs"/>

  <xsl:template match="Disclaimers">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    <!-- put KVPs after Disclaimers -->
    <KeyValuePairs>
      <xsl:copy-of copy-namespaces="no" select="../../secondary[octl/sql:rowset/sql:row/sql:content_type='KeyValuePairs']/octl/sql:rowset/sql:row/sql:data/KeyValuePairs/KeyValuePair"/>
    </KeyValuePairs>
    <!-- force order of elements -->
    <xsl:apply-templates select="../AccessoryByPacked" mode="copy"/>
    <xsl:apply-templates select="../Award" mode="copy"/>
    <xsl:apply-templates select="../ProductClusters" mode="copy"/>
    <xsl:apply-templates select="../ProductRefs" mode="copy"/>
  </xsl:template>  
  
  <xsl:template match="NamingString">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="MasterBrand"/>
      <xsl:apply-templates select="Partner"/>
      <xsl:apply-templates select="BrandString"/>
      <xsl:apply-templates select="BrandString2"/>
      <xsl:apply-templates select="Concept"/>
      <xsl:apply-templates select="Family"/>
      <xsl:call-template name="RangeText"/>
      <xsl:apply-templates select="Descriptor"/>
      <xsl:apply-templates select="Alphanumeric"/>
      <xsl:apply-templates select="VersionElement1"/>
      <xsl:apply-templates select="VersionElement2"/>
      <xsl:apply-templates select="VersionElement3"/>
      <xsl:apply-templates select="VersionElement4"/>
      <xsl:apply-templates select="VersionString"/>
      <xsl:apply-templates select="BrandedFeatureCode1"/>
      <xsl:apply-templates select="BrandedFeatureCode2"/>
      <xsl:apply-templates select="BrandedFeatureString"/>
      <xsl:apply-templates select="DescriptorBrandedFeatureString"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template name="RangeText">
    <xsl:choose>
      <xsl:when test="not(empty($RangeText))">
        <Range>
          <RangeCode><xsl:value-of select="$RangeText[1]/@code"/></RangeCode>
          <RangeName><xsl:value-of select="$RangeText[1]/Name"/></RangeName>
        </Range>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Filters">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="Purpose[not(@type='Discriminators')]"/>
      <xsl:call-template name="Discriminators"/>
    </xsl:copy>
  </xsl:template>  

  <xsl:template name="Discriminators">
    <xsl:choose>
      <xsl:when test="not(empty($RangeText))">
        <Purpose type="Discriminators">
          <Features>
            <xsl:for-each select="$RangeText/Filters/Purpose[@type='Differentiating']/Features/Feature[@code=$Features/FeatureCode]">
              <Feature>
                <xsl:attribute name="code" select="if(@code = $FeatureMap/Features/Feature/mappedto/FeatureCode) then $FeatureMap/Features/Feature[mappedto/FeatureCode = current()/@code]/original/FeatureCode else @code" />
                <xsl:attribute name="rank" select="@rank"/>
              </Feature>
            </xsl:for-each>
          </Features>          
          <CSItems>
            <xsl:for-each select="$RangeText/Filters/Purpose[@type='Differentiating']/CSItems/CSItem[@code=$CSItems/CSItemCode]">
              <CSItem>
                <xsl:attribute name="code" select="@code"/>
                <!-- The rank-attribute is optional, but when present it must contain a value. 
                   | As PFS does not provide this attribute, test and only create it when it has a value.
                   |-->
                <xsl:if test="@rank != ''" >
                   <xsl:attribute name="rank" select="@rank"/>
                </xsl:if>
              </CSItem>
            </xsl:for-each>
          </CSItems>              
        </Purpose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="Purpose[@type='Discriminators']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="content/secondary"/>
  
  <xsl:template match="ObjectAssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Object">
       <xsl:sort select="id"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="secondary">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
	  <!-- add back rangeText secondaries -->
      <xsl:for-each select="$RangeText[1]">
        <xsl:element name="relation">'PMT_Master','master_global','<xsl:value-of select="$CTN" />','RangeText_Raw','none','<xsl:value-of select="@code" />',1,1</xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList/Object/Asset[ResourceType='BLR']"/>
  
</xsl:stylesheet>