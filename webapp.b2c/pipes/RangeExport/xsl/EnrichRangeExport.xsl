<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql xsl">
    
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="masterlocale"/>
  <xsl:param name="master"/>
  <xsl:param name="doctypesfilepath"/>
  
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>
  <xsl:variable name="type" select="if($masterlocale = 'yes') then 'masterlocale' else if($locale = 'MASTER') then 'master' else 'locale'"/>
  <xsl:variable name="debug" select="false()"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetList">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:for-each select="../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product[exists(AssetList/Asset)]">
        <Object>
          <id>
            <xsl:value-of select="CTN"/>
          </id>
          <xsl:apply-templates select="AssetList/Asset"/>
        </Object>
      </xsl:for-each> 
      <xsl:for-each-group select="../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product/ObjectAssetList/Object" group-by="id">
        <xsl:for-each select="current-group()">
          <xsl:sort select="../../@masterLastModified" order="descending"/>
          <xsl:if test="position()=1">
            <xsl:choose>
              <xsl:apply-templates select="."/>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <!-- Remove non-master assets if we are exporting master content -->
  <xsl:template match="Asset[($type = 'masterlocale' or $type = 'master') and not(Language=('','global','en_US'))]"/>
  
  <xsl:template match="MarketingTextHeader">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <!-- Stick the KBAs and Chapters here -->

    <!-- First, the KBAs ... -->

    <!-- Get the kbas that contain a feature and put them in a variable ... -->
    <xsl:variable name="kbas">
      <!-- For each Feature referenced in this Range -->
      <xsl:for-each select="../Filters/Purpose/Features/Feature">
        <Feature code="{@code}">
          <!-- Retrieve from the referenced product content all KeyBenefitAreas that reference the Feature -->
          <xsl:apply-templates select="../../../../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product/KeyBenefitArea[exists(Feature[contains(FeatureCode,current()/@code)])]" mode="getkbas">
            <xsl:with-param name="featurecode" select="@code"/>
          </xsl:apply-templates>
        </Feature>
      </xsl:for-each>
    </xsl:variable>

    <!-- Sort those KBAs that contain a Range feature and put the newest of each into a variable -->
    <xsl:variable name="selected-kbas">
      <xsl:for-each select="$kbas/Feature[KeyBenefitArea]">
        <xsl:for-each select="KeyBenefitArea">
          <xsl:sort select="@masterLastModified"/>
          <xsl:if test="position() = 1">
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <!-- Deduplicate the KBAs (if a kba exists more than once, group the features into one version of it) -->
    <xsl:for-each-group select="$selected-kbas/KeyBenefitArea" group-by="KeyBenefitAreaCode">
      <xsl:sort select="current-grouping-key()" order="ascending"/>
      <xsl:variable name="kba-features" select="current-group()//Feature"/>
      <xsl:copy>
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1">
            <xsl:apply-templates select="KeyBenefitArea|KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank"/>
            <xsl:copy-of select="$kba-features"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:copy>
    </xsl:for-each-group>


    <!-- Second, the Chapters ... -->

    <!-- Get the CSChapters that contain a CSItem and put them in a variable ... -->
    <xsl:variable name="cschapters">
      <!-- For each Feature referenced in this Range -->
      <xsl:for-each select="../Filters/Purpose/CSItems/CSItem">
        <CSItem code="{@code}">
          <!-- Retrieve from the referenced product content all CSChapters that reference the CSItem -->
          <xsl:apply-templates select="../../../../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product/CSChapter[exists(CSItem[contains(CSItemCode,current()/@code)])]" mode="getcschapters">
            <xsl:with-param name="csitemcode" select="@code"/>
          </xsl:apply-templates>
        </CSItem>
      </xsl:for-each>
    </xsl:variable>

    <!-- Sort those CSChapters that contain a Range CSItem and put the newest of each into a variable -->
    <xsl:variable name="selected-cschapters">
      <xsl:for-each select="$cschapters/CSItem[CSChapter]">
        <xsl:for-each select="CSChapter">
          <xsl:sort select="@masterLastModified"/>
          <xsl:if test="position() = 1">
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <!-- Deduplicate the CSChapters (if a CSC exists more than once, group the CSItems into one version of it) -->
    <xsl:for-each-group select="$selected-cschapters/CSChapter" group-by="CSChapterCode">
      <xsl:sort select="current-grouping-key()" order="ascending"/>
      <xsl:variable name="cschapter-csitems" select="current-group()//CSItem"/>
      <xsl:copy>
        <xsl:for-each select="current-group()">
          <xsl:if test="position() = 1">
            <xsl:apply-templates select="CSChapter|CSChapterCode|CSChapterName|CSChapterRank"/>
            <xsl:apply-templates select="$cschapter-csitems" mode="just-csitems"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:copy>
    </xsl:for-each-group>
    <!-- Done! -->
  </xsl:template>
  
  <xsl:template match="KeyBenefitArea" mode="getkbas">
    <xsl:param name="featurecode"/>
    <xsl:copy>
      <xsl:attribute name="masterLastModified" select="../@masterLastModified"/>
      <xsl:attribute name="code" select="$featurecode"/>
      <xsl:apply-templates select="KeyBenefitAreaCode|KeyBenefitAreaName|KeyBenefitAreaRank|Feature[contains(FeatureCode,$featurecode)]" mode="substitute">
        <xsl:with-param name="original-code" select="$featurecode"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="node()|@*" mode="substitute">
    <xsl:param name="original-code"/>
    <xsl:choose>
      <xsl:when test="local-name() = 'FeatureCode'">
        <FeatureCode><xsl:value-of select="$original-code"/></FeatureCode>
      </xsl:when>
      <xsl:when test="local-name() = 'CSItemCode'">
        <CSItemCode><xsl:value-of select="$original-code"/></CSItemCode>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="node()|@*" mode="substitute">
            <xsl:with-param name="original-code" select="$original-code"/>
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="CSChapter" mode="getcschapters">
    <xsl:param name="csitemcode"/>
    <xsl:copy>
      <xsl:attribute name="masterLastModified" select="../@masterLastModified"/>
      <xsl:attribute name="code" select="$csitemcode"/>
      <xsl:apply-templates select="CSChapterCode|CSChapterName|CSChapterRank|CSItem[contains(CSItemCode,$csitemcode)]" mode="substitute">
        <xsl:with-param name="original-code" select="$csitemcode"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="CSItem" mode="just-csitems">
    <xsl:copy>
      <xsl:apply-templates select="CSItemCode|CSItemName|CSItemRank"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductReferencesContent|MasterProductAssetContent|MasterObjectAssetContent"/>
  
  <xsl:template match="Filters/Purpose[@type='Base']/Features/Feature">
    <xsl:if test="../../../../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product/KeyBenefitArea[exists(Feature[contains(FeatureCode,current()/@code)])]">
      <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="Filters/Purpose[@type='Base']/CSItems/CSItem">
    <xsl:if test="../../../../ProductReferencesContent/sql:rowset/sql:row/sql:data/Product/CSChapter[exists(CSItem[contains(CSItemCode,current()/@code)])]">
      <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
