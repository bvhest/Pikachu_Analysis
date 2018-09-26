<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:local="http://pww.pkachu.philips.com/functions/local"
    extension-element-prefixes="local">

  <!-- 
    asset - a "compacted" Asset with the information stored in attributes (as created by extractAssetInfo.xsl)
  -->    
  <xsl:function name="local:get-asset-cache-dir">
    <xsl:param name="asset"/>
    <xsl:variable name="key" select="local:normalize-id($asset/@id)"/>
    
    <xsl:value-of select="concat($key,'/',$asset/@locale)"/>
  </xsl:function>

  <xsl:function name="local:get-asset-cache-filename">
    <xsl:param name="asset"/>
    <xsl:variable name="key" select="local:normalize-id($asset/@id)"/>
    <xsl:variable name="ext" select="if (ends-with($asset/@ccrsource,'.eps')) then 'pdf' else substring-after($asset/@ccrsource,'.')"/>
    <xsl:value-of select="concat(string-join((local:get-asset-cache-filename-base($asset),replace($asset/@modified,'[^0-9]','')),'-'),'.',$ext)"/>
  </xsl:function>

  <xsl:function name="local:get-asset-cache-filename-base">
    <xsl:param name="asset"/>
    <xsl:variable name="key" select="local:normalize-id($asset/@id)"/>
    <xsl:variable name="ext" select="if (ends-with($asset/@ccrsource,'.eps')) then 'pdf' else substring-after($asset/@ccrsource,'.')"/>
    <xsl:value-of select="string-join(($key,$asset/@locale,$asset/@type),'-')"/>
  </xsl:function>

  <xsl:function name="local:get-asset-cache-file-path">
    <xsl:param name="asset"/>
    
    <xsl:value-of select="concat(local:get-asset-cache-dir($asset), '/', local:get-asset-cache-filename($asset))"/>
  </xsl:function>
  
  <xsl:function name="local:get-raw-asset-cache-file-path">
    <xsl:param name="id"/>
    <xsl:param name="asset"/>
    <xsl:variable name="l-asset">
      <asset id="{$id}" type="{$asset/ResourceType}"
             locale="{if ($asset/Language='') then 'global' else $asset/Language}"
             modified="{replace($asset/Modified,'[^0-9]','')}"
             ccrsource="{substring-after($asset/InternalResourceIdentifier/text(),'/mprdata/')}"/>      
    </xsl:variable>
    <xsl:value-of select="concat(local:get-asset-cache-dir($l-asset/asset), '/', local:get-asset-cache-filename($l-asset/asset))"/>
  </xsl:function>

  <xsl:function name="local:normalize-id">
    <xsl:param name="id"/>
    <xsl:value-of select="replace($id,'/','_')"/>
  </xsl:function>
</xsl:stylesheet>