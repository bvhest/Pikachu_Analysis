<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
  exclude-result-prefixes="sql"
  extension-element-prefixes="asset-f"
  >
  
  <xsl:import href="../../common/xsl/xUCDM-external-assets.xsl"/>

  <xsl:param name="timestamp"/>
  
  <xsl:template match="/root">
    <xsl:value-of select="concat('# deleted assets ', $timestamp)"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="sql:rowset/sql:row"/>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:variable name="tmp-asset">
      <Asset>
        <ResourceType><xsl:value-of select="sql:doctype"/></ResourceType>
        <InternalResourceIdentifier><xsl:value-of select="sql:asseturl"/></InternalResourceIdentifier>
      </Asset>
    </xsl:variable>
    
    <xsl:value-of select="asset-f:createScene7VideoId($tmp-asset)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>