<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:shell="http://apache.org/cocoon/shell/1.0">
  
  <xsl:param name="source-file"/>
  <xsl:strip-space elements="*" />
  
  <xsl:variable name="relevant-asset-types-pmt" select="document('../config/doctypeConfig_PMT.xml')/imageconfigs/imageconfig/doctype" />
  <xsl:variable name="relevant-asset-types-fmt" select="document('../config/doctypeConfig_FMT.xml')/imageconfigs/imageconfig/doctype" />
  
  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="cache-compare">
    <xsl:variable name="inbox-version">
      <xsl:apply-templates select="Products[1]/Product" mode="filter-pmt"/>
      <xsl:apply-templates select="Nodes[1]/Node" mode="filter-fmt"/>
    </xsl:variable>
    <xsl:variable name="cached-version">
      <xsl:apply-templates select="Products[2]/Product" mode="filter-pmt"/>
      <xsl:apply-templates select="Nodes[2]/Node" mode="filter-fmt"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="deep-equal($inbox-version, $cached-version)">
        <entry id="{$inbox-version/CTN|$inbox-version/@code}">
          <message>Not modified.</message>
          <shell:delete>
            <shell:source><xsl:value-of select="$source-file"/></shell:source>
          </shell:delete>
        </entry>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="Products[1]|Nodes[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ignorable" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="filter-pmt"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Product" mode="filter-pmt">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="filter-pmt"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Node" mode="filter-fmt">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="filter-fmt"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- 
    Filter PMT's
  -->
  <xsl:template match="@lastModified|@masterLastModified|ProductDivision|ProductOwner|CRDateYW" mode="filter-pmt"/>
  <!-- Remove non relevant asset types -->
  <xsl:template match="AssetList/Asset[not(ResourceType=$relevant-asset-types-pmt)]" mode="filter-pmt"/>
  <xsl:template match="ObjectAssetList/Object[not(Asset/ResourceType=$relevant-asset-types-pmt)]" mode="filter-pmt"/>
  <xsl:template match="Asset[ancestor::Object][not(ResourceType=$relevant-asset-types-pmt)]" mode="filter-pmt"/>
  
  <!-- 
    Filter FMT's
  -->
  <xsl:template match="@lastModified|@masterLastModified" mode="filter-fmt"/>
  <!-- Remove non relevant asset types -->
  <xsl:template match="AssetList/Asset[not(ResourceType=$relevant-asset-types-fmt)]" mode="filter-fmt"/>
  <xsl:template match="ObjectAssetList/Object[not(Asset/ResourceType=$relevant-asset-types-fmt)]" mode="filter-fmt"/>
  <xsl:template match="Asset[ancestor::Object][not(ResourceType=$relevant-asset-types-fmt)]" mode="filter-fmt"/>
  
</xsl:stylesheet>
