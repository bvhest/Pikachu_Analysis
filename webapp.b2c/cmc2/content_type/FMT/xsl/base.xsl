<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!--
    Specifies where to load master assets from:
    'masterdata' : load from FMT_Master
    'assetlist'  : load from AssteList or ObjectAssetList
  -->  
  <xsl:param name="master-assets-from"/>
  <xsl:variable name="l-master-assets-from" select="if ($master-assets-from = ('masterdata','assetlist')) then $master-assets-from else 'masterdata'"/>
   
</xsl:stylesheet>