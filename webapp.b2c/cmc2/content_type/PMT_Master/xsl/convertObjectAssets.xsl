<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 

  <xsl:template match="octl|sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>    

  <xsl:template match="sql:*"/>

  <xsl:template match="Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>   

  <xsl:template match="ObjectAssetList">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Object"/>
      <xsl:apply-templates select="octl/sql:rowset/sql:row/sql:data/object"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="object[../../sql:content_type='ObjectAssetList']">
    <Object>
      <id><xsl:value-of select="id"/></id>
      <xsl:apply-templates select="Asset"/>
    </Object>
  </xsl:template>
  
  <xsl:template match="store-outputs/*"/>
    
</xsl:stylesheet>
