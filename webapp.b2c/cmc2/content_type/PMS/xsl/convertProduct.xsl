<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:variable name="apos">'</xsl:variable>
  
  <!--
    Convert the PMT_Master data to query that retrieves Feature assets
    and retrieve localized product assets.
   -->
  <xsl:template match="sql:rowset[@name='MasterData']">
    <xsl:variable name="product" select="sql:row/sql:data/Product"/>
    <sql:execute-query>
      <sql:query name="ProductAssets">
        SELECT to_char(assets.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified
             , to_char(assets.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified
             , assets.localisation
             , assets.data
         from octl assets
        where assets.content_type='AssetList'
          and assets.localisation != 'master_global'
          and assets.object_id='<xsl:value-of select="$product/CTN" />'
      </sql:query>
    </sql:execute-query>
    
    <sql:execute-query>
      <!-- For some reason ObjectAssetList has (old) records with localisation='none' -->
      <sql:query name="FeatureAssets">
        SELECT to_char(objassets.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified
             , to_char(objassets.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified
             , objassets.localisation
             , objassets.data
         from octl objassets
        where objassets.content_type='ObjectAssetList'
          and objassets.localisation not in ('master_global', 'none')
          and objassets.object_id in ('<xsl:value-of select="string-join($product/KeyBenefitArea/Feature/FeatureCode,concat($apos,',',$apos))"/>')
      </sql:query>
    </sql:execute-query>
  </xsl:template>

  <xsl:template match="EvaluationData/Text">
    <xsl:copy copy-namespaces="no">
      <xsl:variable name="product" select="ancestor::entry/content/sql:rowset[@name='MasterData']/sql:row/sql:data/Product"/>
      <xsl:apply-templates select="$product/WOW|$product/SubWOW|$product/KeyBenefitArea|$product/MarketingTextHeader|$product/NamingString/Descriptor/DescriptorName" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="EvaluationData/Assets">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ancestor::entry/content/sql:rowset[@name='MasterData']/sql:row/sql:data/Product/AssetList/Asset">
        <xsl:with-param name="id" select="ancestor::entry/@o"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="EvaluationData/ObjectAssets">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ancestor::entry/content/sql:rowset[@name='MasterData']/sql:row/sql:data/Product/ObjectAssetList/Object/Asset"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Asset">
    <xsl:param name="id"/>
    <xsl:copy copy-namespaces="no">
      <Id><xsl:value-of select="if ($id != '') then $id else ../id"/></Id>
      <xsl:apply-templates select="ResourceType|Language|Extent|Creator|InternalResourceIdentifier"/>
    </xsl:copy>
  </xsl:template>
      
</xsl:stylesheet>
