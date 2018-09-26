<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:import href="base.xsl" />
    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="octl[sql:rowset/sql:row/sql:content_type='FMT_Translated']">
    <xsl:apply-templates select="sql:rowset/sql:row/sql:data/*"/>
  </xsl:template>
  
  <xsl:template match="octl[empty(sql:rowset/sql:row)]"/>
  <xsl:template match="octl[sql:rowset/sql:row/sql:content_type='FMT_Master']"/>
  <xsl:template match="octl[sql:rowset/sql:row/sql:content_type='ObjectAssetList']"/>

  <xsl:template match="attribute::IsMaster">
    <xsl:attribute name="IsMaster" select="'false'"/>
  </xsl:template>
  
  <xsl:template match="AssetList">
    <xsl:variable name="locale" select="ancestor::sql:row/sql:localisation"/>
    <xsl:variable name="productIsLocalized" select="ancestor::Node/@isLocalized = 'true'" />

    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ancestor::content/octl/sql:rowset/sql:row[sql:content_type='ObjectAssetList']/sql:data/object/Asset"/>
      <xsl:if test="$l-master-assets-from = 'masterdata'">
        <xsl:choose>
          <xsl:when test="substring($locale,1,2)='en' or $productIsLocalized">
            <xsl:apply-templates select="ancestor::content/octl/sql:rowset/sql:row[sql:content_type='FMT_Master']/sql:data/Node/AssetList/Asset[not(Language='en_US' and ResourceType='PSS')]"/>
          </xsl:when>
          <xsl:otherwise> 
            <xsl:apply-templates select="ancestor::content/octl/sql:rowset/sql:row[sql:content_type='FMT_Master']/sql:data/Node/AssetList/Asset "/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ObjectAssetlist">
    <xsl:if test="$l-master-assets-from = 'masterdata'">
      <xsl:apply-templates select="ancestor::content/octl/sql:rowset/sql:row[sql:content_type='FMT_Master']/sql:data/Node/ObjectAssetList/Object"/>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
