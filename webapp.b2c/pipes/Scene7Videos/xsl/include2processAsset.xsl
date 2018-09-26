<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
  exclude-result-prefixes="sql"
  extension-element-prefixes="asset-f"
  >
  
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>
  
  <xsl:param name="srcDir"/>
  <xsl:param name="tgtDir"/>
  
  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="sql:rowset/sql:row"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:variable name="asset-src" select="concat($srcDir, substring-after(sql:srcurl,'mprdata'))"/>
    <xsl:variable name="tmp-asset">
      <Asset>
        <ResourceType><xsl:value-of select="sql:doctype"/></ResourceType>
        <InternalResourceIdentifier><xsl:value-of select="sql:srcurl"/></InternalResourceIdentifier>
      </Asset>
    </xsl:variable>
    <xsl:variable name="asset-tgt" select="concat($tgtDir, '/', asset-f:createScene7VideoId($tmp-asset/Asset), '.', tokenize($asset-src, '\.')[last()])"/>

    <asset ref="{sql:asset_ref}" src="{$asset-src}" tgt="{$asset-tgt}" md5="{sql:md5}">
      <i:include>
        <xsl:attribute name="src">
          <xsl:text>cocoon:/copyAsset?src=</xsl:text>
          <xsl:value-of select="$asset-src"/>
          <xsl:text>&amp;tgt=</xsl:text>
          <xsl:value-of select="$asset-tgt"/>
          <xsl:text>&amp;mimetype=</xsl:text>
          <xsl:value-of select="sql:mimetype"/>
        </xsl:attribute>
      </i:include>
    </asset>
  </xsl:template>
</xsl:stylesheet>